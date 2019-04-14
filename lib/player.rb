class Player
  attr_accessor :name
  def initialize()
    @name = get_name
  end

  def get_letter
    puts "#{@name.capitalize} put a letter\n"
    reply = gets.chomp[0]
    valid_letter?(reply) ? reply.downcase : puts("Enter a valid letter")
  end
  
  private
  def get_name
    puts "What's your name?"
    name = gets.chomp
  end

  def valid_letter?(letter)
    /[A-Za-z]/ =~ letter
  end
end