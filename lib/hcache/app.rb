require 'fileutils'
require 'optparse'

require File.join(File.dirname(__FILE__), 'gcc')
require File.join(File.dirname(__FILE__), 'config')

module Hcache

  class App
    def initialize(args)
      @args = args
      @cache_dir = get_cache_dir
      @relative_mode = false
      @config = Config.read(File.join(@cache_dir, 'config'))
      @gcc_default_includes = File.join(@cache_dir, 'gcc_default_includes')
    end
  
    def get_cache_dir 
      result = ENV["HCACHE_DIR"]
      if result.nil?
        result = File.join(ENV["HOME"], '.hcache/')
      end
      result += '/' unless result.match(/\/$/)
      result
    end

    def run
      parse_options! @args
      FileUtils.mkdir_p @cache_dir
    
      def rewrite_command(cache_dir, remove_o=false, insert_args="")
        argv = @args.clone
        command = "#{argv.shift} "
        new_includes = GCC.default_includes(@gcc_default_includes)
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
        if @config.included.match(file).nil?
          print "  [ EXCLUDED ] "
        elsif not @relative_mode and not file.match(/^\//)
          print "  [ RELATIVE ] "
        elsif File.exists? target
          print "  [ UNCACHED ] "
          GCC.add_default_include(File.dirname(file), @gcc_default_includes)
        else
          print "  [ MISS     ] "
          FileUtils.mkdir_p File.dirname(target)
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
    
      opts.parse! hcache_args rescue usage
    
      usage unless args.length > 0
    end
    
    def usage
      $stderr.puts "Usage: hcache [--relative] gcc ..."
      exit 2
    end

    def is_hcache_option?(option)
      option[0, 1] == "-"
    end
  
    def eat_hcache_args!(args)
      result = []
      while not args.empty?
        break if not is_hcache_option? args[0]
        result.push args.shift
      end
      result
    end
  end

end

