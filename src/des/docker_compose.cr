require "./file_creator"
require "yaml"
require "ecr"

module Des
  class DockerCompose
    def initialize(@parameters : Parameters, @silent : Bool = false)
    end

    def create_file
      if @parameters.web_app
        WebApp.new(@parameters, @silent).create_file
      else
        Default.new(@parameters, @silent).create_file
      end
    end

    class Default < FileCreator
      def file_name
        "docker-compose.yml"
      end

      ECR.def_to_s "#{__DIR__}/docker_compose/default_template.ecr"
    end

    class WebApp < FileCreator
      def file_name
        "docker-compose.yml"
      end

      ECR.def_to_s "#{__DIR__}/docker_compose/web_app_template.ecr"
    end
  end
end
