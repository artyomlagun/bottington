module Bottington
  module Adapter
    class MessengerPlatformAdapter
      MESSAGE_TYPE_ACTION = 'action'
      MESSAGE_TYPE_TEXT = 'text'

      def self.lookup_adapter(request)
        "Bottington::Adapter::#{request.messenger_platform.camelize}".constantize.new(request)
      end

      def update_request
        raise NotImplementedError
      end

      def request_method
        Bottington::HttpClient::HTTP_METHOD_POST
      end

      def platform_url(bot_request = nil, body = nil, type = nil)
        nil
      end

      def verify_webhook_url(env)
        []
      end

      private
      def build_request_message(text)
        if /(^\/\w*|([A-Z]{2,}_{1}){1,})/.match?(text)
          {text: text, type: MESSAGE_TYPE_ACTION}
        else
          {text: text, type: MESSAGE_TYPE_TEXT}
        end
      end
    end
  end
end
