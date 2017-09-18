require 'json'
require 'test/unit'
require_relative 'mosaic-builder'

class TestMosaicBuilder < Test::Unit::TestCase

    def test_no_name
        json_file = File.read('test-no-name-request.json')        
        request = JSON.parse(json_file)
        assert_raise(ArgumentError){
            mosaic_builder = MosaicBuilder.new(
            request['images'],
            request['name'],
            request['weightInKo'],
            request['sizeX'],    
            request['sizeY']
        )}
    end

    def test_no_weight
        json_file = File.read('test-no-weight-request.json')        
        request = JSON.parse(json_file)
        assert_raise(ArgumentError){
            mosaic_builder = MosaicBuilder.new(
            request['images'],
            request['name'],
            request['weightInKo'],
            request['sizeX'],    
            request['sizeY']
        )}
    end


    def test_no_images
        json_file = File.read('test-no-images-request.json')        
        request = JSON.parse(json_file)
        assert_raise(ArgumentError){
            mosaic_builder = MosaicBuilder.new(
            request['images'],
            request['name'],
            request['weightInKo'],
            request['sizeX'],    
            request['sizeY']
        )}
    end


end