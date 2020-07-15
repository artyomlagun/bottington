module Bottington
  module Adapter
    class Viber < MessengerPlatformAdapter
      def initialize(request)
        @request = request
      end

      def update_request
        @params = @request.params
        @bot_request = @request.bot_request = Bottington::BotRequest.new
        @bot_request.user = Bottington::User.new(
          @params[:sender][:id],
          @params[:sender][:name],
          '', '',
          :viber
        )

        msg = build_request_message(@params[:message][:text])
        @bot_request.message = Bottington::Message.new(SecureRandom.hex(10), msg[:text], msg[:type])

        @bot_request.media = Bottington::Media.new(@params[:message_token], @params[:message][:media])

        @request
      end

      def response_body(bot_request, body, type)
        {
          auth_token: Bottington.viber_token,
          receiver: @request.bot_request.user.id,
          type: type.to_s,
          text: body
        }
      end

      def platform_url
        'https://chatapi.viber.com/pa/send_message'
      end
    end
  end
end
