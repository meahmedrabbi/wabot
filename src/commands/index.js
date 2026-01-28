const fs = require('fs');
const path = require('path');

// Create a collection for commands
const commands = new Map();

// Load all command files
const commandFiles = fs.readdirSync(__dirname).filter(file =>
    file.endsWith('.js') && file !== 'index.js'
);

for (const file of commandFiles) {
    const command = require(path.join(__dirname, file));

    if (command.name) {
        commands.set(command.name, command);
        console.log(`✓ Loaded command: ${command.name}`);
    }
}

// Add find method to Map for alias lookup
commands.find = function(predicate) {
    for (const [, command] of this) {
        if (predicate(command)) return command;
    }
    return undefined;
};

module.exports = commands;
