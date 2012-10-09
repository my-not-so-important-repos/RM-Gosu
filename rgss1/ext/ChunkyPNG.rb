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
    
    def blur
      height.times {|h|
        width.times {|w|
          pix = self[w, h]
          pix2 = self[w - 1, h] if include_x?(w - 1)
          pix3 = self[w, h - 1] if include_y?(h - 1)
          self[w, h] = Color.interpolate_quick(Color.interpolate_quick(pix, pix2 || 0, 128), pix3 || 0, 128)
        }
      }
      height.times {|h|
        h = height - h - 1
        width.times {|w|
          pix = self[w, h]
          pix2 = self[w + 1, h] if include_x?(w + 1)
          pix3 = self[w, h + 1] if include_y?(h + 1)
          self[w, h] = Color.interpolate_quick(Color.interpolate_quick(pix, pix2 || 0, 128), pix3 || 0, 128)
        }
      }
    end
    
    def gaussian_blur
      height.times {|h|
        width.times {|w|
          pixels = []
          if include_xy?(w - 1, h - 1)
            pixels << self[w - 1, h - 1]
          else
            pixels << (self[w - 1, h] rescue self[w, h])
          end
          #
          if include_xy?(w, h - 1)
            pixels << self[w, h - 1]
          else
            pixels << self[w, h]
          end
          #
          if include_xy?(w + 1, h - 1)
            pixels << self[w + 1, h - 1]
          else
            pixels << (self[w + 1, h] rescue self[w, h])
          end
          #
          if include_xy?(w - 1, h)
            pixels << self[w - 1, h]
          else
            pixels << self[w, h]
          end
          #
          if include_xy?(w + 1, h)
            pixels << self[w + 1, h ]
          else
            pixels << self[w, h]
          end
          #
          if include_xy?(w - 1, h + 1)
            pixels << self[w - 1, h + 1]
          else
            pixels << (self[w - 1, h] rescue self[w, h])
          end
          #
          if include_xy?(w, h + 1)
            pixels << self[w, h + 1]
          else
            pixels << self[w, h]
          end
          #
          if include_xy?(w + 1, h + 1)
            pixels << self[w + 1, h + 1]
          else
            pixels << (self[w + 1, h] rescue self[w, h])
          end
          col = self[w, h]
          pixels.each {|c|
            col = Color.interpolate_quick(col, c, 128)
          }
          self[w, h] = col
        }
      }
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