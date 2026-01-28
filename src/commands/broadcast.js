module.exports = {
    name: 'broadcast',
    aliases: ['bc', 'announce'],
    description: 'Broadcast a message to all groups (Owner only)',
    usage: '!broadcast <message>',
    ownerOnly: true,

    async execute(sock, message, args) {
        if (args.length === 0) {
            return message.reply('❌ Please provide a message to broadcast.\n\nUsage: !broadcast <message>');
        }

        const broadcastMessage = args.join(' ');

        await message.reply('📢 Starting broadcast to all groups...');

        try {
            // Get all groups the bot is in
            const groups = await sock.groupFetchAllParticipating();
            const groupIds = Object.keys(groups);

            if (groupIds.length === 0) {
                return message.reply('❌ Bot is not in any groups.');
            }

            let successCount = 0;
            let failCount = 0;

            for (const groupId of groupIds) {
                try {
                    await sock.sendMessage(groupId, {
                        text: `📢 *Broadcast Message*\n\n${broadcastMessage}`
                    });
                    successCount++;

                    // Add delay to prevent rate limiting
                    await new Promise(resolve => setTimeout(resolve, 1500));
                } catch (error) {
                    failCount++;
                    console.error(`Failed to send to ${groups[groupId].subject}:`, error.message);
                }
            }

            await message.reply(
                `✅ *Broadcast Complete*\n\n` +
                `📤 Sent to groups: ${successCount}\n` +
                `❌ Failed: ${failCount}`
            );

        } catch (error) {
            console.error('Broadcast error:', error);
            await message.reply('❌ An error occurred while broadcasting.');
        }
    }
};
