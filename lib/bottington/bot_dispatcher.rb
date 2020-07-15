module Bottington
  class BotDispatcher
    include Singleton

    def dispatch(request)
      route = RoutesRegister.instance.find(request)
      if route
        route.bot.new(request).call
      else
        raise IndexError, "there is no mapped bots for #{request.bot_path} path"
      end
    end
  end

  class RoutesRegister
    include Singleton

    def initialize
      @routes = []
      @platforms_stack = []
    end

    def map(path, bot)
      @routes << Route.new(path, bot, @platforms_stack.last)
    end

    def platform(*args, &block)
      args.each do |platform|
        @platforms_stack.push(platform)
        block.call
        @platforms_stack.pop()
      end
    end

    def find(request)
      @routes.find do |route|
        route.path.gsub(/\//, '') == request.bot_path.first && (route.platform.nil? || route.platform == request.messenger_platform.to_sym)
      end
    end

    def draw(&block)
      instance_eval &block
    end

  end

  class Route < Struct.new(:path, :bot, :platform);end


  def self.routes
    RoutesRegister.instance
  end
end
