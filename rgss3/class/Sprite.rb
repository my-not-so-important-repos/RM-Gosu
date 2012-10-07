class Sprite
  
  attr_reader :opacity, :bush_opacity
  attr_accessor :x, :y, :x, :ox, :oy, :zoom_x, :zoom_y
  attr_accessor :src_rect, :bitmap, :viewport, :visible
  attr_accessor :wave_amp, :wave_length, :wave_speed, :wave_phase
  attr_accessor :angle, :mirror, :color, :tone, :blend_type
  attr_accessor :bush_depth
  
  BLEND = {0 => :default, 1 => :additive, 2 => :subtractive}
  
  def initialize(viewport = nil)
    @viewport = viewport
    @visible = true
    @x, @y, @z = 0, 0, 0
    @ox, @oy = 0, 0
    @zoom_x, @zoom_y = 1.0, 1.0
    @angle = 0
    @mirror = false
    @bush_depth = 0
    @bush_opacity = 128
    @opacity = 255
    @blend_type = 0
    @wave_speed = 360
    @src_rect = Rect.new(0, 0, 0, 0)
    Graphics.add_sprite(self)
  end
  
  def initialize_copy
    f = super
    Graphics.add_sprite(f)
    f
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
    @disposed
  end
  
  def flash(color, duration)
    @flash_color = color
    @duration = duration
  end
  
  def update
  end
  
  def width
    @src_rect.width
  end
  
  def height
    @src_rect.height
  end
  
  def opacity=(int)
    @opacity = [[int, 255].min, 0].max
  end
  
  def bush_opacity=(int)
    @bush_opacity = [[int, 255].min, 0].max
  end
  
  def bitmap=(bitmap)
    @bitmap = bitmap
    @src_rect = Rect.new(0, 0, bitmap.width, bitmap.height)
  end
  
  # NEW
  
  def draw
    return if !@visible || @opacity == 0 || @bitmap == nil
    @bitmap.gosu_image.draw_rot(@x, @y, @z, @angle, 0.0, 0.0, @zoom_x * (@mirror ? -1 : 1), @zoom_y, 0xffffffff, BLEND[@blend_type])
  end
end