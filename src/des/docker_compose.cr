module Des
  class DockerCompose
    @opts : Clim::Options::Values

    def initialize(@opts)
    end

    def create_file
      puts "create docker-compose.yml"
    end
  end
end
