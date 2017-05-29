require 'nokogiri'
require 'httparty'
require 'telegram/bot'


token = '307623077:AAFGiQtnFsb5kVvnKtzDedSUOUpEDVTVfnI'


def extract(tag)
	link = "https://pt.stackoverflow.com/questions/tagged/#{tag}"
	response = HTTParty.get(link)
	content = Nokogiri::HTML(response)

	result = content.css('a[class=question-hyperlink]')

	return "Last question asked:\n\n#{result.last.text}"
end


def bot(token)
	Telegram::Bot::Client.run(token) do |bot|
		bot.listen do |message|
			welcome_user = message.new_chat_member
			goodbye_user = message.left_chat_member
			ban_user = message.reply_to_message

			if welcome_user
				bot.api.send_message(
					chat_id: message.chat.id,
					text: "Welcome, #{message.new_chat_member.first_name}"
				)
			elsif goodbye_user
				bot.api.send_message(
					chat_id: message.chat.id,
					text: "Adios, #{message.left_chat_member.first_name}"
				)
			elsif ban_user and message.text == "/ban"
				member = bot.api.getChatMember(
					chat_id: message.chat.id,
					user_id: message.from.id
					)

				if member["result"]["status"] == "administrator" or member["result"]["status"] == "creator"
					bot.api.send_message(
						chat_id: message.chat.id,
						text: "You're banned, #{ban_user.from.first_name}"
						)
					bot.api.kickChatMember(
						chat_id: message.chat.id,
						user_id: ban_user.from.id
						)
				end
			end

			case message.text
			when '/stackoverflow'
				bot.api.send_message(
					chat_id: message.chat.id,
					text: "Usage: '/stackoverflow + tag' to get the last question asked on tag"
					)
			when '/stackoverflow php'
				bot.api.send_message(
					chat_id: message.chat.id,
					text: extract('php')
					)
			when '/stackoverflow javascript'
				bot.api.send_message(
					chat_id: message.chat.id,
					text: extract('javascript')
					)
			when '/stackoverflow c#'
				bot.api.send_message(
					chat_id: message.chat.id,
					text: extract('c#')
					)
			when '/stackoverflow python'
				bot.api.send_message(
					chat_id: message.chat.id,
					text: extract('python')
					)
			end
		end
	end
end


bot(token)
