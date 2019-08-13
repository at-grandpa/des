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
          desrc_path: {
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

      @default_options : OptionsType?

      def initialize(yaml_str : String)
        yaml = DefaultOptionType.from_yaml(yaml_str)
        @default_options = yaml.default_options
      end

      macro define_options_method(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            def_opts = @default_options
            return nil if def_opts.nil?
            def_opts.{{option[:name]}}
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
        {name: web_app, type: Bool?},
        {name: overwrite, type: Bool?},
      )
    end
  end
end
