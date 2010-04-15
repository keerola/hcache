module Hcache

  class Command

    attr_reader :command

    def initialize(args, cache_dir, default_includes)
      @args = args.clone
      @cache_dir = cache_dir
      @default_includes = default_includes
      @command = get_command
    end

    def get_command
      command = @args.shift
      for default_include in @default_includes
        command += " -I#{@cache_dir}#{default_include}"
      end
      command
    end

    alias :to_s :command

  end

  class CompileCommand < Command

    def initialize(args, cache_dir, default_includes)
      super
    end

    def get_command
      command = super
      old_includes = ""
      while not @args.empty? do
        arg = @args.shift
        if arg.match(/^\-I/)
          include_dir = arg[2, arg.length]
          command += " -I#{@cache_dir}#{include_dir}"
          old_includes += " -I#{include_dir}"
        else
          command += " #{arg}"    
        end
      end
      command += old_includes
    end

  end
  
  class DependencyCommand < Command
    
    def initialize(args, cache_dir, default_includes)
      super
    end
  
    def get_command
      command = super
      old_includes = ""
      while not @args.empty? do
        arg = @args.shift
        if arg.match(/^\-I/)
          include_dir = arg[2, arg.length]
          command += " -I#{@cache_dir}#{include_dir}"
          old_includes += " -I#{include_dir}"
        elsif arg == "-o"
          @args.shift
        else
          command += " #{arg}"    
        end
      end
      command += " -M -MP"
      command += old_includes
    end
  
  end

end

