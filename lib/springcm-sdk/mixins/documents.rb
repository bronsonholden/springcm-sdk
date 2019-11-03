module Springcm
  module Documents
    def documents_href
      @data.dig("Documents", "Href")
    end
  end
end
