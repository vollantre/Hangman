require 'yaml'

class Game
  attr_reader :stub
  def initialize(player)
    @secret_word = get_random_word
    @stub        = generate_stub
    @attempts    = 15
    @player      = player
    start
  end
  
  def to_yaml
    YAML.dump({
              :secret_word => @secret_word,
              :stub => @stub,
              :attempts => @attempts,
              :player_name => @player.name
             })
  end
  
  def load_game(string)
    data = YAML.load(string)
    @secret_word = data[:secret_word]
    @stub = data[:stub]
    @attempts = data[:attempts]
    @player.name = data[:player_name]
    puts "Game loaded"
  end

  private
  def reveal_guessed_chars(letter)
    if @secret_word.match(letter)
      @secret_word.downcase.each_char.with_index do |char, idx|
        @stub[idx] = @secret_word[idx] if char == letter
      end
    else
      decreases_attempts
    end
  end

  def save_game(filename)
    Dir.mkdir("saved_games") unless Dir.exist?("saved_games")
    File.open("saved_games/#{filename}.yaml","w") do |file|
      file.puts self.to_yaml
    end
    puts "Game saved"
  end

  def ask_for_filename_saving
    puts "Enter a name for your new file"
    filename = gets.chomp
    if File.exists?("saved_games/#{filename}.yaml")
      puts "A file with that name already exists, wanna save anyways?(Y/n)\n(NOTE: The actual file will be overwritten)"
      reply = gets.chomp.downcase[0]
      save_game(filename) if reply == "y"
    else
      save_game(filename)
    end
  end

  def ask_for_saving_game
    puts "Do you want to save this game?(Y/n)"
    reply = gets.chomp.downcase[0]
    ask_for_filename_saving if reply == "y"
  end

  def ask_for_loading_game
    puts "Before you start playing do you want to load a existent game?(Y/n)"
    reply = gets.chomp.downcase[0]
    if reply == "y"
      puts "Enter the game filename"
      filename = gets.chomp
      File.exist?("saved_games/#{filename}.yaml") ? load_game(File.read("saved_games/#{filename}.yaml")) : game_doesnt_exist
    end
  end

  def game_doesnt_exist(filename)
    puts("The file: #{filename} doesn't exists")
    ask_for_loading_game
  end

  def finished?
    @secret_word == @stub || @attempts.zero?
  end

  def win_or_lose
    return "You got it! the secret word was \"#{@secret_word}\"" if @secret_word == @stub
    return "Oh i see you couldn't guess the secret word, but it was \"#{@secret_word}\"" if @attempts.zero?
  end
  
  def start
    ask_for_loading_game
    puts "The secret word has been generated"
    puts "NOTE: if you put more than one letter, only the first letter will be taken"
    until finished?
      puts @stub
      loop_rounds
      ask_for_saving_game if @attempts == 10 || @attempts == 5
    end
    puts win_or_lose
  end
  
  def loop_rounds
    letter = @player.get_letter until letter
    reveal_guessed_chars(letter)
  end

  def generate_stub
    stub = ""
    @secret_word.each_char{|_| stub += "_"}
    stub
  end

  def decreases_attempts
    @attempts -= 1
    puts("#{@attempts} attempts left") unless @attempts.zero?
  end
  
  def get_random_word
    File.readlines("5desk.txt").select do |word| 
      word.chomp!.length.between?(5, 12)
    end.sample
  end
end
