class Bitmap
  
  attr_reader :rect, :gosu_image, :chunkypng_image
  attr_accessor :font
  
  def initialize(width, height = nil)
    case height
    when nil
      if width.is_a?(String)
        @gosu_image = Gosu::Image.new(Graphics.gosu_window, width, false)
      else
        raise ArguementError
      end
    when Integer
      @gosu_image = Gosu::Image.new(Graphics.gosu_window, ChunkyPNG::Canvas.new(width, height), false)
    end
    @rect = Rect.new(0, 0, @gosu_image.width, @gosu_image.height)
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
    im2 = ChunkyPNG::Canvas.from_gosu(src_bitmap.gosu_image)
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity)
    im1.compose!(im2, x, y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, im1, false)
    set_chunkypng_image
  end
  
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    im1 = @chunkypng_image
    im2 = ChunkyPNG::Canvas.from_gosu(src_bitmap.gosu_image)
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity)
    im2.resample_bilinear!(dest_rect.width, dest_rect.height)
    im1.compose!(im2, dest_rect.x, dest_rect.y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, im1, false)
    set_chunkypng_image
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
      raise ArguementError
    end
    im = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color.rgba(*args[4].to_a))
    @chunkypng_image.replace!(im, x, y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
    set_chunkypng_image
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
      raise ArguementError
    end
    im = ChunkyPNG::Canvas.new(width, height)
    @chunkypng_image.replace!(im, x, y)
    @gosu_image = Gosu::Image.new(Graphics.gosu_window, @chunkypng_image, false)
    set_chunkypng_image
  end
  
  def get_pixel(x, y)
    Color.new(*ChunkyPNG::Color.from_int(@chunkypng_image.get_pixel(x, y)))
  end
  
  def set_pixel(x, y, color)
  end
  
  def hue_change(hue)
  end
  
  def blur
  end
  
  def radial_blur(angle, division)
  end
  
  def draw_text(*args)
  end
  
  def text_size(string)
  end
  
  # NEW
  
  def set_chunkypng_image
    @chunkypng_image = ChunkyPNG::Canvas.from_gosu(@gosu_image)
  end
end