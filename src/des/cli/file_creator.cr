require "ecr"
require "colorize"

module Des
  module Cli
    class FileCreator
      getter writer

      def initialize(
        @writer : IO = STDOUT,
        @reader : IO = STDIN
      )
      end

      def create(create_info : FileCreateInfo)
        path = create_info.path
        overwrite_flag = create_info.overwrite

        return write(create_info) unless File.exists?(path)
        return overwrite(create_info) if overwrite_flag
        return overwrite(create_info) if overwrite_prompt(create_info)
        not_write
      end

      private def write(create_info)
        File.write(File.expand_path(create_info.path), create_info.str)
        @writer.puts "#{"Create".colorize(:light_green)} #{create_info.path}"
      end

      private def overwrite(create_info)
        File.write(create_info.path, create_info.str)
        @writer.puts "#{"Overwrite".colorize(:light_green)} #{create_info.path}"
      end

      private def not_write
        @writer.puts "#{"Did not overwrite.".colorize(:light_yellow)}"
      end

      private def overwrite_prompt(create_info)
        ans = ""
        loop do
          @writer.puts ""
          @writer.puts "#{create_info.path}"
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
