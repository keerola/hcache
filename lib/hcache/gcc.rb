module Hcache

  class GCC
    def self.get_default_includes
      parse_default_includes `echo | cpp -v 2>&1`
    end

    def self.parse_default_includes(output)
      result = []
      lines = []
      output.each_line do |line|
        lines.push line
      end
  
      while !lines.empty?
        line = lines.shift
        break if line.match(/#include \"...\" search starts here:/)
      end
  
      while !lines.empty?
        line = lines.shift
        break if line.match(/#include <...> search starts here:/)
        next if line.match(/framework directory/)
        result.push line.strip
      end
  
      while !lines.empty?
        line = lines.shift
        break if line.match(/End of search list./)
        next if line.match(/framework directory/)
        result.push line.strip
      end
      result 
    end

    def self.default_includes(filename)
      unless File.exist? filename
        write_default_includes(get_default_includes, filename)
      end
      read_default_includes(filename)
    end
    
    def self.add_default_include(new_include, filename)
      includes = default_includes(filename)
      unless includes.include? new_include
        includes.push(new_include)
        write_default_includes(includes, filename)
      end
    end
    
    def self.read_default_includes(filename)
      Marshal.load(IO.read(filename))
    end

    def self.write_default_includes(includes, filename)
      file = File.new(filename, 'w')
      file.write(Marshal.dump(includes))
      file.close
    end
  end

end

