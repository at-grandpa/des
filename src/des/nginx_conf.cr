require "./file_creator"

module Des
  class NginxConf < FileCreator
    def file_name
      "nginx.conf"
    end

    ecr_setting
  end
end
