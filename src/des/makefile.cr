module Des
  class Makefile
    @opts : Clim::Options::Values

    def initialize(@opts)
    end

    def create_file
      puts "create Makefile"
    end
  end
end
