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
        overwrite: String | Nil,
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

      def desrc_path : String?
        @cli_options[:desrc_path] ? @cli_options[:desrc_path] : nil
      end

      def docker_compose_version : String?
        @cli_options[:docker_compose_version] ? @cli_options[:docker_compose_version] : nil
      end

      def web_app : Bool?
        web_app = @cli_options[:web_app]
        case web_app
        when "true"
          true
        when "false"
          false
        when nil
          nil
        else
          raise "web-app option only allows 'true' or 'false'. See 'des --help'"
        end
      end

      def overwrite : Bool?
        overwrite = @cli_options[:overwrite]
        case overwrite
        when "true"
          true
        when "false"
          false
        when nil
          nil
        else
          raise "overwrite option only allows 'true' or 'false'. See 'des --help'"
        end
      end

      def desrc : Bool
        @cli_options[:desrc]
      end
    end
  end
end
