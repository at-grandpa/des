require "yaml"

module Des
  class Rc
    def initialize
      @setting = YAML.parse("")
    end

    def initialize(yaml_str)
      @setting = YAML.parse(yaml_str)
      begin
        @setting.as_h # rc file format is only allowed in hash format.
      rescue ex
        raise "rc file format is not Hash. Exception -> #{ex.message}"
      end
    end

    def image
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      p typeof(setting.as_nil)
      p typeof(nil)
      p setting
      p setting.nil?
      return nil unless setting["default_param"]?
      # return nil unless setting["default_param"]["image"]?
      # setting["default_param"]["image"].as_s
    end

    def packages
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      return nil unless setting["default_param"]?
      return nil unless setting["default_param"]["packages"]?
      setting["default_param"]["packages"].map(&.as_s)
    end

    def container
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      return nil unless setting["default_param"]?
      return nil unless setting["default_param"]["container"]?
      setting["default_param"]["container"].as_s
    end

    def save_dir
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      return nil unless setting["default_param"]?
      return nil unless setting["default_param"]["save_dir"]?
      save_dir = setting["default_param"]["save_dir"].as_s
      raise "Save dir set as rc_file is not found. -> #{save_dir}" unless Dir.exists?(save_dir)
      save_dir
    end

    def web_app
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      return nil unless setting["default_param"]?
      return nil unless setting["default_param"]["web_app"]?
      web_app_str = setting["default_param"]["web_app"].as_s
      case web_app_str
      when "true"
        true
      when "false"
        false
      else
        raise "web_app flag set as rc_file is allowed only 'true' or 'false'. The set flag is [#{web_app_str}]."
      end
    end

    def overwrite
      setting = @setting
      return nil if setting.nil?
      return nil unless setting.responds_to?(:[]?)
      return nil unless setting["default_param"]?
      return nil unless setting["default_param"]["overwrite"]?
      overwrite_str = setting["default_param"]["overwrite"].as_s
      case overwrite_str
      when "true"
        true
      when "false"
        false
      else
        raise "overwrite flag set as rc_file is allowed only 'true' or 'false'. The set flag is [#{overwrite_str}]."
      end
    end
  end
end
