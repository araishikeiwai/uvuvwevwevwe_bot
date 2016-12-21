class Object.const_get($namespace_class)::InputProcessor
  include SuckerPunch::Job
  workers 5

  def perform(message, bot)
    @bot = bot

    return unless message
    return if message.edit_date
    return unless message.text
    return unless Time.now.to_i - message.date <= 20

    text = message.text.sub("@#{$bot_username}", '')

    if message.from.id == $admin_id && text =~ /reload/i
      UvuvwevwevweBot.reload!
      reply(message, 'Reloaded!')
      return
    end

    if text =~ /(?:nama|name)/i && text =~ /(?:siapa|what)/i
      return unless UvuvwevwevweBot::SpamUtil.add?(message.chat.id, message.chat.type.in?(%w(group supergroup)))
      reply(message, 'Uvuvwevwevwe Onyetenyevwe Ugwemubwem Ossas')
    end
    # ADD YOUR BOT LOGIC HERE
  end

  private

  # ADD AUXILIARY METHODS HERE

  def reply(message, text)
    send(chat_id: message.chat.id, text: text, reply_to_message_id: message.message_id)
  end

  def send(options = {})
    $namespace_class.constantize::MessageSender.perform_async(@bot, options)
  end
end
