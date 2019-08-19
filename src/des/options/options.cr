module Des
  module Options
    class Options
      include Des::SettingFile::OptionsInterface

      alias OptionsType = NamedTuple(
        image: String,
        packages: Array(String),
        container: String,
        save_dir: String,
        docker_compose_version: String,
        web_app: Bool,
        overwrite: Bool)

      DEFAULT_DESRC_YAML_STRING = <<-STRING
      default_options:
        image: ubuntu:18.04
        packages: []
        container: my_container
        save_dir: .
        docker_compose_version: 3
        web_app: false
        overwrite: false
      STRING

      getter cli_options

      def initialize(
        @cli_options : Des::Options::CliOptions,
        @desrc_file_options : Des::Options::DesrcFileOptions,
        default_desrc_yaml_string : String = DEFAULT_DESRC_YAML_STRING
      )
        default_desrc_options = Des::Options::DesrcFileOptions.from_yaml(default_desrc_yaml_string)
        @desrc_file_options = @desrc_file_options.overwrite_values(default_desrc_options, [nil])
      end

      macro define_options_method(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            cli_value = @cli_options.{{option[:name]}}
            desrc_file_value = @desrc_file_options.{{option[:name]}}

            return_value = nil
            return_value = desrc_file_value unless desrc_file_value.nil?
            return_value = cli_value unless cli_value.nil?
            raise DesException.new "{{option[:name]}} option is not set. See 'des --help'" if return_value.nil?
            return_value
          end
        {% end %}
      end

      define_options_method(
        {name: image, type: String},
        {name: container, type: String},
        {name: save_dir, type: String},
        {name: docker_compose_version, type: String},
        {name: web_app, type: Bool},
        {name: overwrite, type: Bool},
      )

      def packages : Array(String)
        cli_value = @cli_options.packages
        desrc_file_value = @desrc_file_options.packages

        return_value = nil
        return_value = desrc_file_value unless desrc_file_value.nil?
        return_value = cli_value unless cli_value.nil?
        if !cli_value.nil? && cli_value.empty? && !desrc_file_value.nil?
          return_value = desrc_file_value
        end
        raise DesException.new "packages option is not set. See 'des --help'" if return_value.nil?
        return_value
      end

      def ==(other : self) : Bool
        {% for key, type in OptionsType %}
          return false unless self.{{key}} == other.{{key}}
        {% end %}
        true
      end
    end
  end
end
