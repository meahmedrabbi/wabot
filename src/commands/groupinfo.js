module.exports = {
    name: 'groupinfo',
    aliases: ['gi', 'group', 'ginfo'],
    description: 'Shows information about the current group',
    usage: '!groupinfo',
    groupOnly: true,

    async execute(sock, message, args) {
        const jid = message.from;

        try {
            // Get group metadata
            const groupMetadata = await sock.groupMetadata(jid);

            const groupName = groupMetadata.subject;
            const groupDesc = groupMetadata.desc || 'No description';
            const participants = groupMetadata.participants;
            const totalMembers = participants.length;

            // Count admins
            const admins = participants.filter(p => p.admin === 'admin' || p.admin === 'superadmin');
            const adminCount = admins.length;

            // Get creation date
            const createdAt = groupMetadata.creation
                ? new Date(groupMetadata.creation * 1000).toLocaleDateString()
                : 'Unknown';

            // Build admin list
            let adminList = '';
            for (const admin of admins.slice(0, 5)) {
                const number = admin.id.split('@')[0];
                const role = admin.admin === 'superadmin' ? '(Owner)' : '';
                adminList += `▸ ${number} ${role}\n`;
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

        } catch (error) {
            console.error('Groupinfo command error:', error);
            await message.reply('❌ Failed to get group info. Make sure the bot has permission to access group info.');
        }
    }
};
