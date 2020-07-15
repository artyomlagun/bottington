module Bottington
  class BaseBot
    def initialize(request)
      @request = request
    end

    def call
      raise NotImplementedError
    end

    protected
    def reply(type, msg, request)
      Bottington::MessengerPlatformConnector.instance.send_bot_response(request, msg, type)
    end
  end
end
