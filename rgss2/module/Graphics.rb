module Graphics

  class << self
    
    attr_accessor :frame_count, :gosu_window
    attr_reader :brightness, :frame_rate
    
    def brightness=(int)
      @brightness = [[255, int].min, 0].max
      @draw_color.alpha = 255 - @brightness
    end
    
    def frame_rate=(int)
      @frame_rate = [[120, int].min, 10].max
      #reform_window(width, height, fullscreen?, 1.0 / @frame_rate * 1000)
    end
  end
  
  @frame_rate = 60
  @brightness = 255
  @frame_count = 0
  @frozen = false
  @draw_color = Gosu::Color::BLACK
  @draw_color.saturation = 0
  @draw_color.alpha = 0
  @@gosu_sprites = []

  module_function
  
  def update
    @current = gosu_window.record(gosu_window.width, gosu_window.height) { 
      @@gosu_sprites.each {|sprite|
        sprite.draw
      }
    }
    sleep 1.0 / frame_rate
    @frame_count += 1
    @latest = @current if !@frozen
  end
  
  def wait(duration)
    duration.times { update }
  end
  
  def fadeout(duration)
    Thread.new {
      rate = @brightness / duration.to_f
      until @brightness <= 0
        self.brightness -= rate
        sleep 1.0 / frame_rate
      end
      self.brightness = 0
    }
  end
  
  def fadein(duration)
    Thread.new { 
      rate = 255 / duration.to_f
      until @brightness >= 255
        self.brightness += rate
        sleep 1.0 / frame_rate
      end
      self.brightness = 255
    }
  end
  
  def freeze
    @frozen = true
  end
  
  def transition(duration = 10, filename = "", vague = 40)
    @frozen = false
    # VAGUE ELUDES ME AS TO HOW TO INTEGRATE
  end
  
  def snap_to_bitmap
    Bitmap.from_gosu(@current)
  end
  
  def frame_reset
    # AT A LOSS ON HOW TO INTEGRATE
  end
  
  def width
    gosu_window.width
  end
  
  def height
    gosu_window.height
  end
  
  def resize_screen(w, h)
    reform_window(w, h, fullscreen?, gosu_window.update_interval)
  end
  
  # NEW
  
  def add_sprite(sprite)
    @@gosu_sprites << sprite
  end
  
  def remove_sprite(sprite)
    @@gosu_sprites.delete(sprite)
  end
  
  def fullscreen?
    gosu_window.fullscreen?
  end
  
  def latest
    if @latest
      @latest.draw(0, 0, 0)
      c = @draw_color
      args = [0, 0, c, 0, height, c, width, 0, c, width, height, c, 1]
      Graphics.gosu_window.draw_quad(*args)
    end
  end
  
  def set_fullscreen(bool)
    return if bool == fullscreen?
    reform_window(width, height, bool, gosu_window.update_interval)
  end
  
  def reform_window(w, h, f, fps)
    Graphics.gosu_window.close
    Graphics.gosu_window = GosuGame.new(w, h, f, fps)
    Graphics.gosu_window.show
  end
end