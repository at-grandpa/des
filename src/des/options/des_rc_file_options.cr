module Des
  module Options
    class DesRcFileOptions
      def image : String?
        true ? nil : ""
      end

      def packages : Array(String)?
        true ? nil : [] of String
      end

      def container : String?
        true ? nil : ""
      end

      def save_dir : String?
        true ? nil : ""
      end

      def docker_compose_version : String?
        true ? nil : ""
      end

      def web_app : Bool?
        true ? nil : true
      end

      def overwrite : Bool?
        true ? nil : true
      end
    end
  end
end
