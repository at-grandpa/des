require "./file_creator"

module Des
  class DesrcYml
    def initialize(@opts : Des::CliOptions, @silent : Bool = false, @auto_answer : Bool = false)
    end

    def file_name
      ".desrc.yml"
    end

    def create_file
      path = @opts.rc_file
      if path.nil?
        raise "rc_file path is not set. See 'des --help'"
      elsif File.exists?(path)
        puts "#{path} is already exists."
      else
        write(path) if create?(path)
      end
    end

    def write(path)
      File.write(path, to_s)
      puts "#{"Create".colorize(:light_green)} #{path}" unless @silent
    end

    def create?(path)
      return true if @auto_answer
      ans = ""
      loop do
        puts "#{path} is not found."
        print "Create? (y or n) > "
        ans = gets
        break if ans == "y" || ans == "n"
        puts "Please input y or n."
        puts ""
      end
      ans == "y"
    end

    ECR.def_to_s "#{__DIR__}/desrc_yml/template.ecr"
  end
end
