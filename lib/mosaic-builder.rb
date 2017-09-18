require_relative 'fragment'
require 'RMagick'
include Magick

class MosaicBuilder
    attr_accessor :images, :name, :weight, :size_x, :size_y, :fragments
    @@folder_name = "./tmp/"
    
    def initialize(images, name, weight_in_ko, size_x, size_y)

        #Validation
        raise ArgumentError, "No image for the mosaic" unless !images.nil? && images.size > 0
        raise ArgumentError, "Set a name" unless !name.nil? && name.size > 0
        raise ArgumentError, "Weight must be positive" unless !weight_in_ko.nil? && weight_in_ko > 0
        raise ArgumentError, "Size must be positive" unless !size_x.nil? && !size_y.nil? && size_x > 0 && size_y > 0
        
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
        jpg_quality = compute_jpg_quality
        @image.write("#{@name}.jpg") {self.quality = jpg_quality}        
        puts "File size : #{@image.filesize}"     
        puts "Image quality : #{@image.quality}"        
        puts "Final image saved as : #{@name}.jpg"   
        delete_tmp_folder     
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


    def compute_jpg_quality
        recursive_jpg_quality(50, 50)
    end


    def recursive_jpg_quality(quality, pitch)
        # To compute jpg quality, we use dichotomy and compute file size
        if pitch == 1
            return quality
        elsif 
            pitch = pitch / 2
        end

        # The file size is computed without writing the image on the disk
        blob = @image.to_blob { self.quality = quality }
        computed_file_size = blob.bytesize

        if computed_file_size > @weight_in_ko * 1000
            quality = quality - pitch
        elsif computed_file_size < @weight_in_ko * 1000
            quality = quality + pitch
        else
            return quality
        end

        recursive_jpg_quality(quality, pitch)            
        
    end


    def create_tmp_folder
        Dir.mkdir @@folder_name unless Dir.exist? @@folder_name
    end


    def delete_tmp_folder
        FileUtils.rm_r(@@folder_name)
    end

end