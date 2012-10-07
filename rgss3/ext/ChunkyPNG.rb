module ChunkyPNG
  class Canvas
    
    alias columns width
    alias rows height
    
    def to_blob
      pixels.pack('N*')
    end
    
    def set_opacity(diff)
      each_pixel {|a|
        Color.fade(a, diff)
      }
    end
    
    def hue_change(hue)
      each_pixel {|a| 
        col = Gosu::Color.rgba(*Color.from_int(a))
        col.hue = hue
        Color.rgba(col.red, col.green, col.blue, col.alpha)
      }
    end
    
    def each_pixel(&block)
      width.times {|i|
        f = column(i)
        f.each_with_index {|a, b|
          f[b] = block.call(a)
        }
        replace_column!(i, f)
      }
    end
    
    def self.from_gosu(image)
      from_rgba_stream(image.width, image.height, image.to_blob)
    end
  end
  
  module Color
    
    def self.from_int(int)
      red = r(int)
      green = g(int)
      blue = b(int)
      alpha = a(int)
      [red, green, blue, alpha]
    end
  end
end