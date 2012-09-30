class Rect
	
	attr_accessor :x, :y, :width, :height
	
	def initialize(*args)
		case args.size
		when 0
			set(0, 0, 0, 0)
		when 4
			set(*args)
		else
			raise ArgumentError
		end
	end
	
	def set(*args)
		case args.size
		when 1
			if args[0].is_a?(Rect)
				re = args[0]
				set(re.x, re.y, re.width, re.height)
			else
				raise ArgumentError
			end
		when 4
			@x, @y, @width, @height = *args
		else
			raise ArgumentError
		end
	end
	
	def empty
		set(0, 0, 0, 0)
	end
end