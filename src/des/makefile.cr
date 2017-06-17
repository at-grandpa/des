require "./file_creator"

module Des
  class Makefile < FileCreator
    def file_name
      "Makefile"
    end

    ecr_setting
  end
end
