module Input

  @keys, @gosu_keys = [], []
  
  DOWN = [Gosu::KbDown]
  UP = [Gosu::KbUp]
  LEFT = [Gosu::KbLeft]
  RIGHT = [Gosu::KbRight]
  A = [Gosu::KbLeftShift, Gosu::KbRightShift]
  B = [Gosu::KbX, Gosu::KbEscape, Gosu::Kb0]
  C = [Gosu::KbReturn, Gosu::KbSpace, Gosu::KbZ]
  X = [Gosu::KbA]
  Y = [Gosu::KbS]
  Z = [Gosu::KbD]
  L = [Gosu::KbQ]
  R = [Gosu::KbW]
  SHIFT = [Gosu::KbLeftShift, Gosu::KbRightShift]
  CTRL = [Gosu::KbLeftControl, Gosu::KbRightControl]
  ALT = [Gosu::KbLeftAlt, Gosu::KbRightAlt]
  F5 = [Gosu::KbF5]
  F6 = [Gosu::KbF6]
  F7 = [Gosu::KbF7]
  F8 = [Gosu::KbF8]
  F9 = [Gosu::KbF9]
  
  module_function
  
  def update
    @keys = @gosu_keys.dup
    @gosu_keys.clear
  end
  
  def trigger?(key)
    return key.any? {|a| @keys.include?(a) }
  end
  
  def press?(key)
    return key.any? {|a| Graphics.gosu_window.button_down?(a) }
  end
  
  def repeat?(key)
  end
  
  def dir4
    return 2 if press?(:DOWN)
    return 4 if press?(:LEFT)
    return 6 if press?(:RIGHT)
    return 8 if press?(:UP)
    return 0
  end
  
  def dir8
    return 1 if press?(:DOWN) && press?(:LEFT)
    return 3 if press?(:DOWN) && press?(:RIGHT)
    return 7 if press?(:UP) && press?(:LEFT)
    return 9 if press?(:UP) && press?(:RIGHT)
    return dir4
  end
  
  # NEW
  
  def add_key(key)
    @gosu_keys << key
  end
  
  def gosu_trigger?(key)
    key = Gosu::Button.const_get("Kb#{key.to_s.capitalize}")
    return @keys.include?(key)
  end
  
  def gosu_press?(key)
    key = Gosu::Button.const_get("Kb#{key.to_s.capitalize}")
    return Graphics.gosu_window.button_down?(a)
    return false
  end
  
  def gosu_repeat?(key)
  end
end