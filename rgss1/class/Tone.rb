class Tone
  
  attr_reader :red, :green, :blue, :gray
  
  def initialize(red, green, blue, gray = 0)
    set(red, green, blue, gray)
  end
  
  def set(red, green, blue, gray = 0)
    self.red = red
    self.green = green
    self.blue = blue
    self.gray = 0
  end
  
  def red=(int)
    @red = [[255, int].min, -255].max.to_f
  end
  
  def green=(int)
    @green = [[255, int].min, -255].max.to_f
  end
  
  def blue=(int)
    @blue = [[255, int].min, -255].max.to_f
  end
  
  def gray=(int)
    @gray = [[255, int].min, 0].max.to_f
  end
  
  def _dump(d = 0)
    [@red, @green, @blue, @gray].pack('d4')
  end
   
  def self._load(s)
    Tone.new(*s.unpack('d4'))
  end
end