require "../spec_helper"

describe Des::Rc do
  describe "#setting" do
    it "returns hash when rc file exists." do
      rc = Rc.new(File.expand_path("./spec/des/rc/.desrc.yml"))
      rc.setting.should eq(
        {
          "default_param" => {
            "image"    => "crystallang/crystal",
            "packages" => [
              "curl",
              "vim",
              "wget",
            ],
            "path" => ".",
          },
          "default_compose" => {
            "version" => "2.0",
          },
        }
      )
    end
    it "raises an Exception when array size is 0." do
      rc = Rc.new(File.expand_path("./spec/des/rc/.missingrc.yml"))
      expect_raises(Exception, "No such rc file. ->") do
        rc.setting
      end
    end
  end
end
