const config = require('../config');

module.exports = {
    name: 'owner',
    aliases: ['creator', 'dev', 'developer'],
    description: 'Shows bot owner information',
    usage: '!owner',

    async execute(client, message, args) {
        const ownerMessage = `👑 *Bot Owner Information*\n\n` +
                           `This bot is a private instance.\n\n` +
                           `📱 Contact the owner for:\n` +
                           `▸ Bug reports\n` +
                           `▸ Feature requests\n` +
                           `▸ General inquiries\n\n` +
                           `━━━━━━━━━━━━━━━━━━━━━\n` +
                           `💡 Want your own bot?\n` +
                           `This bot is open source and free!`;

        await message.reply(ownerMessage);
    }
};
