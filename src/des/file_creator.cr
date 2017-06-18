require "ecr"
require "colorize"

module Des
  abstract class FileCreator
    def initialize(@parameters : Parameters, @silent : Bool = false)
    end

    abstract def file_name

    def create_file
      path = "#{@parameters.save_dir}/#{file_name}"
      File.write(path, to_s)
      puts "#{"create".colorize(:light_green)}  #{path}" unless @silent
    end

    macro ecr_setting
      ECR.def_to_s "#{__DIR__}/#{{{@type.stringify.split("::").last.underscore}}}/template.ecr"
    end
  end
end
