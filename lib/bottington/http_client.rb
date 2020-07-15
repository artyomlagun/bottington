require 'faraday'

module Bottington
  class HttpClient
    include Singleton

    HTTP_METHOD_GET = :get
    HTTP_METHOD_POST = :post

    @@mimic_methods = [HTTP_METHOD_GET, HTTP_METHOD_POST]

    def initialize
      @connection = Faraday.new(nil, {request: {timeout: 20}})
    end

    def method_missing(method_name, *args, &block)
      if @@mimic_methods.include?(method_name.to_sym)
        do_call(method_name, *args, &block)
      else
        raise ArgumentError.new("Method `#{m}` doesn't exist.")
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @@mimic_methods.include?(method_name.to_sym) || super
    end

    private

    def do_call(http_method, url, body)
      @connection.public_send(http_method.to_sym) do |request|
        request.url(url)
        request.headers['Content-Type'] = 'application/json'
        request.body = body.to_json
      end
    end
  end
end
