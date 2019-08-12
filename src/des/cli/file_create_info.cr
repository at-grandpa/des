module Des
  module Cli
    class FileCreateInfo
      getter path, str, overwrite

      def initialize(@path : String, @str : String, @overwrite : Bool)
      end
    end
  end
end
