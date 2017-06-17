module Des
  module Makefile
    class Parameters
      @opts : Des::Opts
      @rc : Des::Rc
      @container : String
      @save_dir : String

      getter container, save_dir

      def initialize(@rc, @opts)
        @container = _find_container
        @save_dir = _find_save_dir
      end

      private def _find_container
        container = nil
        container = @rc.container unless @rc.container.nil?
        container = @opts.container unless @opts.container.nil?
        raise "Container name for Dockerfile is not set. See 'des -h'" if container.nil?
        container
      end

      private def _find_save_dir
        save_dir = nil
        save_dir = @rc.save_dir unless @rc.save_dir.nil?
        save_dir = @opts.save_dir unless @opts.save_dir.nil?
        raise "Save dir is not set. See 'des -h'" if save_dir.nil?
        save_dir
      end
    end
  end
end
