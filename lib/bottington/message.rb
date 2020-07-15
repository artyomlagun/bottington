module Bottington
  class Message < Struct.new(:chat_id, :text, :type)
  end
end
