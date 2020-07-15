module Bottington
  module Adapter
    class Telegram < MessengerPlatformAdapter
      def initialize(request)
        @request = request
      end

      def update_request
        # we need separated key for our bot request data.
        # in other case we can rewrite any keys from original request
        @params = @request.params
        @bot_request = @request.bot_request = Bottington::BotRequest.new()
        @bot_request.user = Bottington::User.new(
          @params['message']['from']['id'],
          @params['message']['from']['first_name'],
          @params['message']['from']['last_name'],
          @params['message']['from']['username'],
          :telegram
        )
        msg = build_request_message(@params['message']['text'])
        @bot_request.message = Bottington::Message.new(@params['message']['chat']['id'], msg[:text], msg[:type])

        media = get_media
        @bot_request.media = Bottington::Media.new(
          media[:id],
          media[:url]
        )

        @request
      end

      def response_body(bot_request, body, type)
        if type == :text
          {chat_id: bot_request.message.chat_id, text: body}
        else
          {chat_id: bot_request.message.chat_id, text: body, parse_mode: type.to_s}
        end
      end

      def platform_url
        basic_url + "/sendMessage"
      end

      def default_response
        {status: :ok}
      end

      private

      def get_media
        media = {id: nil, url: nil}
        if @params['message']['photo'].nil?
          unless @params['message']['document'].nil?
            media[:id] = @params['message']['document']['file_id']
          end
        else
          media[:id] = @params['message']['photo'].last['file_id']
        end

        media[:url] = "#{file_url}#{media[:id]}"

        media
      end

      def file_url
        "#{basic_url}/getFile?file_id="
      end

      def basic_url
        "https://api.telegram.org/bot#{Bottington.telegram_token}"
      end
    end
  end
end
