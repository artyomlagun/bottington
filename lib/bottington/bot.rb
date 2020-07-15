module Bottington
  class Bot < BaseBot
    def initialize(request)
      @request = request
      @bot_request = @request.bot_request
    end

    def call
      msg = @bot_request.message
      if msg.type == Bottington::Adapter::MessengerPlatformAdapter::MESSAGE_TYPE_ACTION

      else

      end

      reply :type, response_text, @request
    end
  end
end
