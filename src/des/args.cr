module Des
  class Args
    @args : Array(String)

    def initialize(@args)
    end

    def container_name
      raise "Invalid argument. Expected argument is 1." if @args.size != 1
      @args.first
    end
  end
end
