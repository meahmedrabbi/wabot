module.exports = {
    name: 'sticker',
    aliases: ['s', 'stiker', 'stick'],
    description: 'Convert an image or video to a sticker',
    usage: '!sticker (reply to or send with an image/video)',

    async execute(sock, message, args) {
        const jid = message.from;
        let mediaMessage = null;

        // Check if message has media
        if (message.hasMedia()) {
            mediaMessage = message;
        }
        // Check if it's a reply to a message with media
        else {
            const quoted = message.getQuotedMessage();
            if (quoted) {
                const quotedMsg = quoted.message;
                if (quotedMsg?.imageMessage || quotedMsg?.videoMessage || quotedMsg?.stickerMessage) {
                    mediaMessage = quoted;
                }
            }
        }

        // No media found
        if (!mediaMessage) {
            return message.reply(
                '❌ *No media found!*\n\n' +
                'Please send an image/video with the command, or reply to an image/video with !sticker'
            );
        }

        try {
            await message.reply('⏳ Creating sticker...');

            // Download media
            const { downloadMediaMessage } = require('@whiskeysockets/baileys');
            const buffer = await downloadMediaMessage(mediaMessage, 'buffer', {});

            // Send as sticker
            await sock.sendMessage(jid, {
                sticker: buffer
            }, { quoted: message });

        } catch (error) {
            console.error('Sticker creation error:', error);
            await message.reply('❌ Failed to create sticker. The media might be too large or in an unsupported format.');
        }
    }
};
