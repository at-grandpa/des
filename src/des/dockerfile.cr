module Des
  class Dockerfile
    @project_name : String
    @opts : Clim::Options::Values

    def initialize(@project_name, @opts)
    end

    def create_file
      puts "create Dockerfile"
    end
  end
end
