module.exports = {
    name: 'everyone',
    aliases: ['all', 'tagall', 'mention'],
    description: 'Mention all members in a group',
    usage: '!everyone [message]',
    groupOnly: true,

    async execute(client, message, args) {
        const chat = await message.getChat();

        // Check if user is admin
        const participants = chat.participants;
        const sender = await message.getContact();
        const senderParticipant = participants.find(p => p.id._serialized === sender.id._serialized);

        if (!senderParticipant?.isAdmin && !senderParticipant?.isSuperAdmin) {
            return message.reply('❌ Only group admins can use this command.');
        }

        // Get all participants
        const mentions = [];
        let text = args.length > 0 ? args.join(' ') + '\n\n' : '📢 *Attention everyone!*\n\n';

        for (const participant of participants) {
            const contact = await client.getContactById(participant.id._serialized);
            mentions.push(contact);
            text += `@${participant.id.user} `;
        }

        await chat.sendMessage(text, { mentions });
    }
};
