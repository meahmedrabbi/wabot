const config = require('../config');

module.exports = {
    name: 'help',
    aliases: ['h', 'commands', 'menu'],
    description: 'Shows all available commands',
    usage: '!help [command]',

    async execute(client, message, args) {
        const prefix = config.prefix;

        // Load commands here to avoid circular dependency
        const commands = require('./index');

        // If a specific command is requested
        if (args.length > 0) {
            const commandName = args[0].toLowerCase();
            const command = commands.get(commandName) ||
                           commands.find(cmd => cmd.aliases && cmd.aliases.includes(commandName));

            if (!command) {
                return message.reply(`Command "${commandName}" not found.`);
            }

            let helpText = `*Command: ${prefix}${command.name}*\n\n`;
            helpText += `📝 Description: ${command.description || 'No description'}\n`;
            helpText += `📖 Usage: ${command.usage || `${prefix}${command.name}`}\n`;

            if (command.aliases && command.aliases.length > 0) {
                helpText += `🔄 Aliases: ${command.aliases.join(', ')}\n`;
            }

            if (command.groupOnly) helpText += `👥 Group only: Yes\n`;
            if (command.ownerOnly) helpText += `👑 Owner only: Yes\n`;

            return message.reply(helpText);
        }

        // Show all commands
        let helpMessage = `╭━━━━━━━━━━━━━━━━━━━━━╮\n`;
        helpMessage += `│   *${config.botName}*   │\n`;
        helpMessage += `╰━━━━━━━━━━━━━━━━━━━━━╯\n\n`;
        helpMessage += `*Available Commands:*\n\n`;

        // Build command list from Map
        const commandList = [];
        for (const [name, cmd] of commands) {
            commandList.push({
                name,
                description: cmd.description || 'No description',
                ownerOnly: cmd.ownerOnly || false,
                groupOnly: cmd.groupOnly || false
            });
        }

        // Sort alphabetically
        commandList.sort((a, b) => a.name.localeCompare(b.name));

        // Build command list
        for (const cmd of commandList) {
            let icon = '▸';
            if (cmd.ownerOnly) icon = '👑';
            else if (cmd.groupOnly) icon = '👥';

            helpMessage += `${icon} *${prefix}${cmd.name}*\n`;
            helpMessage += `   ${cmd.description}\n\n`;
        }

        helpMessage += `━━━━━━━━━━━━━━━━━━━━━\n`;
        helpMessage += `💡 Use *${prefix}help <command>* for detailed info\n`;
        helpMessage += `📌 Prefix: *${prefix}*`;

        await message.reply(helpMessage);
    }
};
