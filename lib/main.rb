require_relative 'game'
require_relative 'player'

def start_game
  Game.new(Player.new)
  puts "Do you want to play again?\n(Y/n)"
  reply = gets.chomp[0]
  reply.downcase == "y" ? start_game : puts("Thanks for playing! I hope see you later")
end

start_game