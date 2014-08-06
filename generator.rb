require 'haml'

class Generator
  def self.generate! images
    images.sort_by { |i| i.captured_at }
    input = images.first.src
    output = images.first.dest
    html = Haml::Engine.new(File.read(input + "templates/index.haml")).render(Object.new, {:images => images})
    File.write(output + 'index.html', html)
  end
end
