class Color
  
  attr_reader :red, :green, :blue, :alpha
  
  def initialize(red, green, blue, alpha = 255)
    set(red, green, blue, alpha)
  end
  
  def set(red, green, blue, alpha = 255)
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  end
  
  def red=(int)
    @red = [[255, int].min, 0].max.to_f
  end
  
  def green=(int)
    @green = [[255, int].min, 0].max.to_f
  end
  
  def blue=(int)
    @blue = [[255, int].min, 0].max.to_f
  end
  
  def alpha=(int)
    @alpha = [[255, int].min, 0].max.to_f
  end
  
  def _dump(d = 0)
    [@red, @green, @blue, @alpha].pack('d4')
  end
   
  def self._load(s)
    Color.new(*s.unpack('d4'))
  end
end