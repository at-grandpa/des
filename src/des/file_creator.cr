require "ecr"

module Des
  abstract class FileCreator
    def initialize(@parameters : Parameters)
    end

    abstract def file_name

    def create_file
      File.write("#{@parameters.save_dir}/#{file_name}", to_s)
    end

    macro ecr_setting
      ECR.def_to_s "#{__DIR__}/#{{{@type.stringify.split("::").last.underscore}}}/template.ecr"
    end
  end
end
