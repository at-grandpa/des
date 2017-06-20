require "./file_creator"

module Des
  class RcFile < FileCreator
    def file_name
      ".desrc.yml"
    end

    ecr_setting
  end
end
