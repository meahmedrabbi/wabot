# WhatsApp Bot (100% Free)

A completely free WhatsApp bot built with [Baileys](https://github.com/WhiskeySockets/Baileys). No paid APIs or Chrome/Puppeteer required!

## Features

- **Free Forever** - Uses WhatsApp Web protocol, no paid API needed
- **No Chrome Required** - Unlike other libraries, Baileys doesn't need Puppeteer/Chrome
- **Low Memory Usage** - Runs smoothly on low-end VPS (512MB RAM is enough)
- **Easy Setup** - Just scan QR code with your phone
- **Persistent Session** - Stay logged in across restarts
- **Command System** - Extensible command handler with cooldowns
- **Sticker Maker** - Convert images/videos to stickers
- **Group Features** - Tag everyone, group info, admin-only commands
- **Fun Commands** - Jokes, quotes, calculator, and more

## Requirements

- Node.js 18 or higher
- A WhatsApp account
- VPS or local machine (for 24/7 operation)

## Quick Start

### 1. Clone and Install

```bash
git clone <repository-url>
cd wabot
npm install
```

### 2. Configure (Optional)

```bash
cp .env.example .env
# Edit .env with your preferences
```

### 3. Run the Bot

```bash
npm start
```

### 4. Scan QR Code

- Open WhatsApp on your phone
- Go to **Settings > Linked Devices > Link a Device**
- Scan the QR code displayed in the terminal

## Available Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `!help` | `!h`, `!menu` | Show all commands |
| `!ping` | `!p` | Check bot status |
| `!info` | `!about` | Bot information |
| `!sticker` | `!s` | Convert image to sticker |
| `!everyone` | `!all` | Tag all group members |
| `!groupinfo` | `!gi` | Show group information |
| `!joke` | `!j` | Get a random joke |
| `!quote` | `!q` | Get inspirational quote |
| `!calc` | `!math` | Calculator |
| `!owner` | `!dev` | Bot owner info |
| `!broadcast` | `!bc` | Send to all groups (owner only) |

## Adding New Commands

Create a new file in `src/commands/`:

```javascript
// src/commands/mycommand.js
module.exports = {
    name: 'mycommand',
    aliases: ['mc', 'mycmd'],
    description: 'Description of your command',
    usage: '!mycommand [args]',
    groupOnly: false,  // Set true for group-only commands
    ownerOnly: false,  // Set true for owner-only commands

    async execute(sock, message, args) {
        // sock = Baileys socket instance
        // message = message wrapper with helper methods
        // args = command arguments array

        await message.reply('Hello from my command!');

        // Send with reaction
        await message.react('👍');

        // Send to specific chat
        await sock.sendMessage(message.from, { text: 'Hello!' });
    }
};
```

## Configuration Options

Edit `src/config.js` or use environment variables:

| Option | Default | Description |
|--------|---------|-------------|
| `BOT_PREFIX` | `!` | Command prefix |
| `BOT_NAME` | `WhatsApp Bot` | Bot display name |
| `OWNER_NUMBER` | - | Your phone number (for owner commands) |
| `LOG_MESSAGES` | `false` | Log all incoming messages |
| `AUTO_READ` | `false` | Auto-mark messages as read |

## Running 24/7

### Using PM2 (Recommended)

```bash
# Install PM2
npm install -g pm2

# Start the bot
pm2 start src/index.js --name "wabot"

# Save process list
pm2 save

# Setup auto-start on reboot
pm2 startup
```

### Using Screen

```bash
screen -S wabot
npm start
# Press Ctrl+A, then D to detach
```

## Troubleshooting

### QR Code Not Showing
- Make sure you have a terminal that supports Unicode
- Try a different terminal emulator

### Session Expired
- Delete the `session/` folder
- Restart the bot and scan QR again

### Connection Issues
- Make sure your VPS has internet access
- Check if WhatsApp Web is accessible from your region
- Try restarting the bot

### Memory Usage
Baileys is lightweight and typically uses only 50-150MB RAM. If you're experiencing high memory usage, check for memory leaks in custom commands.

## Project Structure

```
wabot/
├── src/
│   ├── index.js          # Main entry point
│   ├── config.js         # Configuration
│   ├── handlers/
│   │   └── messageHandler.js
│   ├── commands/
│   │   ├── index.js      # Command loader
│   │   ├── help.js
│   │   ├── ping.js
│   │   ├── sticker.js
│   │   └── ...
│   └── utils/
├── session/              # WhatsApp session (gitignored)
├── .env                  # Environment variables (gitignored)
├── .env.example
├── package.json
└── README.md
```

## Why Baileys?

| Feature | Baileys | whatsapp-web.js |
|---------|---------|-----------------|
| Chrome Required | No | Yes |
| RAM Usage | ~50-150MB | ~500MB-1GB |
| Setup Complexity | Simple | Complex (needs Chrome deps) |
| Speed | Fast | Slower |
| VPS Friendly | Yes | Requires more resources |

## Disclaimer

This bot is for personal and educational use. Using bots on WhatsApp may violate their Terms of Service. Use at your own risk.

## License

MIT License - Feel free to use and modify!
