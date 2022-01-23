require_relative 'game'
require_relative 'board'

puts "
╔═╗┬ ┬┌─┐┌─┐┌─┐
║  ├─┤├┤ └─┐└─┐
╚═╝┴ ┴└─┘└─┘└─┘

"

game = Game.new

game.game_loop