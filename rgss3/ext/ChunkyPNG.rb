module ChunkyPNG
	class Canvas
		
		alias columns width
		alias rows height
		
		def to_blob
			pixels.pack('N*')
		end
		
		def set_opacity(diff)
			width.times {|i|
				f = column(i)
				f.each_with_index {|a, b|
					f[b] = Color.fade(a, diff)
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