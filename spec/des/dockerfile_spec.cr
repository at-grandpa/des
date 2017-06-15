require "../spec_helper"

alias Dockerfile = Des::Dockerfile

describe Des::Dockerfile do
  describe "#setup_image" do
    it "returns image name when valid pattern [aaa/bbb]." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "aaa/bbb"}
      dockerfile = Dockerfile.new("", "", opts)
      dockerfile.setup_image.should eq "aaa/bbb"
    end
    it "returns image name when valid pattern [aaa/bbb:ccc]." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "aaa/bbb:ccc"}
      dockerfile = Dockerfile.new("", "", opts)
      dockerfile.setup_image.should eq "aaa/bbb:ccc"
    end
    [
      {"pattern" => ""},
      {"pattern" => ":aaa"},
      {"pattern" => "aaa/bbb:ccc:a"},
    ].each do |spec_case|
      it "raises an Exception when invarid image name. spec pattern -> #{spec_case["pattern"]}" do
        opts = Clim::Options::Values.new
        opts.string = {"image" => spec_case["pattern"]}
        dockerfile = Dockerfile.new("", "", opts)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /\\A[^:]+?(|:[0-9a-zA-Z-\._]+?)\\z/") do
          dockerfile.setup_image
        end
      end
    end
  end
end
