require 'nokogiri'
require 'httparty'
require 'telegram/bot'


token = '307623077:AAFGiQtnFsb5kVvnKtzDedSUOUpEDVTVfnI'


def extract
	link = "https://pt.stackoverflow.com/questions/tagged/python"
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
			end
		end
	end
end


bot(token)