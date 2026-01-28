const config = require('../config');
const os = require('os');

module.exports = {
    name: 'info',
    aliases: ['botinfo', 'about', 'status'],
    description: 'Shows bot information and status',
    usage: '!info',

    async execute(client, message, args) {
        // Calculate uptime
        const uptime = process.uptime();
        const days = Math.floor(uptime / 86400);
        const hours = Math.floor((uptime % 86400) / 3600);
        const minutes = Math.floor((uptime % 3600) / 60);
        const seconds = Math.floor(uptime % 60);

        let uptimeString = '';
        if (days > 0) uptimeString += `${days}d `;
        if (hours > 0) uptimeString += `${hours}h `;
        if (minutes > 0) uptimeString += `${minutes}m `;
        uptimeString += `${seconds}s`;

        // Memory usage
        const memUsage = process.memoryUsage();
        const memUsedMB = (memUsage.heapUsed / 1024 / 1024).toFixed(2);
        const memTotalMB = (memUsage.heapTotal / 1024 / 1024).toFixed(2);

        // System info
        const cpuModel = os.cpus()[0]?.model || 'Unknown';
        const platform = os.platform();
        const nodeVersion = process.version;

        const infoMessage = `╭━━━━━━━━━━━━━━━━━━━━━╮
│   *${config.botName}*   │
╰━━━━━━━━━━━━━━━━━━━━━╯

*📊 Bot Statistics:*
▸ Status: 🟢 Online
▸ Uptime: ${uptimeString}
▸ Prefix: ${config.prefix}

*💻 System Info:*
▸ Platform: ${platform}
▸ Node.js: ${nodeVersion}
▸ Memory: ${memUsedMB}MB / ${memTotalMB}MB

*⚙️ Features:*
▸ Group Messages: ${config.features.groupMessages ? '✅' : '❌'}
▸ Private Messages: ${config.features.privateMessages ? '✅' : '❌'}
▸ Auto Read: ${config.features.autoRead ? '✅' : '❌'}

━━━━━━━━━━━━━━━━━━━━━
*Powered by Baileys*
💡 100% Free - No Chrome needed!`;

        await message.reply(infoMessage);
    }
};
