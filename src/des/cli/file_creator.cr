require "ecr"
require "colorize"

module Des
  module Cli
    class FileCreator
      getter writer

      def initialize(
        @create_info : FileCreateInfo,
        @writer : IO = STDOUT,
        @reader : IO = STDIN,
        @silent : Bool = false
      )
      end

      def create
        path = @create_info.path
        overwrite_flag = @create_info.overwrite

        return write unless File.exists?(path)
        return overwrite if overwrite_flag
        return overwrite if overwrite_prompt
        not_write
      end

      private def write
        File.write(@create_info.path, @create_info.str)
        @writer.puts "#{"Create".colorize(:light_green)} #{@create_info.path}" unless @silent
      end

      private def overwrite
        File.write(@create_info.path, @create_info.str)
        @writer.puts "#{"Overwrite".colorize(:light_green)} #{@create_info.path}" unless @silent
      end

      private def not_write
        @writer.puts "#{"Did not overwrite.".colorize(:light_yellow)}" unless @silent
      end

      private def overwrite_prompt
        ans = ""
        loop do
          @writer.puts ""
          @writer.puts "#{@create_info.path}"
          @writer.print "Overwrite? (y or n) > "
          ans = @reader.gets
          break if ans == "y" || ans == "n"
          @writer.puts "Please input y or n."
          @writer.puts ""
        end
        ans == "y"
      end
    end
  end
end
