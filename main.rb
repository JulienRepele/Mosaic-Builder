require 'json'
require './mosaic-builder'

jsonFile = File.read('request.json')
request = JSON.parse(jsonFile)

mosaicBuilder = MosaicBuilder.new(
    request['images'],
    request['name'],
    request['weightInKo'],
    request['sizeX'],    
    request['sizeY']
)

mosaicBuilder.write

#puts mosaicBuilder.fragments[0].url
=begin
request['images'].each{
    |image| puts image['url']
}
image = request['images'][0]
fragment = Fragment.new(
    image['url'],
    image['positionX'],
    image['positionY'],
    image['percentageX'],
    image['percentageY'],
    request['sizeX'],
    request['sizeY']
)
fragment.test
=end
