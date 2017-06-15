require "../spec_helper"

alias Dockerfile = Des::Dockerfile

describe Des::Dockerfile do
  describe "#setup_image" do
    [
      {"pattern" => "ubuntu"},
      {"pattern" => "ubuntu:16.04"},
      {"pattern" => "crystallang"},
      {"pattern" => "crystallang/crystal"},
      {"pattern" => "crystallang/crystal:latest"},
    ].each do |spec_case|
      it "returns image name when valid pattern. spec pattern -> #{spec_case["pattern"]}" do
        opts = Clim::Options::Values.new
        opts.string = {"image" => spec_case["pattern"]}
        dockerfile = Dockerfile.new("", "", opts)
        dockerfile.setup_image.should eq spec_case["pattern"]
      end
    end
    [
      {"pattern" => ""},
      {"pattern" => ":aaa"},
      {"pattern" => "-aaa"},
      {"pattern" => "/aaa"},
      {"pattern" => "0aaa"},
      {"pattern" => "aaa:"},
      {"pattern" => "aaa/bbb:ccc:ddd"},
    ].each do |spec_case|
      it "raises an Exception when invarid image name. spec pattern -> #{spec_case["pattern"]}" do
        opts = Clim::Options::Values.new
        opts.string = {"image" => spec_case["pattern"]}
        dockerfile = Dockerfile.new("", "", opts)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z/") do
          dockerfile.setup_image
        end
      end
    end
  end
end
