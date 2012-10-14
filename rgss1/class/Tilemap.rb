class Tilemap
 
  AUTOTILE_UPDATE = 10
 
  INDEX = [
    [ [27, 28, 33, 34], [ 5, 28, 33, 34], [27,  6, 33, 34], [ 5,  6, 33, 34],
      [27, 28, 33, 12], [ 5, 28, 33, 12], [27,  6, 33, 12], [ 5,  6, 33, 12] ],
    [ [27, 28, 11, 34], [ 5, 28, 11, 34], [27,  6, 11, 34], [ 5,  6, 11, 34],
      [27, 28, 11, 12], [ 5, 28, 11, 12], [27,  6, 11, 12], [ 5,  6, 11, 12] ],
    [ [25, 26, 31, 32], [25,  6, 31, 32], [25, 26, 31, 12], [25,  6, 31, 12],
      [15, 16, 21, 22], [15, 16, 21, 12], [15, 16, 11, 22], [15, 16, 11, 12] ],
    [ [29, 30, 35, 36], [29, 30, 11, 36], [ 5, 30, 35, 36], [ 5, 30, 11, 36],
      [39, 40, 45, 46], [ 5, 40, 45, 46], [39,  6, 45, 46], [ 5,  6, 45, 46] ],
    [ [25, 30, 31, 36], [15, 16, 45, 46], [13, 14, 19, 20], [13, 14, 19, 12],
      [17, 18, 23, 24], [17, 18, 11, 24], [41, 42, 47, 48], [ 5, 42, 47, 48] ],
    [ [37, 38, 43, 44], [37,  6, 43, 44], [13, 18, 19, 24], [13, 14, 43, 44],
      [37, 42, 43, 48], [17, 18, 47, 48], [13, 18, 43, 48], [ 1,  2,  7,  8] ]
  ]
 
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :tileset
  attr_accessor :autotiles
  attr_accessor :priorities
  attr_accessor :map_data
 
  def initialize(viewport)
    @viewport = viewport
    @swidth = (@viewport.rect.width / 32)
    @sheight = (@viewport.rect.height / 32)
    @data = nil
    @data_priorities = nil
    @priorities = nil
    @map_data = nil
    @tileset = nil
    @autotiles = []
    @sprites = {}
    @bitmaps = {}
    @cache = {}
    @need_counters = []
    @counter = []
    @max_counters = []
    @ox = 0
    @oy = 0
    @time_counter = 1
    @need_refresh = false
  end
 
  def refresh
    @need_refresh = false
    @table = Table.new(384)
    @size = 0
    @data = @map_data
    @data_priorities = @priorities
    min_x = [@ox / 32 - 1, 0].max
    min_y = [@oy / 32 - 1, 0].max
    max_x = [min_x + @swidth + 1 * 2, @data.xsize - 1].min
    max_y = [min_y + @sheight + 1 * 2, @data.ysize - 1].min
    (min_x..max_x).each {|x|
      (min_y..max_y).each {|y|
        (0..2).each {|z|
          tile_id = @data[x, y, z]
          next if tile_id == 0
          priority = @priorities[tile_id]
          key = [x, y, z, priority]
          @sprites[key] = Sprite.new(@viewport)
          @sprites[key].x = x * 32 - @ox
          @sprites[key].y = y * 32 - @oy
          @sprites[key].z = (y * 32 - @oy) + ((priority + 1) * 32)
          if tile_id < 384
            tile = get_autotile(tile_id)
          else
            tile = get_tile(tile_id)
          end
          @sprites[key].bitmap = tile
        }
      }
    }
  end
 
  def get_autotile(tile_id)
    if tile_id >= 384
      return get_tile(tile_id)
    end
    autotile = @autotiles[(tile_id/48) - 1]
    n = (autotile.width / 96)
    if @bitmaps[tile_id].nil?
      @bitmaps[tile_id] = []
    end
    if n > 1
      if @table[tile_id] == 0
        @counter[tile_id] = 0
        @max_counters[tile_id] = n
        @table[tile_id] = 1
        @size += 1
      end
    end
    for i in 0...n
      @bitmaps[tile_id][i] = get_tile(tile_id, i)
    end
    if @counter[tile_id].nil?
      return @bitmaps[tile_id][0]
    end
    return @bitmaps[tile_id][@counter[tile_id]]
  end
 
  def get_tile(tile_id, c=0)
    key = [tile_id, c]
    if @cache[key].nil?
      @cache[key] = Bitmap.new(32, 32)
      if tile_id < 384
        anim = c * 96
        id = tile_id % 48
        tiles = INDEX[id >> 3][id % 8]
        autotile = @autotiles[(tile_id/48) - 1]
        for i in 0...4
          tile_position = tiles[i] - 1
          rect = Rect.new(tile_position % 6 * 16 + anim, tile_position / 6 * 16, 16, 16)
          @cache[key].blt((i%2) * 16, (i/2) * 16, autotile, rect)
        end
      else
        @cache[key].blt(0, 0, @tileset, Rect.new((tile_id - 384) % 8 * 32, (tile_id - 384) / 8 * 32, 32, 32))
      end
    end
    return @cache[key]
  end
 
  def tileset=(valor)
    for v in @cache.values
      v.dispose
    end
    @cache = {}
    @tileset = valor
    @need_refresh = true
  end
 
  def dispose
    @cache.values.each {|v| v.dispose }
    @cache = {}
    @bitmaps.values.each {|a|
      next if a.nil?
      a.each {|v|
        next if v.nil?
        v.dispose unless v.disposed?
      }
    }
    @sprites.values.each {|sprite|
      next if sprite.nil?
      sprite.dispose
    }
    @sprites = {}
  end
 
  def update
    if @data != @map_data or @priorities != @data_priorities or @need_refresh
      refresh
      return
    end
    min_x = [@ox / 32 - 1, 0].max
    min_y = [@oy / 32 - 1, 0].max
    max_x = [min_x + @swidth + 1 * 2, @data.xsize - 1].min
    max_y = [min_y + @sheight + 1 * 2, @data.ysize - 1].min
    if AUTOTILE_UPDATE > 0
      @time_counter = (@time_counter + 1) % AUTOTILE_UPDATE
    end
    checked = []
    for x in min_x..max_x
      rx = ((x * 32) - @ox)
      cx = (rx < 0 or rx > (@swidth - 32))
      ax = (((rx + 32) < 0) or (rx > @viewport.rect.width))
      for y in min_y..max_y
        ry = ((y * 32) - @oy)
        cy = (ry < 0 or ry > (@sheight - 32))
        ay = (((ry + 32) < 0) or (ry > @viewport.rect.height))
        for z in 0..2
          tile_id = @data[x, y, z]
          next if tile_id == 0
          priority = @priorities[tile_id]
          key = [x, y, z, priority]
          if ay or ax
            if @sprites[key] != nil
              @sprites[key].dispose
              @sprites[key] = nil
            end
            next
          end
          if @sprites[key].nil?
            @sprites[key] = Sprite.new(@viewport)
            @sprites[key].x = rx
            @sprites[key].y = ry
            @sprites[key].z = ry + ((priority + 1) * 32)
            if tile_id < 384
              tile = get_autotile(tile_id)
            else
              tile = get_tile(tile_id)
            end
            @sprites[key].bitmap = tile
            next
          end
          if @changed_ox or cy
            if @sprites[key].x != rx
              @sprites[key].x = rx
            end
          end
          if @changed_oy or cx
            if @sprites[key].y != ry
              @sprites[key].y = ry
              @sprites[key].z = ry + ((priority + 1) * 32)
            end
          end
          next if (@time_counter != 0)
          if @table[tile_id] == 1
            if checked[tile_id] != true
              @counter[tile_id] = (@counter[tile_id] + 1) % @max_counters[tile_id]
              checked[tile_id] = true
            end
            @sprites[key].bitmap = @bitmaps[tile_id][@counter[tile_id]]
          end
        end
      end
    end
    if @changed_ox
      @changed_ox = false
    end
    if @changed_oy
      @changed_oy = false
    end
  end
 
  def ox=(valor)
    return if @ox == valor
    @ox = valor
    @changed_ox = true
  end
 
  def oy=(valor)
    return if @oy == valor
    @oy = valor
    @changed_oy = true
  end
end