module Des
  class Args
    getter project_name

    @project_name : String

    def initialize(args)
      @project_name = args.first
    end
  end
end
