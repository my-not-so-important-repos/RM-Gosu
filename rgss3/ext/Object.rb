class Object
	
	def rgss_main(&block)
	end
	
	def rgss_stop
		loop { Graphics.update }
	end
	
	def load_file(filename)
		File.open(filename, "rb") { |f|
			Marshal.load(f)
		}
	end
	
	def save_file(obj, filename)
		File.open(filename, "wb") { |f|
			Marshal.dump(obj, f)
		}
	end
	
	def msgbox(*args)
	end
	
	def msgbox_p(*args)
	end
end