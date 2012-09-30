module ChunkyPNG
	class Canvas
		
		alias columns width
		alias rows height
		
		def to_blob
			pixels.pack('N*')
		end
		
		def self.from_gosu(image)
			from_rgba_stream(image.width, image.height, image.to_blob)
		end
	end
end