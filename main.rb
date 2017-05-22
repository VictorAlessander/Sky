require 'nokogiri'
require 'httparty'
require 'telegram/bot'


token = '307623077:AAFGiQtnFsb5kVvnKtzDedSUOUpEDVTVfnI'


def extract(tag)
	link = "https://pt.stackoverflow.com/questions/tagged/#{tag}"
	response = HTTParty.get(link)
	content = Nokogiri::HTML(response)

	result = content.css('a[class=question-hyperlink]')

	return result.last.text
end


def bot(token)
	Telegram::Bot::Client.run(token) do |bot|
		bot.listen do |message|
			case message.text
			when '/stackoverflow'
				bot.api.send_message(chat_id: message.chat.id, text: extract)
			when '/stackoverflow php'
				bot.api.send_message(chat_id: message.chat.id, text: extract('php'))
			when '/stackoverflow javascript'
				bot.api.send_message(chat_id: message.chat.id, text: extract('javascript'))
			when '/stackoverflow c#'
				bot.api.send_message(chat_id: message.chat.id, text: extract('c#'))
			when '/stackoverflow python'
				bot.api.send_message(chat_id: message.chat.id, text: extract('python'))
			end
		end
	end
end


bot(token)
