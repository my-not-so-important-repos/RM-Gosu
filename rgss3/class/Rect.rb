class Rect
  
  attr_accessor :x, :y, :width, :height
  
  def initialize(*args)
    case args.size
    when 0
      set(0, 0, 0, 0)
    when 4
      set(*args)
    else
      raise ArgumentError
    end
  end
  
  def set(*args)
    case args.size
    when 1
      if args[0].is_a?(Rect)
        set(*args[0].to_a)
      else
        raise ArgumentError
      end
    when 4
      @x, @y, @width, @height = *args
    else
      raise ArgumentError
    end
  end
  
  def empty
    set(0, 0, 0, 0)
  end
  
  def to_a
    [x, y, width, height]
  end
end