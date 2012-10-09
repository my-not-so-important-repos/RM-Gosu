class Bitmap
  
  attr_reader :rect, :chunkypng_image, :gosu_image
  attr_accessor :font
  
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
    im2 = src_bitmap.chunkypng_image.dup
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity) unless opacity == 255
    @gosu_image.insert(im2, x, y)
    set_chunkypng_image
  end
  
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
    im2 = src_bitmap.chunkypng_image.dup
    im2.crop!(*src_rect.to_a)
    im2.set_opacity(opacity) unless opacity == 255
    im2.resample_bilinear!(dest_rect.width, dest_rect.height)
    @gosu_image.insert(im2, dest_rect.x, dest_rect.y)
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
      raise ArgumentError
    end
    color = ChunkyPNG::Color.rgba(*args[4].to_a.collect {|a| a.round })
    img = ChunkyPNG::Canvas.new(width, height, color)
    @gosu_image.insert(img, x, y)
    set_chunkypng_image
  end
  
  def clear
    @gosu_image.insert(ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT), 0, 0)
    set_chunkypng_image
  end
  
  def get_pixel(x, y)
    Color.new(*ChunkyPNG::Color.from_int(@chunkypng_image.get_pixel(x, y)))
  end
  
  def set_pixel(x, y, color)
    fill_rect(x, y, 1, 1, color)
  end
  
  def hue_change(hue)
    @chunkypng_image.hue_change(hue)
    @gosu_image.insert(@chunkypng_image, 0, 0)
  end
  
  def draw_text(*args)
    case args.size
    when 2, 3
      x, y, width, height = *args[0].to_a
      string = args[1]
      align = args[2]
    when 5, 6
      x, y, width, height = *args[0, 4]
      string = args[4]
      align = args[5]
    else
      raise ArgumentError
    end
    string = string.to_s.gsub('<', '&lt;').gsub('>', '&gt;')
    if @font.bold
      string.prepend("<b>") << "</b>"
    end
    if @font.italic
      string.prepend("<i>") << "</i>"
    end
    image = Gosu::Image.from_text(Graphics.gosu_window, string, @font.first_existant_name, @font.size)
    image = ChunkyPNG::Canvas.from_gosu(image)
    image.each_pixel {|c| 
      color = @font.color.dup
      color.alpha = ChunkyPNG::Color.a(c)
      ChunkyPNG::Color.rgba(*color.to_a.collect {|a| a.round })
    }
    image = Gosu::Image.new(Graphics.gosu_window, image, false)
    x += (width - image.width) * (align || 0) / 2
    bitmap = Bitmap.from_gosu(image)
    rect = Rect.new(x, y, bitmap.width > width ? width : bitmap.width, bitmap.height > height ? height : bitmap.height)
    if rect.to_a == bitmap.rect.to_a
      blt(x, y, bitmap, bitmap.rect)
    else
      stretch_blt(rect, bitmap, bitmap.rect)
    end
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
  
  def gosu_image=(im)
    @gosu_image = im
    @rect = Rect.new(0, 0, im.width, im.height)
  end
end