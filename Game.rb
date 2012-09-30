require 'gosu'
require 'zlib'

Dir["rgss3/**/*.*"].each {|a| require_relative(a) }

class GosuGame < Gosu::Window
	
	CONFIG = {
		:RTP => "RPGVXAce",
		:Title => "Game",
		:Width => 544,
		:Height => 416,
		:Fullscreen => false,
		:Windows => true
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
	
	def initialize(width = CONFIG[:Width], height = CONFIG[:Height], fullscreen = CONFIG[:Fullscreen])
		super(width, height, fullscreen)
		self.caption = CONFIG[:Title]
	end
	
	def update
		Input.update
	end
	
	def draw
		Graphics.latest
	end
	
	def button_down(id)
		Input.add_key(id)
	end
end

Dir["Data/**/*.*"].each {|a| load_file(a); p a }
Graphics.gosu_window = GosuGame.new
Graphics.gosu_window.show