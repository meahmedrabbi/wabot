const jokes = [
    {
        setup: "Why do programmers prefer dark mode?",
        punchline: "Because light attracts bugs!"
    },
    {
        setup: "Why did the developer go broke?",
        punchline: "Because he used up all his cache!"
    },
    {
        setup: "What's a programmer's favorite hangout place?",
        punchline: "Foo Bar!"
    },
    {
        setup: "Why do Java developers wear glasses?",
        punchline: "Because they don't C#!"
    },
    {
        setup: "What do you call 8 hobbits?",
        punchline: "A hobbyte!"
    },
    {
        setup: "Why did the computer go to the doctor?",
        punchline: "Because it had a virus!"
    },
    {
        setup: "What's a computer's least favorite food?",
        punchline: "Spam!"
    },
    {
        setup: "Why was the JavaScript developer sad?",
        punchline: "Because he didn't Node how to Express himself!"
    },
    {
        setup: "What do you call a computer that sings?",
        punchline: "A-Dell!"
    },
    {
        setup: "Why did the PowerPoint presentation cross the road?",
        punchline: "To get to the other slide!"
    },
    {
        setup: "What's a robot's favorite type of music?",
        punchline: "Heavy metal!"
    },
    {
        setup: "Why don't scientists trust atoms?",
        punchline: "Because they make up everything!"
    },
    {
        setup: "What do you call a fake noodle?",
        punchline: "An impasta!"
    },
    {
        setup: "Why did the scarecrow win an award?",
        punchline: "He was outstanding in his field!"
    },
    {
        setup: "What do you call a bear with no teeth?",
        punchline: "A gummy bear!"
    }
];

module.exports = {
    name: 'joke',
    aliases: ['j', 'funny', 'laugh'],
    description: 'Get a random joke',
    usage: '!joke',

    async execute(client, message, args) {
        const joke = jokes[Math.floor(Math.random() * jokes.length)];

        const jokeMessage = `😄 *Random Joke*\n\n` +
                          `${joke.setup}\n\n` +
                          `_${joke.punchline}_ 😂`;

        await message.reply(jokeMessage);
    }
};
