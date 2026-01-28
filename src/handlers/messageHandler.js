const config = require('../config');
const commands = require('../commands');

// Store cooldowns per user
const cooldowns = new Map();

/**
 * Main message handler
 * @param {Client} client - WhatsApp client instance
 * @param {Message} message - Incoming message
 */
async function messageHandler(client, message) {
    const { body, from, fromMe } = message;

    // Get chat info
    const chat = await message.getChat();
    const isGroup = chat.isGroup;

    // Check if messages from groups/private should be processed
    if (isGroup && !config.features.groupMessages) return;
    if (!isGroup && !config.features.privateMessages) return;

    // Log messages if enabled
    if (config.features.logMessages) {
        const contact = await message.getContact();
        const chatName = isGroup ? chat.name : contact.pushname || contact.number;
        console.log(`[${isGroup ? 'GROUP' : 'PRIVATE'}] ${chatName}: ${body}`);
    }

    // Auto-read messages if enabled
    if (config.features.autoRead && !fromMe) {
        await chat.sendSeen();
    }

    // Check if message is a command
    if (!body.startsWith(config.prefix)) return;

    // Parse command and arguments
    const args = body.slice(config.prefix.length).trim().split(/\s+/);
    const commandName = args.shift().toLowerCase();

    // Find the command
    const command = commands.get(commandName) ||
                   commands.find(cmd => cmd.aliases && cmd.aliases.includes(commandName));

    if (!command) return;

    // Check cooldown
    if (config.cooldown.enabled && !fromMe) {
        const userId = from;
        const now = Date.now();

        if (cooldowns.has(userId)) {
            const expirationTime = cooldowns.get(userId) + config.cooldown.duration;

            if (now < expirationTime) {
                const timeLeft = ((expirationTime - now) / 1000).toFixed(1);
                return message.reply(`Please wait ${timeLeft}s before using another command.`);
            }
        }

        cooldowns.set(userId, now);

        // Clean up old cooldowns
        setTimeout(() => cooldowns.delete(userId), config.cooldown.duration);
    }

    // Check if command is owner-only
    if (command.ownerOnly) {
        const contact = await message.getContact();
        const userNumber = contact.number;

        if (userNumber !== config.ownerNumber) {
            return message.reply('This command is only available for the bot owner.');
        }
    }

    // Check if command is group-only
    if (command.groupOnly && !isGroup) {
        return message.reply('This command can only be used in groups.');
    }

    // Execute the command
    try {
        await command.execute(client, message, args);
    } catch (error) {
        console.error(`Error executing command ${commandName}:`, error);
        await message.reply('An error occurred while executing this command.');
    }
}

module.exports = messageHandler;
