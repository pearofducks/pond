require 'bundler/setup'
require 'rainbow'
require_relative 'image'
require_relative 'generator'

class Pond
  def self.go input, output
    @input = File.expand_path input rescue abort("Usage: pond INTPUT OUTPUT")
    @output = File.expand_path output rescue abort("Usage: pond INTPUT OUTPUT")
    @images = []
    puts "\n\n"
    puts Rainbow("Input is:").yellow + ' ' + Rainbow(@input).underline
    puts Rainbow("Output is:").yellow + ' ' + Rainbow(@output).underline
    inputs = Dir.glob(@input + '**/*.jpg', File::FNM_CASEFOLD) # case-insensitive glob
    puts Rainbow("Found #{inputs.length} images...").yellow
    puts "\n\n"
    inputs.each do |unprocessed_file|
      @images << Image.new(unprocessed_file, @output)
    end
    Generator.generate! @images
  end
end
