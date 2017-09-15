require 'RMagick'
include Magick
require 'open-uri'

class Fragment
    attr_accessor :image, :url, :positionX, :positionY, :percentageX, :percentageY, :parentSizeX, :parentSizeY
    
    def initialize(id, url, positionX, positionY, percentageX, percentageY, parentSizeX, parentSizeY) 
        @path = "#{MosaicBuilder.folder}#{id}.jpg"
        @url = url
        @positionX = positionX
        @positionY = positionY
        @percentageX = percentageX
        @percentageY = percentageY
        @parentSizeX = parentSizeX
        @parentSizeY = parentSizeY  

        downloadImage
        resizeImage
        setPositionSettings
    end

    def downloadImage
        puts "Donwloading #{@url}"
        open(@url) {|f|
            File.open(@path,"wb") do |file|
            file.puts f.read
            end
        }
        puts "Saved as #{@path}"
    end

    def resizeImage
        image = ImageList.new(@path)
        newSizeX = parentSizeX * percentageX / 100
        newSizeY = parentSizeY * percentageY / 100
        image = image.scale(newSizeX,newSizeY)
        image.write(@path)
        @image = image
    end

    def setPositionSettings
        page = Magick::Rectangle.new(0,0,0,0)
        page.x = @positionX
        page.y = @positionY  
        @image.page = page
    end

end