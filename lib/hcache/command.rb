module Hcache

  class CommandBase

    def initialize(args, cache_dir, default_includes)
      @args = args.clone
      @cache_dir = cache_dir
      @default_includes = default_includes
      @command = get_command 
    end

    def get_command
      command = "#{@args.shift}"
      for default_include in @default_includes
        command += " -I#{@cache_dir}#{default_include}"
      end
      command
    end

    def to_s
      @command
    end

  end

  class Command < CommandBase

    def initialize(args, cache_dir, default_includes, remove_o=false,
                   insert_args="")
      super(args, cache_dir, default_includes)
      @command += rewrite(remove_o, insert_args)
    end

    def rewrite(remove_o, insert_args)
      command = ""
      old_includes = ""
      while not @args.empty? do
        arg = @args.shift
        if arg.match(/^\-I/)
          include_dir = arg[2, arg.length]
          command += " -I#{@cache_dir}#{include_dir}"
          old_includes += " -I#{include_dir}"
        elsif arg == "-o" and remove_o
          @args.shift
        else
          command += " #{arg}"    
        end
      end
      command += " #{insert_args} #{old_includes}"
      command
    end

  end

end

