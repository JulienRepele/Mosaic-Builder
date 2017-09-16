require './fragment'
require 'RMagick'
include Magick

class MosaicBuilder
    attr_accessor :images, :name, :weight, :size_x, :size_y, :fragments
    @@folder_name = "./tmp/"
    
    def initialize(images, name, weight_in_ko, size_x, size_y)
        @fragments = []        
        @images = images
        @name = name
        @weight_in_ko = weight_in_ko
        @size_x = size_x        
        @size_y = size_y
        create_tmp_folder
        load_fragment
    end

    #Instanciate a fragment for each image
    def load_fragment
        images.each.with_index do |image, index| 
            @fragments.push(build_fragment(image, index))
        end
    end

    def write
        @image ||=build_mosaic
        @image.write(@name) {self.quality = 100}
        puts "File size : #{@image.filesize}"                     
        puts "File size : #{@image.filesize}"     
        puts "Image quality : #{@image.quality}"        
        puts "Final image saved as : #{@name}"   
        delete_tmp_folder     
        exit
    end

    def self.folder
        return @@folder_name
    end

    def build_fragment(image, id)
        Fragment.new(
            id,
            image['url'],
            image['positionX'],
            image['positionY'],
            image['percentageX'],
            image['percentageY'],
            size_x,
            size_y
        )
    end

    def build_mosaic
        @image_list = ImageList.new
        @fragments.each do |fragment|
            @image_list << fragment.image
        end
        @image_list.mosaic
    end

    def create_tmp_folder
        Dir.mkdir @@folder_name unless Dir.exist? @@folder_name
    end

    def delete_tmp_folder
        FileUtils.rm_r(@@folder_name)
    end

end