require "yaml"

module Des
  class Rc
    YAML.mapping({
      default_param: {type: DefaultParam, nilable: true},
      default_compose: {type: DefaultCompose, nilable: true},
    })

    class DefaultParam
    end

    class DefaultCompose
    end

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
