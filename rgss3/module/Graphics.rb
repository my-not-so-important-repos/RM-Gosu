module Graphics

	class << self
		
		attr_accessor :frame_count, :gosu_window
		attr_reader :brightness, :frame_rate
		
		def brightness=(int)
			@brightness = [[255, int].min, 0].max
		end
		
		def frame_rate=(int)
			@frame_rate = [[120, int].min, 10].max
			reform_window(width, height, fullscreen?, 1.0 / @frame_rate * 1000)
		end
	end
	
	@frame_rate = 60
	@brightness = 255
	@frame_count = 0
	@@gosu_sprites = []

	module_function
	
	def update
	end
	
	def wait(duration)
	end
	
	def fadeout(duration)
	end
	
	def fadein(duration)
	end
	
	def freeze
	end
	
	def transition(duration = 10, filename = "", vague = 40)
	end
	
	def snap_to_bitmap
	end
	
	def frame_reset
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
	
	def play_movie(filename)
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