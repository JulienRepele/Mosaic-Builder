require 'RMagick'
include Magick
require 'open-uri'

class Fragment
    attr_accessor :image, :url, :position_x, :position_y, :percentage_x, :percentage_y, :parent_size_x, :parent_size_y
    
    def initialize(id, url, position_x, position_y, percentage_x, percentage_y, parent_size_x, parent_size_y) 
        @path = "#{MosaicBuilder.folder}#{id}.jpg"
        @url = url
        @position_x = position_x
        @position_y = position_y
        @percentage_x = percentage_x
        @percentage_y = percentage_y
        @parent_size_x = parent_size_x
        @parent_size_y = parent_size_y  

        download_image
        resize_image
        set_position_settings
    end


    def download_image
        puts "Donwloading #{@url}"
        open(@url) {|f|
            File.open(@path,"wb") do |file|
            file.puts f.read
            end
        }
        puts "Saved as #{@path}"
    end


    def resize_image
        image = ImageList.new(@path)
        new_size_x = parent_size_x * percentage_x / 100
        new_size_y = parent_size_y * percentage_y / 100
        image = image.scale(new_size_x,new_size_y)
        image.write(@path)
        @image = image
    end
    

    def set_position_settings
        page = Magick::Rectangle.new(0,0,0,0)
        page.x = @position_x
        page.y = @position_y  
        @image.page = page
    end

end