require "springcm-sdk/resource"

module Springcm
  class CopyTask < Resource
    def await!(interval: 1, tries: 10, backoff: 2)
      while tries > 0
        return true if complete?
        sleep(interval)
        interval *= backoff
        tries -= 1
      end
      raise Springcm::CopyTaskAwaitTimeout.new
    end

    def await(interval: 1, tries: 10, backoff: 2)
      begin
        await!(interval: interval, tries: tries, backoff: backoff)
      rescue Springcm::CopyTaskAwaitTimeout => timeout
        return false
      end
    end

    def complete?
      get.status != "Processing"
    end
  end
end
