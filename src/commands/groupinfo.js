module.exports = {
    name: 'groupinfo',
    aliases: ['gi', 'group', 'ginfo'],
    description: 'Shows information about the current group',
    usage: '!groupinfo',
    groupOnly: true,

    async execute(client, message, args) {
        const chat = await message.getChat();

        // Get group metadata
        const groupName = chat.name;
        const groupDesc = chat.description || 'No description';
        const participants = chat.participants;
        const totalMembers = participants.length;

        // Count admins
        const admins = participants.filter(p => p.isAdmin || p.isSuperAdmin);
        const adminCount = admins.length;

        // Get creation date if available
        const createdAt = chat.createdAt
            ? new Date(chat.createdAt * 1000).toLocaleDateString()
            : 'Unknown';

        // Build admin list
        let adminList = '';
        for (const admin of admins.slice(0, 5)) { // Show max 5 admins
            const contact = await client.getContactById(admin.id._serialized);
            adminList += `▸ ${contact.pushname || contact.number}\n`;
        }
        if (admins.length > 5) {
            adminList += `▸ ... and ${admins.length - 5} more`;
        }

        const infoMessage = `📊 *Group Information*\n\n` +
            `📛 *Name:* ${groupName}\n` +
            `👥 *Members:* ${totalMembers}\n` +
            `👑 *Admins:* ${adminCount}\n` +
            `📅 *Created:* ${createdAt}\n\n` +
            `📝 *Description:*\n${groupDesc}\n\n` +
            `👑 *Admin List:*\n${adminList}`;

        await message.reply(infoMessage);
    }
};
