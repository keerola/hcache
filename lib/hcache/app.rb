require 'optparse'

class App
  def initialize(args)
    @args = args
    @cache_dir = get_cache_dir
    @relative_mode = false
  end
  
  def get_cache_dir 
    result = ENV["HCACHE_DIR"]
    if result.nil?
      home = ENV["HOME"]
      result = "#{home}/.hcache/"
    end
    
    result += '/' unless result.match(/\/$/)
    result
  end

  def run
    parse_options! @args
    
    `mkdir -p #{@cache_dir}`
    
    @gcc_default_includes_file = "#{@cache_dir}/gcc_default_includes"
    
    def read_gcc_default_includes
      Marshal.load(IO.read(@gcc_default_includes_file))
    end
    
    def cache_gcc_default_includes
      result = []
      output = `echo | cpp -v 2>&1`
    
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
    
      write_gcc_default_includes(result)
    end
    
    def gcc_default_includes
      unless File.exist? @gcc_default_includes_file
        cache_gcc_default_includes
      end
      read_gcc_default_includes  
    end
    
    def add_to_gcc_default_includes(new_include)
      includes = gcc_default_includes
      unless includes.include? new_include
        includes.push(new_include)
        write_gcc_default_includes(includes)
      end
    end
    
    def write_gcc_default_includes(includes)
      file = File.new(@gcc_default_includes_file, 'w')
      file.write(Marshal.dump(includes))
      file.close
    end
    
    def rewrite_command(cache_dir, remove_o=false, insert_args="")
      argv = @args.clone
      command = "#{argv.shift} "
      new_includes = gcc_default_includes
      old_includes = ""
      while !new_includes.empty? do
        include_dir = new_includes.shift
        command += "-I#{cache_dir}#{include_dir} "
      end
      while !argv.empty? do
        arg = argv.shift
        if arg.match(/^\-I/)
          include_dir = arg[2, arg.length]
          command += "-I#{cache_dir}#{include_dir} "
          old_includes += "-I#{include_dir} "
        elsif arg == "-o" and remove_o
          argv.shift
        else
          command += "#{arg} "    
        end
      end
      command += "#{insert_args} #{old_includes}"
      command
    end
    
    puts rewrite_command(@cache_dir, true, "-M -MP")
    dep_output = `#{rewrite_command(@cache_dir, true, "-M -MP")} | grep ":$" | sed -e "s/:$//g"`
    
    puts "Dependencies:"
    dep_output.each_line do |file|
      file.strip!
      if file.match(/^#{@cache_dir}/)
        print "  [ HIT      ] "
        puts " #{file.gsub(/^#{@cache_dir}/, "")}"
        next
      end
      target = "#{@cache_dir}#{file}"
      if not @relative_mode and not file.match(/^\//)
        print "  [ RELATIVE ] "
      elsif File.exists? target
        print "  [ UNCACHED ] "
        add_to_gcc_default_includes(File.dirname(file))
      else
        print "  [ MISS     ] "
        `mkdir -p \`dirname #{target}\``
        `cp -f #{file} #{target}`
      end
      puts " #{file}"
    end
    
    %x[#{rewrite_command(@cache_dir)}]
  end

  def parse_options!(args)
    hcache_args = eat_hcache_args! args
    
    opts = OptionParser.new 
    opts.on('--relative') { @relative_mode = true }
    
    opts.parse! hcache_args
    
    def usage
      $stderr.puts "Usage: hcache [--relative] gcc ..."
      exit 2
    end
    
    usage unless args.length > 0
  end

  def is_hcache_option(option)
    option[0, 1] == "-"
  end
  
  def eat_hcache_args!(args)
    result = []
    while not args.empty?
      break if !is_hcache_option args[0]
      result.push args.shift
    end
    result
  end
end
