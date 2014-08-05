require 'micro_magick'
require 'yaml'


class Image
  def initialize path, destination
    @original = path
    @dest = destination
    process
  end

  def check
    if File.exists? processed_name
      if processed_image_is_current?
      else
        process
      end
    else
      process
    end
  end
  
  def process
    write_meta shrink
  end

  def shrink
    i = MicroMagick::Image.new @original
    if i.width > 2500 or i.height > 2500
      i.strip.resize("2500x2500").write processed_name
    elsif File.size(@original)/1024/1024 > 1
      i.strip.write processed_name
    end
    return i
  end

  def write_meta i
    mtime = File.mtime @original
    captured_at = i[:profile_exif][:date_time]
    check_and_write YAML.dump({ mtime: mtime, captured_at: captured_at })
  end

  def processed_image_is_current?
    # original_mtime = File.mtime @original
    # processed_mtime =
    # if original_mtime == processed_mtime
    # end
  end

  def processed_name
    @dest + '/' + File.basename(@original)
  end

  def check_and_write payload
    meta_folder = @dest + '/meta/'
    puts meta_folder
    Dir.mkdir meta_folder unless File.directory? meta_folder
    target = meta_folder + File.basename(@original,'.jpg') + '.yml'
    File.write target,payload
  end
end

# meta folder
#
#
# yaml data
# i[:profile_exif][:date_time]
# compare modified dates File.mtime
