require "ecr"
require "colorize"

module Des
  abstract class FileCreator
    def initialize(@parameters : Parameters, @silent : Bool = false)
    end

    abstract def file_name

    def create_file
      path = "#{@parameters.save_dir}/#{file_name}"
      if File.exists?(path)
        if @parameters.overwrite
          overwrite(path)
        else
          overwrite?(path) ? overwrite(path) : not_write(path)
        end
      else
        write(path)
      end
    end

    def write(path)
      File.write(path, to_s)
      puts "#{"Create".colorize(:light_green)} #{path}" unless @silent
    end

    def overwrite(path)
      File.write(path, to_s)
      puts "#{"Overwrite".colorize(:light_green)} #{path}" unless @silent
    end

    def not_write(path)
      puts "#{"Did not overwrite.".colorize(:light_yellow)}" unless @silent
    end

    def overwrite?(path)
      ans = ""
      loop do
        puts "#{path}"
        print "Overwrite? (y or n) > "
        ans = gets
        break if ans == "y" || ans == "n"
        puts "Please input y or n."
        puts ""
      end
      ans == "y"
    end

    macro ecr_setting
      ECR.def_to_s "#{__DIR__}/#{{{@type.stringify.split("::").last.underscore}}}/template.ecr"
    end
  end
end
