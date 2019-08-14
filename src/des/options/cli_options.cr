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

      def image : String?
        @named_tuple[:image] ? @named_tuple[:image] : nil
      end

      def packages : Array(String)?
        @named_tuple[:packages] ? @named_tuple[:packages] : nil
      end

      def container : String?
        @named_tuple[:container] ? @named_tuple[:container] : nil
      end

      def save_dir : String?
        @named_tuple[:save_dir] ? @named_tuple[:save_dir] : nil
      end

      def desrc_path : String?
        @named_tuple[:desrc_path] ? @named_tuple[:desrc_path] : nil
      end

      def docker_compose_version : String?
        @named_tuple[:docker_compose_version] ? @named_tuple[:docker_compose_version] : nil
      end

      def web_app : Bool?
        web_app = @named_tuple[:web_app]
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
        overwrite = @named_tuple[:overwrite]
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

      def to_named_tuple
        @named_tuple
      end
    end
  end
end
