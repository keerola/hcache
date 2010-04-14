class GCC
  def self.default_includes
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
end
