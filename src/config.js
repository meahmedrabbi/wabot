module.exports = {
    // Bot prefix for commands (e.g., /help, /ping)
    prefix: process.env.BOT_PREFIX || '/',

    // Bot owner's phone number (without + or spaces, e.g., 1234567890)
    ownerNumber: process.env.OWNER_NUMBER || '',

    // Bot name
    botName: process.env.BOT_NAME || 'WhatsApp Bot',

    // Enable/disable features
    features: {
        // Respond to messages in groups
        groupMessages: true,

        // Respond to private messages
        privateMessages: true,

        // Log all incoming messages to console
        logMessages: process.env.LOG_MESSAGES === 'true' || false,

        // Auto-read messages
        autoRead: process.env.AUTO_READ === 'true' || false
    },

    // Cooldown settings (in milliseconds)
    cooldown: {
        enabled: true,
        duration: 3000 // 3 seconds between commands per user
    },

    // Welcome message for new group members
    welcomeMessage: {
        enabled: false,
        message: 'Welcome to the group, {user}! 🎉'
    }
};
