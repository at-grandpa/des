require "yaml"

module Des
  class Rc
    @path : String = "#{File.expand_path("~")}/.desrc.yml"

    def initialize(@path)
    end

    def initialize
    end

    def setting
      raise "No such rc file. -> #{@path}" unless File.exists?(@path)
      YAML.parse(File.read(@path))
    end
  end
end
