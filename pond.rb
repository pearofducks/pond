require 'bundler/setup'
require 'micro_magick'
require 'pry'

class Pond
  def self.go input, output
    @input = File.expand_path input
    @output = File.expand_path(output || '.')
    images = Dir.glob(@input + '**/*')
    images.each do |image|
      name = File.basename image
      out_name = @output + '/' + name
      i = MicroMagick::Image.new image
      if i.width > 2500 or i.height > 2500
        i.strip.resize("2500x2500").write out_name
      elsif File.size(image)/1024/1024 > 1
        i.strip.write out_name
      end
    end
  end
end

Pond.go ARGV[0], ARGV[1]
# yaml data
# i[:profile_exif][:date_time]
# compare modified dates File.mtime
