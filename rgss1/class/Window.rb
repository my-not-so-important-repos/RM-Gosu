class Window
  
  attr_reader :windowskin, :contents, :stretch, :opacity, :back_opacity, :contents_opacity
  attr_reader :width, :height, :viewport, :cursor_rect
  attr_accessor :x, :y, :z, :ox, :oy, :active, :visible, :pause
  
  def initialize(viewport = nil)
    @viewport = viewport
    @x, @y, @z, @ox, @oy = 0, 0, 0, 0, 0
    @stretch = true
    @active = false
    @visible = true
    @pause = false
    @opacity = 255
    @back_opacity = 255
    @contents_opacity = 255
    @sprites = {
      :contents => Sprite.new,
      :back => Sprite.new,
      :border => Sprite.new,
      :arrow_left => Sprite.new,
      :arrow_up => Sprite.new,
      :arrow_right => Sprite.new,
      :arrow_down => Sprite.new,
      :pause_one => Sprite.new,
      :pause_two => Sprite.new,
      :pause_three => Sprite.new,
      :pause_four => Sprite.new,
      :cursor => Sprite.new
    }
    @sprites.values.each {|a| Graphics.remove_sprite(a) }
    Graphics.add_sprite(self)
  end
  
  def windowskin=(bit)
    @windowskin = bit
    @sprites[:back] = @stretch ? Sprite.new : Plane.new
    Graphics.remove_sprite(@sprites[:back])
    bitm = Bitmap.new(128, 128)
    if @stretch
      bitm.stretch_blt(Rect.new(0, 0, @width, @height), bit, Rect.new(0, 0, 128, 128), 255)
    else
      bitm.blt(0, 0, bit, Rect.new(0, 0, 128, 128))
    end
    @sprites[:back].bitmap = bitm
    setup_arrows
    setup_pauses
    setup_border
    setup_cursor
  end
  
  def contents=(bit)
    @contents = bit
    @sprites[:contents].bitmap = bit
  end
  
  def stretch=(bool)
    @stretch = bool
    self.windowskin = @windowskin
  end
  
  def opacity=(int)
    @opacity = int
    @sprites.values.each {|a|
      a.opacity = int
    }
    @sprites[:back_opacity].opacity = @back_opacity
    @sprites[:contents].opacity = @contents_opacity
    @sprites[:cursor].opacity = 255
  end
  
  def back_opacity=(int)
    @back_opacity = int
    @sprites[:back].opacity = int
  end
  
  def contents_opacity=(int)
    @contents_opacity = int
    @sprites[:contents].opacity = int
  end
  
  def cursor_rect=(rect)
    @cursor_rect = rect
    setup_cursor
  end
  
  # NEW
  
  def draw
  end
  
  private
  
  def setup_arrows
  end
  
  def setup_pauses
  end
  
  def setup_border
  end
  
  def setup_cursor
  end
end