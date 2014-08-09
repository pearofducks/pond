require 'haml'

class Generator
  def self.generate! images
    puts Rainbow("Generating site!").yellow
    images.sort_by! { |i| i.captured_at }.reverse!
    input = images.first.src
    output = images.first.dest
    html = Haml::Engine.new(File.read(input + "templates/index.haml")).render(Object.new, {:images => images})
    File.write(output + 'index.html', html)
  end
end
