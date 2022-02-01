# frozen_string_literal: true

require_relative 'game'
require 'tty-prompt'
require 'yaml'
require 'colorize'

prompt = TTY::Prompt.new

def new_game
  game = Game.new
  game.game_loop
end

def saved_game(prompt)
  games = Dir["./saved_games/*"].map! {|x| x[14..-5]}
  chosen_game = prompt.select('Choose a game:', games)
  game = YAML.load_file("./saved_games/#{chosen_game}.yml")
  game.game_loop
end

puts "
╔═╗┬ ┬┌─┐┌─┐┌─┐
║  ├─┤├┤ └─┐└─┐
╚═╝┴ ┴└─┘└─┘└─┘

"
game_choice = prompt.select('Choose your game?', ['New Game', 'Saved Game'])

game_choice == 'Saved Game' ? saved_game(prompt) : new_game
