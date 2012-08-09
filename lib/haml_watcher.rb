require 'rubygems'
require 'listen'
require 'haml'

class HamlWatcher
  class << self
    def watch(source, dest)
      @source = source
      @dest = dest

      refresh
      puts ">>> HamlWatcher is watching for changes. Press Ctrl-C to Stop."
      Listen.to(source, :filter => /\.haml$/) do |modified, added, removed|
        modified.each do |m|
          puts "M #{m}"
          HamlWatcher.compile(m)
        end

        added.each do |a|
          puts "A #{a}"
          HamlWatcher.compile(a)
        end

        removed.each do |r|
          puts "R #{r}"
          HamlWatcher.remove(r)
        end
      end
    end

    def output_file(filename)
      File.join(@dest, File.basename(filename).gsub(/\.haml$/,'.html'))
    end

    def remove(file)
      output = output_file(file)
      begin
        File.delete output
        puts "\033[0;31m   remove\033[0m #{output}"
      rescue
        puts "\033[0;31m    error\033[0m #{output}"
      end
    end

    def compile(file)
      output_file_name = output_file(file)
      origin = File.open(file).read
      begin
        result = Haml::Engine.new(origin).render
        raise if result.empty?
      rescue Object
        $!.inspect
        puts "\033[0;31m    error\033[0m #{file}"
      end
      # Write rendered HTML to file
      color, action = File.exist?(output_file_name) ? [33, 'overwrite'] : [32, '   create']
      puts "\033[0;#{color}m#{action}\033[0m #{output_file_name}"
      File.open(output_file_name,'w') {|f| f.write(result)}
    end

    # Check that all haml templates have been rendered.
    def refresh
      Dir.glob('haml/**/*.haml').each do |file|
        file.gsub!(/^haml\//, '')
        compile(file) unless File.exist?(output_file(file))
      end
    end
  end
end
