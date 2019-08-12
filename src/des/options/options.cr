module Des
  module Options
    class Options
      include Des::SettingFile::OptionsInterface

      def initialize(
        @cli_options : Des::Options::CliOptions,
        @des_rc_file_options : Des::Options::DesRcFileOptions
      )
      end

      macro define_options_method(*options)
        {% for option in options %}
          def {{option[:name]}} : {{option[:type]}}
            cli_value = @cli_options.{{option[:name]}}
            des_rc_file_value = @des_rc_file_options.{{option[:name]}}

            return_value = nil
            return_value = des_rc_file_value unless des_rc_file_value.nil?
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
        {name: rc_file, type: String},
        {name: docker_compose_version, type: String},
        {name: web_app, type: Bool},
        {name: overwrite, type: Bool},
      )

      def packages : Array(String)
        cli_value = @cli_options.packages
        des_rc_file_value = @des_rc_file_options.packages

        return_value = nil
        return_value = des_rc_file_value unless des_rc_file_value.nil?
        return_value = cli_value unless cli_value.nil?
        if !cli_value.nil? && cli_value.empty? && !des_rc_file_value.nil?
          return_value = des_rc_file_value
        end
        raise "packages option is not set. See 'des --help'" if return_value.nil?
        return_value
      end
    end
  end
end
