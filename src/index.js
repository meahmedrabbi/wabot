const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
require('dotenv').config();

const config = require('./config');
const messageHandler = require('./handlers/messageHandler');

// Initialize WhatsApp client with local authentication (saves session)
const client = new Client({
    authStrategy: new LocalAuth({
        dataPath: './session'
    }),
    puppeteer: {
        headless: true,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
            '--disable-accelerated-2d-canvas',
            '--no-first-run',
            '--no-zygote',
            '--disable-gpu'
        ]
    }
});

// QR Code event - scan this with your WhatsApp
client.on('qr', (qr) => {
    console.log('\n📱 Scan this QR code with your WhatsApp:\n');
    qrcode.generate(qr, { small: true });
    console.log('\nOpen WhatsApp > Settings > Linked Devices > Link a Device\n');
});

// Ready event - bot is connected
client.on('ready', () => {
    console.log('✅ WhatsApp Bot is ready!');
    console.log(`📱 Logged in as: ${client.info.pushname}`);
    console.log(`📞 Phone number: ${client.info.wid.user}`);
    console.log(`\n🤖 Bot is now listening for messages...`);
    console.log(`💡 Send "${config.prefix}help" to any chat to see available commands\n`);
});

// Authentication success
client.on('authenticated', () => {
    console.log('🔐 Authentication successful!');
});

// Authentication failure
client.on('auth_failure', (msg) => {
    console.error('❌ Authentication failed:', msg);
});

// Disconnected
client.on('disconnected', (reason) => {
    console.log('📴 Client disconnected:', reason);
    console.log('🔄 Attempting to reconnect...');
    client.initialize();
});

// Message event - handle incoming messages
client.on('message', async (message) => {
    try {
        await messageHandler(client, message);
    } catch (error) {
        console.error('Error handling message:', error);
    }
});

// Message creation event (includes own messages)
client.on('message_create', async (message) => {
    // Only process if it's from the bot itself and starts with prefix
    if (message.fromMe && message.body.startsWith(config.prefix)) {
        try {
            await messageHandler(client, message);
        } catch (error) {
            console.error('Error handling own message:', error);
        }
    }
});

// Group join event
client.on('group_join', async (notification) => {
    console.log(`👋 Someone joined a group`);
    // You can send a welcome message here
    // const chat = await notification.getChat();
    // chat.sendMessage('Welcome to the group! 🎉');
});

// Handle process termination gracefully
process.on('SIGINT', async () => {
    console.log('\n🛑 Shutting down gracefully...');
    await client.destroy();
    process.exit(0);
});

process.on('SIGTERM', async () => {
    console.log('\n🛑 Shutting down gracefully...');
    await client.destroy();
    process.exit(0);
});

// Initialize the client
console.log('🚀 Starting WhatsApp Bot...');
console.log('⏳ Please wait while initializing...\n');
client.initialize();
