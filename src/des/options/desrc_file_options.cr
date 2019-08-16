require "yaml"

module Des
  module Options
    class DesrcFileOptions
      class DefaultOptionType
        YAML.mapping(
          default_options: {
            type:    OptionsType,
            nilable: true,
            default: nil,
          },
        )
      end

      class OptionsType
        YAML.mapping(
          image: {
            type:    String,
            nilable: true,
            default: nil,
          },
          packages: {
            type:    Array(String),
            nilable: true,
            default: nil,
          },
          container: {
            type:    String,
            nilable: true,
            default: nil,
          },
          save_dir: {
            type:    String,
            nilable: true,
            default: nil,
          },
          docker_compose_version: {
            type:    String,
            nilable: true,
            default: nil,
          },
          web_app: {
            type:    Bool,
            nilable: true,
            default: nil,
          },
          overwrite: {
            type:    Bool,
            nilable: true,
            default: nil,
          },
        )
      end

      alias DesrcFileOptionsType = NamedTuple(
        image: String?,
        packages: Array(String)?,
        container: String?,
        save_dir: String?,
        docker_compose_version: String?,
        web_app: Bool?,
        overwrite: Bool?)

      @options : DesrcFileOptionsType

      def initialize(yaml_str : String)
        yaml = DefaultOptionType.from_yaml(yaml_str)
        default_options = yaml.default_options
        if default_options.nil?
          @options = {
            image:                  nil,
            packages:               nil,
            container:              nil,
            save_dir:               nil,
            docker_compose_version: nil,
            web_app:                nil,
            overwrite:              nil,
          }
        else
          @options = {
            image:                  default_options.image,
            packages:               default_options.packages,
            container:              default_options.container,
            save_dir:               default_options.save_dir,
            docker_compose_version: default_options.docker_compose_version,
            web_app:                default_options.web_app,
            overwrite:              default_options.overwrite,
          }
        end
      end

      macro define_options_method
        {% for key, type in DesrcFileOptionsType %}
          def {{key}} : {{type}}
            @options[:{{key}}]
          end
        {% end %}
      end

      define_options_method

      def ==(other : self)
        {% for key, type in DesrcFileOptionsType %}
          return false unless self.{{key}} == other.{{key}}
        {% end %}
        true
      end

      macro def_overwrite_values
        def overwrite_values(other : self, target : Array( {% for key, type in DesrcFileOptionsType %} {{type}} | {% end %} Nil) = [] of {% for key, type in DesrcFileOptionsType %} {{type}} | {% end %} Nil) : self
          tmp_hash = self.to_named_tuple.to_h
          {% for key, type in DesrcFileOptionsType %}
            tmp_hash[:{{key}}] = target.includes?(self.to_named_tuple[:{{key}}]) ? other.to_named_tuple[:{{key}}] : self.to_named_tuple[:{{key}}]
          {% end %}
          DesrcFileOptions.new(DesrcFileOptionsType.from(tmp_hash))
        end
      end

      def_overwrite_values

      def to_named_tuple
        @options
      end
    end
  end
end
