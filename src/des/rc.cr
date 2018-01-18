require "yaml"

module Des
  class Rc
    def initialize(yaml_str)
      @setting = YAML.parse(yaml_str)
      begin
        @setting.as_h # rc file format is only allowed in hash format.
      rescue ex
        raise "rc file format is not Hash. Exception -> #{ex.message}"
      end
    end

    def image
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["image"]?
      @setting["default_param"]["image"].as_s
    end

    def packages
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["packages"]?
      @setting["default_param"]["packages"].map(&.as_s)
    end

    def container
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["container"]?
      @setting["default_param"]["container"].as_s
    end

    def save_dir
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["save_dir"]?
      save_dir = @setting["default_param"]["save_dir"].as_s
      raise "Save dir set as rc_file is not found. -> #{save_dir}" unless Dir.exists?(save_dir)
      save_dir
    end

    def docker_compose_version
      return nil unless @setting["default_param"]?
      return nil unless @setting["default_param"]["docker_compose_version"]?
      @setting["default_param"]["docker_compose_version"].as_i64.to_s
    end

    def web_app
      return nil unless @setting.as_h.has_key?("default_param")
      return nil unless @setting["default_param"].as_h.has_key?("web_app")
      web_app_str = @setting["default_param"]["web_app"]
      case web_app_str
      when true  then true
      when false then false
      else
        raise "web_app flag set as rc_file is allowed only 'true' or 'false'. The set flag is [#{web_app_str}]."
      end
    end

    def overwrite
      return nil unless @setting.as_h.has_key?("default_param")
      return nil unless @setting["default_param"].as_h.has_key?("overwrite")
      overwrite_str = @setting["default_param"]["overwrite"]
      case overwrite_str
      when true  then true
      when false then false
      else
        raise "overwrite flag set as rc_file is allowed only 'true' or 'false'. The set flag is [#{overwrite_str}]."
      end
    end
  end
end
