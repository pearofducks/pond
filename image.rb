require 'micro_magick'
require 'yaml'


class Image
  def initialize path, destination
    @original = path
    @dest = destination
    check
  end

  def check
    puts Rainbow("Processing: ").blue + Rainbow(File.basename(@original)).underline
    if File.exists? processed_name
      puts Rainbow("\tfile exists... ").green
      process unless processed_image_is_current?
    else
      process
    end
  end
  
  def process
    puts Rainbow("\tshrinking... ").green
    check_and_make processed_folder
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
    captured_at = Time.parse i[:profile_exif][:date_time].split(' ').first.gsub(':','-')
    check_and_write YAML.dump({ mtime: mtime, captured_at: captured_at })
  end

  def read_meta
    @meta = YAML.load File.read(meta_folder + meta_name) rescue nil
  end

  def processed_image_is_current?
    return false if read_meta.nil?
    if File.mtime(@original) == @meta[:mtime]
      puts Rainbow("\tand is current! ").green
      true
    else
      puts Rainbow("\tis not current... ").green
      false
    end
  end

  def processed_name
    processed_folder + File.basename(@original)
  end

  def processed_folder
    @dest + '/processed/'
  end

  def meta_folder
    @dest + '/meta/'
  end

  def meta_name
    File.basename(@original,'.jpg') + '.yml'
  end

  def check_and_make folder
    Dir.mkdir folder unless File.directory? folder
  end

  def check_and_write payload
    check_and_make meta_folder
    target = meta_folder + meta_name
    File.write target,payload
  end
end
