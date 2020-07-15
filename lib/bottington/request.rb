require 'addressable'
require 'json'

module Bottington
  class Request < Rack::Request
    attr_accessor :bot_request

    URL_TEMPLATE = Addressable::Template.new('{scheme}://{host}/{bottington}/{platform}{/bot_path*}{?query*}')

    def initialize(env)
      @env = env
    end

    # Bottington::Request doesn't return params by some reasons
    def params
      params = self.body.is_a?(Puma::NullIO) || self.body.blank? ? {} : JSON.parse(self.body.read)
      self.env["rack.input"] = StringIO.new(params.to_json)
      params
    end

    def bot_path
      URL_TEMPLATE.match(self.url)[:bot_path]
    end

    def messenger_platform
      URL_TEMPLATE.match(self.url)[:platform]
    end
  end
end
