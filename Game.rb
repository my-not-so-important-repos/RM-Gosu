require 'gosu'
require 'zlib'
require 'oily_png'

Dir["rgss3/**/*.rb"].each {|a| require_relative(a) }

class GosuGame < Gosu::Window
  
  CONFIG = {
    :RTP => "RPGVXAce",
    :Title => "Game",
    :Width => 544,
    :Height => 416,
    :Fullscreen => false,
    :Windows => false,
    :Framerate => 60
  }
  
  File.open('Game.ini', 'r') do |inFile|
    inFile.each_line do |line|
      if line[/(.*)=(\d+)/i]
        CONFIG[$1.to_sym] = $2.to_i
      elsif line[/(.*)=(true|false)/i]
        CONFIG[$1.to_sym] = $2.downcase == "true"
      elsif line[/(.*)=(.*)/i]
        CONFIG[$1.to_sym] = $2
      end
    end
  end
  
  @@show_fps = false
  
  def initialize(width = CONFIG[:Width], height = CONFIG[:Height], fullscreen = CONFIG[:Fullscreen], fps = 1.0 / CONFIG[:Framerate] * 1000)
    super(width, height, fullscreen, fps)
    self.caption = CONFIG[:Title]
  end
  
  def update
    update_fps
  end
  
  def draw
    Graphics.latest
  end
  
  def update_fps
    if @@show_fps
      self.caption = CONFIG[:Title] + " (#{Gosu.fps} FPS)"
    else
      self.caption = CONFIG[:Title]
    end
  end
  
  def button_down(id)
    Input.add_key(id)
    case id
    when Gosu::KbF2
      @@show_fps = !@@show_fps
    end
  end
end

Graphics.gosu_window = GosuGame.new
Graphics.gosu_window.show

Graphics.gosu_window.close