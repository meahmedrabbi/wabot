module.exports = {
    name: 'calc',
    aliases: ['calculate', 'math'],
    description: 'Perform basic mathematical calculations',
    usage: '!calc <expression> (e.g., !calc 5 + 3 * 2)',

    async execute(client, message, args) {
        if (args.length === 0) {
            return message.reply(
                '❌ Please provide a mathematical expression.\n\n' +
                '*Usage:* !calc <expression>\n' +
                '*Examples:*\n' +
                '▸ !calc 5 + 3\n' +
                '▸ !calc 10 * 5 - 3\n' +
                '▸ !calc (5 + 3) * 2\n' +
                '▸ !calc 100 / 4'
            );
        }

        const expression = args.join(' ');

        // Validate expression (only allow safe characters)
        const safePattern = /^[\d\s+\-*/().%^]+$/;
        if (!safePattern.test(expression)) {
            return message.reply('❌ Invalid expression. Only numbers and basic operators (+, -, *, /, %, ^, ()) are allowed.');
        }

        try {
            // Replace ^ with ** for exponentiation
            const sanitized = expression.replace(/\^/g, '**');

            // Evaluate the expression safely
            const result = Function(`"use strict"; return (${sanitized})`)();

            if (typeof result !== 'number' || !isFinite(result)) {
                return message.reply('❌ Invalid result. Please check your expression.');
            }

            // Format result
            const formattedResult = Number.isInteger(result)
                ? result.toString()
                : result.toFixed(6).replace(/\.?0+$/, '');

            const calcMessage = `🧮 *Calculator*\n\n` +
                `📝 Expression: \`${expression}\`\n` +
                `✅ Result: *${formattedResult}*`;

            await message.reply(calcMessage);

        } catch (error) {
            await message.reply('❌ Error evaluating expression. Please check the syntax.');
        }
    }
};
