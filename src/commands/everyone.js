module.exports = {
    name: 'everyone',
    aliases: ['all', 'tagall', 'mention'],
    description: 'Mention all members in a group',
    usage: '!everyone [message]',
    groupOnly: true,

    async execute(sock, message, args) {
        const jid = message.from;

        try {
            // Get group metadata
            const groupMetadata = await sock.groupMetadata(jid);
            const participants = groupMetadata.participants;

            // Check if user is admin
            const senderJid = message.senderJid;
            const senderParticipant = participants.find(p => p.id === senderJid);

            if (!senderParticipant?.admin) {
                return message.reply('❌ Only group admins can use this command.');
            }

            // Get all participant JIDs for mentions
            const mentions = participants.map(p => p.id);
            let text = args.length > 0 ? args.join(' ') + '\n\n' : '📢 *Attention everyone!*\n\n';

            for (const participant of participants) {
                const number = participant.id.split('@')[0];
                text += `@${number} `;
            }

            // Send message with mentions
            await sock.sendMessage(jid, {
                text: text.trim(),
                mentions
            });

        } catch (error) {
            console.error('Everyone command error:', error);
            await message.reply('❌ Failed to tag everyone. Make sure the bot has permission to access group info.');
        }
    }
};
