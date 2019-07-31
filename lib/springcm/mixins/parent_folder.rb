module Springcm
  module ParentFolder
    def parent_folder_href
      # Root folders won't have ParentFolder key
      @data.dig("ParentFolder", "Href")
    end
  end
end
