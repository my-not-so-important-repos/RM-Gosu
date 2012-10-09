class Font
  
  class << self
    
    attr_accessor :default_name, :default_size, :default_bold
    attr_accessor :default_italic
    attr_accessor :default_color
    
    def exist?(name)
      f = (Gosu::Font.new(Graphics.gosu_window, "./Fonts/#{name}.ttf", 8) rescue false)
      Gosu::Font.new(Graphics.gosu_window, name, 8) unless f
      return true
    rescue
      return false
    end
  end
  
  self.default_name = ["MS PGothic"]
  self.default_size = 24
  self.default_bold = false
  self.default_italic = false
  self.default_color = Color.new(255, 255, 255, 255)
  
  attr_accessor :name, :size, :bold, :italic, :color
  
  def initialize(name = Font.default_name, size = Font.default_size)
    @name = name.dup
    @size = size
    @bold = Font.default_bold
    @italic = Font.default_italic
    @color = Font.default_color.dup
  end
  
  # NEW
  
  def first_existant_name
    if @name.is_a?(Array)
      @name.each {|a| return a if Font.exist?(a) }
    else
      return @name if Font.exist?(@name)
    end
    return "Verdana"
  end
end