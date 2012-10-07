class Bitmap
  
  attr_reader :rect, :chunkypng_image
  attr_accessor :font, :gosu_image
  
  ALIGN = {0 => :left, 1 => :right, 2 => :center, 3 => :justify}
  
  def initialize(width, height = nil)
    case height
    when nil
      if width.is_a?(String)
        @gosu_image = Gosu::Image.new(Graphics.gosu_window, width, false)
      else
        raise ArgumentError
      end
    when Integer
      @gosu_image = Gosu::Image.new(Graphics.gosu_window, ChunkyPNG::Canvas.new(width, height), false)
    end
    @rect = Rect.new(0, 0, @gosu_image.width, @gosu_image.height)
    @font = Font.new
    set_chunkypng_image
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
    @disposed
  end
  
  def width
    @gosu_image.width
  end
  
  def height
    @gosu_image.height
  end
  
  def blt(x, y, src_bitmap, src_rect, opacity = 255)
    im1 = @chunkypng_image
    im2 = src_bitmap.chunkypng_image.dup
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity) unless opacity == 255
    im1.compose!(im2, x, y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, im1, false)
  end
  
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    im1 = @chunkypng_image
    im2 = src_bitmap.chunkypng_image.dup
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity) unless opacity == 255
    im2.resample_bilinear!(dest_rect.width, dest_rect.height)
    im1.compose!(im2, dest_rect.x, dest_rect.y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, im1, false)
  end
  
  def fill_rect(*args)
    case args.size
    when 2, 5
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
      else
        x, y, width, height = *args[0..3]
      end
    else
      raise ArgumentError
    end
    color = ChunkyPNG::Color.rgba(*args[4].to_a)
    @chunkypng_image.rect(x, y, width, height, color, color)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
  end
  
  def gradient_fill_rect(*args)
  end
  
  def clear
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, ChunkyPNG::Canvas.new(width, height), false)
    set_chunkypng_image
  end
  
  def clear_rect(*args)
    case args.size
    when 1, 4
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
      else
        x, y, width, height = *args
      end
    else
      raise ArgumentError
    end
    @chunkypng_image.rect(x, y, width, height, ChunkyPNG::Color::TRANSPARENT)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
  end
  
  def get_pixel(x, y)
    Color.new(*ChunkyPNG::Color.from_int(@chunkypng_image.get_pixel(x, y)))
  end
  
  def set_pixel(x, y, color)
    @chunkypng_image.set_pixel(x, y, ChunkyPNG::Color.rgba(*color.to_a.collect {|a| a.to_i }))
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
  end
  
  def hue_change(hue)
    @chunkypng_image.hue_change(hue)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
  end
  
  def blur
  end
  
  def radial_blur(angle, division)
  end
  
  def draw_text(*args)
  end
  
  def text_size(string)
    f = Gosu::Font.new(Graphics.gosu_window, @font.first_existant_name, @font.size)
    Rect.new(0, 0, f.text_width(string), f.height)
  end
  
  # NEW
  
  def self.from_gosu(img)
    bitmap = Bitmap.new(img.width, img.height)
    bitmap.gosu_image = img
    bitmap.set_chunkypng_image
    bitmap
  end
  
  def set_chunkypng_image
    @chunkypng_image = ChunkyPNG::Canvas.from_gosu(@gosu_image)
  end  
end