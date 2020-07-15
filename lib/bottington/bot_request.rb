module Bottington
  class BotRequest < Struct.new(:user, :message, :media)
  end
end
