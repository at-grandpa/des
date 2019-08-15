module Des
  module Options
    class CliOptions
      alias CliOptionsType = NamedTuple(
        image: String | Nil,
        packages: Array(String),
        container: String | Nil,
        save_dir: String | Nil,
        desrc_path: String | Nil,
        docker_compose_version: String | Nil,
        web_app: String | Nil,
        overwrite: String | Nil)

      def initialize(@named_tuple : CliOptionsType)
      end

      macro define_options_method(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            @named_tuple[:{{option[:name].id}}] ? @named_tuple[:{{option[:name].id}}] : nil
          end
        {% end %}
      end

      define_options_method(
        {name: image, type: String?},
        {name: packages, type: Array(String)?},
        {name: container, type: String?},
        {name: save_dir, type: String?},
        {name: desrc_path, type: String?},
        {name: docker_compose_version, type: String?},
      )

      macro define_options_method_for_bool(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            overwrite = @named_tuple[:{{option[:name].id}}]
            case overwrite
            when "true"
              true
            when "false"
              false
            when nil
              nil
            else
              raise "{{option[:name]}} option only allows 'true' or 'false'. See 'des --help'"
            end
          end
        {% end %}
      end

      define_options_method_for_bool(
        {name: web_app, type: Bool?},
        {name: overwrite, type: Bool?},
      )

      def overwrite_values(other : self, target : Array(Object) = [] of Object) : self
        self
      end

      def ==(other : self)
        {% for key, type in CliOptionsType %}
          return false unless self.{{key}} == other.{{key}}
        {% end %}
        true
      end
    end
  end
end
