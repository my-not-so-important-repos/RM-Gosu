class Table
	
	 attr_accessor :xsize, :ysize, :zsize, :data
	
	def initialize(x, y = 0, z = 0)
		@dim = 1 + (y > 0 ? 1 : 0) + (z > 0 ? 1 : 0)
		@xsize, @ysize, @zsize = x, [y, 1].max, [z, 1].max
		@data = Array.new(x * y * z, 0)
	end
	
	def resize(xsize, ysize = nil, zsize = nil)
	end
	 
  def [](x, y = 0, z = 0)
		@data[x + y * @xsize + z * @xsize * @ysize]
	end
	 
  def []=(*args)
		x = args[0]
		y = args.size > 2 ? args[1] : 0
		z = args.size > 3 ? args[2] : 0
		v = args.pop
		@data[x + y * @xsize + z * @xsize * @ysize] = v
	end
	 
  def _dump(d = 0)
		[@dim, @xsize, @ysize, @zsize, @xsize * @ysize * @zsize].pack('LLLLL') << @data.pack("S#{@xsize * @ysize * @zsize}")
	end
	 
  def self._load(s)
		size, nx, ny, nz, items = *s[0, 20].unpack('LLLLL')
		t = Table.new(*[nx, ny, nz][0,size])
		t.data = s[20, items * 2].unpack("S#{items}")
		t
	end
end