require 'micro_magick'
require 'yaml'
require 'fileutils'

class Image
  attr_accessor :filename, :src, :dest
  def initialize path, destination
    @filename = File.basename path
    @src = path.gsub @filename, ""
    @dest = destination + '/'
    check
  end

  def check
    puts Rainbow("Processing: ").blue + Rainbow(name).underline
    if File.exists? processed_path
      puts Rainbow("\t\t...file exists").green
      process unless processed_image_is_current?
    else
      process
    end
  end

  def process
    puts Rainbow("\t\t...shrinking").green
    check_and_make processed_folder
    write_meta shrink
  end

  def shrink
    i = MicroMagick::Image.new original_path
    if i.width > 2500 or i.height > 2500
      i.strip.resize("2500x2500").write processed_path
    else
      i.strip.write processed_path
    end
    return i
  end

  def write_meta i
    mtime = File.mtime original_path
    unless i[:profile_exif][:date_time_digitized].nil?
      captured_at = Time.parse i[:profile_exif][:date_time_digitized].split(' ').first.gsub(':','-')
    else
      captured_at = Time.parse i[:profile_exif][:date_time].split(' ').first.gsub(':','-')
    end
    check_and_write YAML.dump({ mtime: mtime, captured_at: captured_at })
  end

  def read_meta
    @meta = YAML.load File.read(meta_path) rescue nil
  end

  def processed_image_is_current?
    return false if read_meta.nil?
    if File.mtime(original_path) == @meta[:mtime]
      puts Rainbow("\t\t...and is current!").green
      true
    else
      puts Rainbow("\t\t...is not current").green
      false
    end
  end

  def name
    @filename.gsub File.extname(@filename),""
  end

  def original_path
    @src + @filename
  end

  def processed_path
    processed_folder + name + '.jpg'
  end

  def processed_folder
    @dest + 'processed/'
  end

  def meta_path
    meta_folder + meta_name
  end

  def meta_folder
    @dest + 'meta/'
  end

  def meta_name
    name + '.yml'
  end

  def captured_at
    @meta[:captured_at]
  end

  def relative_folder
    binding.pry
  end

  def check_and_make folder
    FileUtils.mkdir_p folder unless File.directory? folder
  end

  def check_and_write payload
    check_and_make meta_folder
    File.write meta_path,payload
  end

  def formatted_date
    captured_at.strftime("#{ordinalize(captured_at.day)} of %B, %Y")
  end

  def ordinalize n
    if (11..13).include?(n % 100)
      "#{n}th"
    else
      case n % 10
        when 1; "#{n}st"
        when 2; "#{n}nd"
        when 3; "#{n}rd"
        else    "#{n}th"
      end
    end
  end
end
