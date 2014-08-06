require 'bundler/setup'
require 'micro_magick'
require 'rainbow'
require 'pry'
require_relative 'image'
require_relative 'generator'

class Pond
  def self.go input, output
    @input = File.expand_path input
    @output = File.expand_path(output || '.')
    @images = []
    puts Rainbow("\nInput is:").yellow + ' ' + Rainbow(@input).underline
    puts Rainbow("Output is:").yellow + ' ' + Rainbow(@output).underline + "\n\n"
    inputs = Dir.glob(@input + '**/*.jpg', File::FNM_CASEFOLD) # case-insensitive glob
    inputs.each do |unprocessed_file|
      @images << Image.new(unprocessed_file, @output)
    end
    Generator.generate! @images
  end
end

Pond.go ARGV[0], ARGV[1]
