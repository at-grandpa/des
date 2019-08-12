module Des
  module Options
    class CliOptions
      alias CliOptionsType = NamedTuple(
        image: String | Nil,
        packages: Array(String),
        container: String | Nil,
        save_dir: String,
        rc_file: String,
        docker_compose_version: String,
        web_app: Bool,
        overwrite: Bool,
        desrc: Bool)

      def initialize(@cli_options : CliOptionsType)
      end

      def image : String?
        @cli_options[:image] ? @cli_options[:image] : nil
      end

      def packages : Array(String)?
        @cli_options[:packages] ? @cli_options[:packages] : nil
      end

      def container : String?
        @cli_options[:container] ? @cli_options[:container] : nil
      end

      def save_dir : String?
        @cli_options[:save_dir] ? @cli_options[:save_dir] : nil
      end

      def rc_file : String?
        @cli_options[:rc_file] ? @cli_options[:rc_file] : nil
      end

      def docker_compose_version : String?
        @cli_options[:docker_compose_version] ? @cli_options[:docker_compose_version] : nil
      end

      def web_app : Bool?
        web_app = @cli_options[:web_app]
        if web_app.is_a?(Bool)
          web_app
        else
          nil
        end
      end

      def overwrite : Bool?
        overwrite = @cli_options[:overwrite]
        if overwrite.is_a?(Bool)
          overwrite
        else
          nil
        end
      end

      def desrc : Bool?
        desrc = @cli_options[:desrc]
        if desrc.is_a?(Bool)
          desrc
        else
          nil
        end
      end
    end
  end
end
