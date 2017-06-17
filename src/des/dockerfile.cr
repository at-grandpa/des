require "./file_creator"

module Des
  class Dockerfile < FileCreator
    def file_name
      "Dockerfile"
    end

    ecr_setting
  end
end
