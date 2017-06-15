module Des
  class DockerCompose
    @project_name : String
    @opts : Clim::Options::Values

    def initialize(@project_name, @opts)
    end

    def create_file
      puts "create docker-compose.yml"
    end
  end
end
