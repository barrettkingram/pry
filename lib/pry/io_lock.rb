class Pry
  class IOLock
    def initialize
      @p_out, @p_in = IO.pipe
      @p_in.syswrite(1)
    end

    def acquire
      @p_out.read_nonblock(1)
    rescue IO::EAGAINWaitReadable
      false
    end

    def release
      begin
        loop { @p_out.read_nonblock(1) }
      rescue IO::EAGAINWaitReadable
      end

      @p_in.syswrite(1)
    end
  end
end
