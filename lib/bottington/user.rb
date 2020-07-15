module Bottington
  class User < Struct.new(:id, :first_name, :last_name, :username, :provider)
  end
end
