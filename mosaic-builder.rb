require './fragment'
require 'RMagick'
include Magick

class MosaicBuilder
    attr_accessor :images, :name, :weight, :sizeX, :sizeY, :fragments
    @@folderName = "./tmp/"
    
    def initialize(images, name, weightInKo, sizeX, sizeY)
        @fragments = []        
        @images = images
        @name = name
        @weightInKo = weightInKo
        @sizeX = sizeX        
        @sizeY = sizeY
        createTmpFolder
        loadFragments
    end

    #Instanciate a fragment for each image
    def loadFragments
        images.each.with_index do |image, index| 
            @fragments.push(buildFragment(image, index))
        end
    end

    def write
        @image ||=buildMosaic
        @image.write(@name) {self.quality = 100}
        puts "File size : #{@image.filesize}"                     
        puts "File size : #{@image.filesize}"     
        puts "Image quality : #{@image.quality}"        
        puts "Final image saved as : #{@name}"   
        deleteTmpFolder     
        exit
    end

    def self.folder
        return @@folderName
    end

    def buildFragment(image, id)
        Fragment.new(
            id,
            image['url'],
            image['positionX'],
            image['positionY'],
            image['percentageX'],
            image['percentageY'],
            sizeX,
            sizeY
        )
    end

    def buildMosaic
        @imageList = ImageList.new
        @fragments.each do |fragment|
            @imageList << fragment.image
        end
        @imageList.mosaic
    end

    def createTmpFolder
        Dir.mkdir @@folderName unless Dir.exist? @@folderName
    end

    def deleteTmpFolder
        FileUtils.rm_r(@@folderName)
    end

end