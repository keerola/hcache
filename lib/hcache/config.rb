class Config

  attr_accessor :included

  def initialize(text)
    @included = Config.parse_included(text)
  end

  def self.parse_included(text)
    begin
      included = Regexp.compile(text.split()[0])
    rescue
      included = /.*/
    end
    included
  end

  def self.read(path)
    begin
      config = Config.new(IO.read(path))
    rescue
      config = Config.new(".*")
    end
    config
  end

end

