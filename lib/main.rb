require_relative 'game'
require_relative 'board'
require "tty-prompt"

def new_game
  game = Game.new
  game.game_loop
end

def saved_game

end

puts "
╔═╗┬ ┬┌─┐┌─┐┌─┐
║  ├─┤├┤ └─┐└─┐
╚═╝┴ ┴└─┘└─┘└─┘

"
prompt = TTY::Prompt.new
game_choice = prompt.select("Choose your game?", ["New Game", "Saved Game"])

game_choice == "Saved Game"? saved_game : new_game
