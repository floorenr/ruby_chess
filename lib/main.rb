# frozen_string_literal: true

require_relative 'game'
require 'tty-prompt'
require 'yaml'
require 'colorize'

# Global variable used to make tty-prompt functionality available in all files,
# but won't be included when saving a game with a serialization of 'game'.
$prompt = TTY::Prompt.new

def new_game
  game = Game.new
  game.new_game
end

def saved_game
  games = Dir['./saved_games/*'].map! { |x| x[14..-5] }
  if games.empty?
    puts 'No saved games available, new game started'.red
    return new_game
  end
  chosen_game = $prompt.select('Choose a game:', games)
  game = YAML.load_file("./saved_games/#{chosen_game}.yml")
  game.game_loop
end

puts "
╔═╗┬ ┬┌─┐┌─┐┌─┐
║  ├─┤├┤ └─┐└─┐
╚═╝┴ ┴└─┘└─┘└─┘

"
game_choice = $prompt.select('Choose your game?', ['New Game', 'Saved Game'])

game_choice == 'Saved Game' ? saved_game : new_game
