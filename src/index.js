const {
    default: makeWASocket,
    DisconnectReason,
    useMultiFileAuthState,
    fetchLatestBaileysVersion
} = require('@whiskeysockets/baileys');
const qrcode = require('qrcode-terminal');
const pino = require('pino');
require('dotenv').config();

const config = require('./config');
const messageHandler = require('./handlers/messageHandler');

// Main function to start the bot
async function startBot() {
    // Load authentication state from file
    const { state, saveCreds } = await useMultiFileAuthState('./session');

    // Get latest Baileys version
    const { version } = await fetchLatestBaileysVersion();
    console.log(`🔄 Using WA v${version.join('.')}`);

    // Create the socket connection
    const sock = makeWASocket({
        version,
        logger: pino({ level: 'silent' }),
        printQRInTerminal: false, // We'll handle QR manually for better display
        auth: state,
        browser: ['WhatsApp Bot', 'Chrome', '120.0.0'],
        syncFullHistory: false,
        markOnlineOnConnect: true
    });

    // Handle connection updates
    sock.ev.on('connection.update', async (update) => {
        const { connection, lastDisconnect, qr } = update;

        // Display QR code
        if (qr) {
            console.log('\n📱 Scan this QR code with your WhatsApp:\n');
            qrcode.generate(qr, { small: true });
            console.log('\nOpen WhatsApp > Settings > Linked Devices > Link a Device\n');
        }

        // Connection opened
        if (connection === 'open') {
            const user = sock.user;
            console.log('✅ WhatsApp Bot is ready!');
            console.log(`📱 Logged in as: ${user?.name || 'Unknown'}`);
            console.log(`📞 Phone number: ${user?.id?.split(':')[0] || 'Unknown'}`);
            console.log(`\n🤖 Bot is now listening for messages...`);
            console.log(`💡 Send "${config.prefix}help" to any chat to see available commands\n`);
        }

        // Connection closed
        if (connection === 'close') {
            const shouldReconnect = lastDisconnect?.error?.output?.statusCode !== DisconnectReason.loggedOut;

            console.log('📴 Connection closed:', lastDisconnect?.error?.message || 'Unknown reason');

            if (shouldReconnect) {
                console.log('🔄 Reconnecting...');
                startBot();
            } else {
                console.log('❌ Logged out. Please delete the session folder and restart.');
            }
        }
    });

    // Save credentials when they update
    sock.ev.on('creds.update', saveCreds);

    // Handle incoming messages
    sock.ev.on('messages.upsert', async ({ messages, type }) => {
        // Only process new messages (not history sync)
        if (type !== 'notify') return;

        for (const message of messages) {
            // Skip if no message content
            if (!message.message) continue;

            // Skip status broadcasts
            if (message.key.remoteJid === 'status@broadcast') continue;

            try {
                await messageHandler(sock, message);
            } catch (error) {
                console.error('Error handling message:', error);
            }
        }
    });

    // Handle group participants update (joins/leaves)
    sock.ev.on('group-participants.update', async (update) => {
        const { id, participants, action } = update;

        if (action === 'add' && config.welcomeMessage.enabled) {
            const chat = id;
            for (const participant of participants) {
                const welcomeMsg = config.welcomeMessage.message.replace('{user}', `@${participant.split('@')[0]}`);
                await sock.sendMessage(chat, {
                    text: welcomeMsg,
                    mentions: [participant]
                });
            }
        }
    });

    return sock;
}

// Handle process termination gracefully
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down gracefully...');
    process.exit(0);
});

process.on('SIGTERM', () => {
    console.log('\n🛑 Shutting down gracefully...');
    process.exit(0);
});

// Start the bot
console.log('🚀 Starting WhatsApp Bot...');
console.log('⏳ Please wait while initializing...\n');
startBot().catch(console.error);
