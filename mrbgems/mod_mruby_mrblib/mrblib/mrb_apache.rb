class Apache
  class Request
    def reverse_proxy path
      self.handler  = "proxy-server"
      self.proxyreq = Apache::PROXYREQ_REVERSE
      self.filename = "proxy:" + path
    end
  end
  class Headers_in
    def user_agent; self["User-Agent"]; end
    def referer; self["Referer"]; end
  end
  class Filter
    def body
      data = self.flatten
      self.cleanup
      data
    end
    def body= output
      self.insert_tail output
      self.insert_eos
    end
  end
  # "%x" % permission #=> "744"
  # "%o" % unix_mode  #=> "744"
  class Finfo
    def unix_mode
      apr_perm = self.permission
      mask = 0b1111
      unix_mask = 0b111
      omode = (apr_perm & (0b1111)) & unix_mask
      gmode = (apr_perm & (0b1111 << 4)) >> 4 & unix_mask
      umode = (apr_perm & (0b1111 << 8)) >> 8 & unix_mask

      omode | (gmode << 3) | (umode << 6)
    end
    alias mode unix_mode
  end
end
module Kernel
  def get_server_class
    Apache
  end
end
