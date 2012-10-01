class Viewport
  
  attr_accessor :color, :tone, :rect, :visible, :z, :ox, :oy
  
  def initialize(*args)
    case args.size
    when 0
      @rect = Rect.new(0, 0, Graphics.width, Graphics.height)
    when 1
      if args[0].is_a?(Rect)
        @rect = args[0]
      else
        raise ArgumentError
      end
    when 4
      @rect = Rect.new(*args)
    else
      raise ArgumentError
    end
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
    @disposed
  end
  
  def flash(color, duration)
    @flash_color = color
    @flash_duration = duration
  end
  
  def update
  end
end