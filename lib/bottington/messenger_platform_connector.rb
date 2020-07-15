module Bottington
  class MessengerPlatformConnector
    include Singleton

    def bottington_request(request)
      adapter = Adapter::MessengerPlatformAdapter.lookup_adapter(request)
      adapter.update_request
    end

    def send_bot_response(request, response, type = :text)
      adapter = Adapter::MessengerPlatformAdapter.lookup_adapter(request)
      Bottington::HttpClient.instance.send(adapter.request_method, adapter.platform_url(request.bot_request, response, type), adapter.response_body(request.bot_request, response, type))
    end

    def verify_webhook(request)
      adapter = Adapter::MessengerPlatformAdapter.lookup_adapter(request)
      adapter.verify_webhook_url(request.env)
    end
  end
end
