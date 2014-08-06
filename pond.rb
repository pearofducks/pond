require 'bundler/setup'
require 'micro_magick'
require 'rainbow'
require 'pry'
require_relative 'image'

class Pond
  def self.go input, output
    @input = File.expand_path input
    @output = File.expand_path(output || '.')
    puts Rainbow("\nInput is:").yellow + ' ' + Rainbow(@input).underline
    puts Rainbow("Output is:").yellow + ' ' + Rainbow(@output).underline + "\n\n"
    images = Dir.glob(@input + '**/*.jpg', File::FNM_CASEFOLD) # case-insensitive glob
    images.each do |image|
      Image.new image, @output
    end
  end
end

Pond.go ARGV[0], ARGV[1]
