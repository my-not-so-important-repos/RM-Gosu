class Bitmap
  
  attr_reader :rect, :chunkypng_image, :gosu_image
  attr_accessor :font
  
  def initialize(width, height = nil)
    case height
    when nil
      if width.is_a?(String)
        [".png", ".jpg"].each {|a|
          @gosu_image = Gosu::Image.new(Graphics.gosu_window, width + a, false) rescue next
          break
        }
        raise "File not found" if @gosu_image == nil
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
  
  def gradient_fill_rect(*args)
    case args.size
    when 3, 6
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
        color1 = args[1]
        color2 = args[2]
        vertical = false
      else
        x, y, width, height = *args[0..3]
        color1 = args[4]
        color2 = args[5]
        vertical = false
      end
    when 4, 7
      if args[0].is_a?(Rect)
        x, y, width, height = *args[0].to_a
        color1 = args[1]
        color2 = args[2]
        vertical = args[3]
      else
        x, y, width, height = *args[0..3]
        color1 = args[4]
        color2 = args[5]
        vertical = args[6]
      end
    else
      raise ArgumentError
    end
    red1, green1, blue1, alpha1 = *color1.to_a
    red2, green2, blue2, alpha2 = *color2.to_a
    x_dif = width - x
    y_dif = height - y
    if !vertical
      x_dif.times do |i|
        fill_rect(x + i, y, 1, height, Color.new((red1 - red2) / x_dif * i, (blue1 - blue2) / x_dif * i, (green1 - green2) / x_dif * i))
      end
    else
      y_dif.times do |i|
        fill_rect(x, y + i, width, 1, Color.new((red1 - red2) / y_dif * i, (blue1 - blue2) / y_dif * i, (green1 - green2) / y_dif * i))
      end
    end
  end
  
  def clear
    @gosu_image.insert(ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT), 0, 0)
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
    f = ChunkyPNG::Canvas.new(width, height, ChunkyPNG::Color::TRANSPARENT)
    @gosu_image.insert(f, x, y)
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
  
  def blur
    @chunkypng_image.blur
    @gosu_image.insert(@chunkypng_image, 0, 0)
  end
  
  def radial_blur(angle, division)
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
    if @font.outline
      outline = Gosu::Image.from_text(Graphics.gosu_window, string, @font.first_existant_name, @font.size + 2)
      outline = ChunkyPNG::Canvas.from_gosu(outline)
      outline.each_pixel {|c| 
        color = @font.out_color.dup
        color.alpha = ChunkyPNG::Color.a(c)
        ChunkyPNG::Color.rgba(*color.to_a.collect {|a| a.round })
      }
      outline = Gosu::Image.new(Graphics.gosu_window, outline, false)
      outline.insert(image, 1, 1)
      image = outline
    end
    if @font.shadow
      shadow = Gosu::Image.from_text(Graphics.gosu_window, string, @font.first_existant_name, @font.size + 2)
      shadow = ChunkyPNG::Canvas.from_gosu(shadow)
      shadow.each_pixel {|c| 
        color = ChunkyPNG::Color.rgba(0, 0, 0, 128)
        color.alpha = ChunkyPNG::Color.a(c)
        ChunkyPNG::Color.rgba(*color.to_a.collect {|a| a.round })
      }
      shadow = Gosu::Image.new(Graphics.gosu_window, shadow, false)
      shadow.insert(image, 0, 0)
      image = shadow
    end
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