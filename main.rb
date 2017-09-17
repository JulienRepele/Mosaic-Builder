require 'json'
require_relative 'mosaic-builder'

json_file = File.read('request.json')
request = JSON.parse(json_file)

mosaic_builder = MosaicBuilder.new(
    request['images'],
    request['name'],
    request['weightInKo'],
    request['sizeX'],    
    request['sizeY']
)

mosaic_builder.write
