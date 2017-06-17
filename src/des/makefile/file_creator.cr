require "ecr"

module Des
  module Makefile
    class FileCreator
      def initialize(@parameters : Parameters)
      end

      def create_file
        File.write("#{@parameters.save_dir}/#{FILE_NAME}", to_s)
      end

      ECR.def_to_s "#{__DIR__}/template.ecr"
    end
  end
end
