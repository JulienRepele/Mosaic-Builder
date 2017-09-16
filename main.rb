require 'json'
require './mosaic-builder'

json_file = File.read('request.json')
request = JSON.parse(json_file)

mosaicBuilder = MosaicBuilder.new(
    request['images'],
    request['name'],
    request['weightInKo'],
    request['sizeX'],    
    request['sizeY']
)

mosaicBuilder.write
