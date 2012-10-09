class Viewport
  
  attr_accessor :color, :tone, :rect, :visible, :z, :ox, :oy
  
  def initialize(*args)
    case args.size
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
    @visible = true
    @z = 0
    @ox = 0
    @oy = 0
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