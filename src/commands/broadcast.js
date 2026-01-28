module.exports = {
    name: 'broadcast',
    aliases: ['bc', 'announce'],
    description: 'Broadcast a message to all chats (Owner only)',
    usage: '!broadcast <message>',
    ownerOnly: true,

    async execute(client, message, args) {
        if (args.length === 0) {
            return message.reply('❌ Please provide a message to broadcast.\n\nUsage: !broadcast <message>');
        }

        const broadcastMessage = args.join(' ');

        await message.reply('📢 Starting broadcast...');

        try {
            const chats = await client.getChats();
            let successCount = 0;
            let failCount = 0;

            for (const chat of chats) {
                // Skip status broadcast
                if (chat.id._serialized === 'status@broadcast') continue;

                try {
                    await chat.sendMessage(`📢 *Broadcast Message*\n\n${broadcastMessage}`);
                    successCount++;

                    // Add delay to prevent rate limiting
                    await new Promise(resolve => setTimeout(resolve, 1000));
                } catch (error) {
                    failCount++;
                    console.error(`Failed to send to ${chat.name}:`, error.message);
                }
            }

            await message.reply(
                `✅ *Broadcast Complete*\n\n` +
                `📤 Sent: ${successCount}\n` +
                `❌ Failed: ${failCount}`
            );

        } catch (error) {
            console.error('Broadcast error:', error);
            await message.reply('❌ An error occurred while broadcasting.');
        }
    }
};
