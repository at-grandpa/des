module Des
  module Options
    class CliOptions
      alias CliOptionsType = NamedTuple(
        image: String?,
        packages: Array(String),
        container: String?,
        save_dir: String?,
        docker_compose_version: String?,
        web_app: String?,
        overwrite: String?)

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
              raise DesException.new "{{option[:name]}} option only allows 'true' or 'false'. See 'des --help'"
            end
          end
        {% end %}
      end

      define_options_method_for_bool(
        {name: web_app, type: Bool?},
        {name: overwrite, type: Bool?},
      )

      def ==(other : self)
        {% for key, type in CliOptionsType %}
          return false unless self.{{key}} == other.{{key}}
        {% end %}
        true
      end

      macro def_overwrite_values
        def overwrite_values(other : self, target : Array( {% for key, type in CliOptionsType %} {{type}} | {% end %} Nil) = [] of {% for key, type in CliOptionsType %} {{type}} | {% end %} Nil) : self
          tmp_hash = self.to_named_tuple.to_h
          {% for key, type in CliOptionsType %}
            tmp_hash[:{{key}}] = target.includes?(self.to_named_tuple[:{{key}}]) ? other.to_named_tuple[:{{key}}] : self.to_named_tuple[:{{key}}]
          {% end %}
          CliOptions.new(CliOptionsType.from(tmp_hash))
        end
      end

      def_overwrite_values

      def to_named_tuple
        @named_tuple
      end
    end
  end
end
