require 'fileutils'
require 'optparse'

require File.join(File.dirname(__FILE__), 'command')
require File.join(File.dirname(__FILE__), 'config')
require File.join(File.dirname(__FILE__), 'gcc')

module Hcache

  class App
    def initialize(args)
      @args = args
      @cache_dir = App.get_cache_dir
      @relative_mode = false
      @config = Config.read(File.join(@cache_dir, 'config'))
      @gcc_default_includes = File.join(@cache_dir, 'gcc_default_includes')
    end
  
    def self.get_cache_dir 
      result = ENV["HCACHE_DIR"]
      return result + '/' unless result.nil?

      result = ENV["HOME"]
      return File.join(result, '.hcache/') unless result.nil?
      
      nil
    end

    def run
      parse_options! @args
      FileUtils.mkdir_p @cache_dir

      gcc_default_includes = GCC.default_includes(@gcc_default_includes)
      command = Command.new

      dep_command = command.rewrite(@args, @cache_dir, gcc_default_includes, true, "-M -MP")
      dep_output = `#{dep_command} | grep ":$" | sed -e "s/:$//g"`
    
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
    
      %x[#{command.rewrite(@args, @cache_dir, gcc_default_includes)}]
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

    def is_option?(arg)
      arg[0, 1] == "-"
    end
  
    def eat_hcache_args!(args)
      result = []
      while not args.empty?
        break if not is_option? args[0]
        result.push args.shift
      end
      result
    end
  end

end

