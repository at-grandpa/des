module Des
  module Options
    class Options
      include Des::SettingFile::OptionsInterface

      def initialize(
        @cli_options : Des::Options::CliOptions,
        @desrc_file_options : Des::Options::DesrcFileOptions
      )
      end

      macro define_options_method(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            cli_value = @cli_options.{{option[:name]}}
            desrc_file_value = @desrc_file_options.{{option[:name]}}

            return_value = nil
            return_value = desrc_file_value unless desrc_file_value.nil?
            return_value = cli_value unless cli_value.nil?
            raise "{{option[:name]}} option is not set. See 'des --help'" if return_value.nil?
            return_value
          end
        {% end %}
      end

      define_options_method(
        {name: image, type: String},
        {name: container, type: String},
        {name: save_dir, type: String},
        {name: desrc_path, type: String},
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
        raise "packages option is not set. See 'des --help'" if return_value.nil?
        return_value
      end

      def to_named_tuple : Des::Options::CliOptions::CliOptionsType
        @cli_options.to_named_tuple
      end
    end
  end
end
