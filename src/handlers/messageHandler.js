const config = require('../config');
const commands = require('../commands');

// Store cooldowns per user
const cooldowns = new Map();

/**
 * Extract text content from Baileys message
 * @param {object} message - Baileys message object
 * @returns {string} - Message text content
 */
function getMessageText(message) {
    const msg = message.message;
    if (!msg) return '';

    return (
        msg.conversation ||
        msg.extendedTextMessage?.text ||
        msg.imageMessage?.caption ||
        msg.videoMessage?.caption ||
        msg.documentMessage?.caption ||
        ''
    );
}

/**
 * Check if message is from a group
 * @param {string} jid - Chat JID
 * @returns {boolean}
 */
function isGroupJid(jid) {
    return jid.endsWith('@g.us');
}

/**
 * Get sender JID from message
 * @param {object} message - Baileys message object
 * @returns {string} - Sender JID
 */
function getSenderJid(message) {
    return message.key.participant || message.key.remoteJid;
}

/**
 * Reply to a message
 * @param {object} sock - Baileys socket
 * @param {object} message - Original message
 * @param {string} text - Reply text
 */
async function reply(sock, message, text) {
    const jid = message.key.remoteJid;
    await sock.sendMessage(jid, { text }, { quoted: message });
}

/**
 * Main message handler for Baileys
 * @param {object} sock - Baileys socket instance
 * @param {object} message - Incoming message
 */
async function messageHandler(sock, message) {
    const jid = message.key.remoteJid;
    const fromMe = message.key.fromMe;
    const body = getMessageText(message);
    const isGroup = isGroupJid(jid);
    const senderJid = getSenderJid(message);

    // Check if messages from groups/private should be processed
    if (isGroup && !config.features.groupMessages) return;
    if (!isGroup && !config.features.privateMessages) return;

    // Log messages if enabled
    if (config.features.logMessages) {
        const senderNumber = senderJid.split('@')[0];
        console.log(`[${isGroup ? 'GROUP' : 'PRIVATE'}] ${senderNumber}: ${body}`);
    }

    // Auto-read messages if enabled
    if (config.features.autoRead && !fromMe) {
        await sock.readMessages([message.key]);
    }

    // Check if message is a command
    if (!body || !body.startsWith(config.prefix)) return;

    // Parse command and arguments
    const args = body.slice(config.prefix.length).trim().split(/\s+/);
    const commandName = args.shift().toLowerCase();

    // Find the command
    const command = commands.get(commandName) ||
                   commands.find(cmd => cmd.aliases && cmd.aliases.includes(commandName));

    if (!command) return;

    // Check cooldown
    if (config.cooldown.enabled && !fromMe) {
        const userId = senderJid;
        const now = Date.now();

        if (cooldowns.has(userId)) {
            const expirationTime = cooldowns.get(userId) + config.cooldown.duration;

            if (now < expirationTime) {
                const timeLeft = ((expirationTime - now) / 1000).toFixed(1);
                return reply(sock, message, `Please wait ${timeLeft}s before using another command.`);
            }
        }

        cooldowns.set(userId, now);

        // Clean up old cooldowns
        setTimeout(() => cooldowns.delete(userId), config.cooldown.duration);
    }

    // Check if command is owner-only
    if (command.ownerOnly) {
        const userNumber = senderJid.split('@')[0];

        if (userNumber !== config.ownerNumber) {
            return reply(sock, message, 'This command is only available for the bot owner.');
        }
    }

    // Check if command is group-only
    if (command.groupOnly && !isGroup) {
        return reply(sock, message, 'This command can only be used in groups.');
    }

    // Create a wrapper object with helper methods for commands
    const messageWrapper = {
        ...message,
        body,
        from: jid,
        fromMe,
        isGroup,
        senderJid,
        reply: async (text) => reply(sock, message, text),
        react: async (emoji) => {
            await sock.sendMessage(jid, {
                react: { text: emoji, key: message.key }
            });
        },
        // Get quoted message
        getQuotedMessage: () => {
            const contextInfo = message.message?.extendedTextMessage?.contextInfo;
            return contextInfo?.quotedMessage ? {
                message: contextInfo.quotedMessage,
                key: {
                    remoteJid: jid,
                    fromMe: contextInfo.participant === sock.user?.id,
                    id: contextInfo.stanzaId,
                    participant: contextInfo.participant
                }
            } : null;
        },
        // Check if message has media
        hasMedia: () => {
            const msg = message.message;
            return !!(msg?.imageMessage || msg?.videoMessage || msg?.audioMessage || msg?.documentMessage || msg?.stickerMessage);
        },
        // Download media
        downloadMedia: async () => {
            const { downloadMediaMessage } = require('@whiskeysockets/baileys');
            return downloadMediaMessage(message, 'buffer', {});
        }
    };

    // Execute the command
    try {
        await command.execute(sock, messageWrapper, args);
    } catch (error) {
        console.error(`Error executing command ${commandName}:`, error);
        await reply(sock, message, 'An error occurred while executing this command.');
    }
}

module.exports = messageHandler;
