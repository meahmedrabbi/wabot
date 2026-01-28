const { MessageMedia } = require('whatsapp-web.js');

module.exports = {
    name: 'sticker',
    aliases: ['s', 'stiker', 'stick'],
    description: 'Convert an image or video to a sticker',
    usage: '!sticker (reply to or send with an image/video)',

    async execute(client, message, args) {
        let media;

        // Check if message has media
        if (message.hasMedia) {
            media = await message.downloadMedia();
        }
        // Check if it's a reply to a message with media
        else if (message.hasQuotedMsg) {
            const quotedMsg = await message.getQuotedMessage();
            if (quotedMsg.hasMedia) {
                media = await quotedMsg.downloadMedia();
            }
        }

        // No media found
        if (!media) {
            return message.reply(
                '❌ *No media found!*\n\n' +
                'Please send an image/video with the command, or reply to an image/video with !sticker'
            );
        }

        // Check media type
        const validTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4'];
        if (!validTypes.some(type => media.mimetype.includes(type.split('/')[1]))) {
            return message.reply('❌ Invalid media type. Please send an image, GIF, or short video.');
        }

        try {
            await message.reply('⏳ Creating sticker...');

            // Send as sticker
            await client.sendMessage(message.from, media, {
                sendMediaAsSticker: true,
                stickerName: args.join(' ') || 'WhatsApp Bot',
                stickerAuthor: 'WA Bot'
            });

        } catch (error) {
            console.error('Sticker creation error:', error);
            await message.reply('❌ Failed to create sticker. The media might be too large or in an unsupported format.');
        }
    }
};
