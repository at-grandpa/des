require "ecr"
require "colorize"

module Des
  abstract class FileCreator
    def initialize(@parameters : Parameters)
    end

    abstract def file_name

    def create_file
      path = "#{@parameters.save_dir}/#{file_name}"
      File.write(path, to_s)
      puts "#{"create".colorize(:light_green)}  #{path}"
    end

    macro ecr_setting
      ECR.def_to_s "#{__DIR__}/#{{{@type.stringify.split("::").last.underscore}}}/template.ecr"
    end
  end
end
