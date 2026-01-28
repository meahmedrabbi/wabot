module.exports = {
    name: 'ping',
    aliases: ['p', 'pong'],
    description: 'Check if the bot is online and responsive',
    usage: '!ping',

    async execute(client, message, args) {
        const startTime = Date.now();

        // Send initial message
        const reply = await message.reply('🏓 Pinging...');

        const endTime = Date.now();
        const latency = endTime - startTime;

        // Edit with latency info
        let status = '🟢 Excellent';
        if (latency > 500) status = '🟡 Good';
        if (latency > 1000) status = '🟠 Moderate';
        if (latency > 2000) status = '🔴 Slow';

        const pingMessage = `🏓 *Pong!*\n\n` +
                          `⏱️ Latency: *${latency}ms*\n` +
                          `📊 Status: ${status}\n` +
                          `🤖 Bot: Online`;

        await message.reply(pingMessage);
    }
};
