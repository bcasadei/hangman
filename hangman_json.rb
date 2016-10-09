# 1. Load dictionary and choose word between 5-12 characters at random.
# 2. Display _ _ _ for number of characters in the word.
# 3. Allow the player to make a guess of a letter.
# 4. Update the display to reflect whether the letter was correct or incorrect.
# 5. Add the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Serialize your game class.
# 6. When the program first loads, add in an option that allows you to open one of your saved games.
require 'json'

class Word
  def random
    contents = File.open('5desk.txt', 'r').read
    array = contents.split.select { |word| word.size > 4 && word.size < 13 }
    array.sample(1).join.downcase
  end
end

class Player
  attr_reader :name

  def initialize
    choose_name
  end

  def choose_name
    loop do
      puts "What's your name?"
      @name = gets.chomp.strip
      break unless name.empty?
      puts "Sorry that's not a valid choice."
    end
  end
end

class Game
  def initialize(word = Word.new.random.chars, player = Player.new, missed_letters = [], correct_letters = [])
    @word = word
    @player = player
    @missed_letters = missed_letters
    @correct_letters = correct_letters
  end

  def display_welcome_message
    puts "\nHi #{@player.name}, Welcome to Hangman!"
    puts "Your word has #{@word.size} letters. Good luck!"
  end

  def start
    display_welcome_message
    display_load_message
    display_word
    loop do
      display_save_message
      player_guess
      clear
      check_guess
      check_score
      display_word
      display_missed_letters
      display_winner if winner?
      break if winner? || loser?
    end
  end

  def clear
    system 'clear'
  end

  def display_word
    result = @word.map do |char|
      if @correct_letters.include?(char)
        char
      else
        '_'
      end
    end
    puts result.join(' ')
  end

  def display_missed_letters
    puts "\nMissed Letters: #{@missed_letters.join(', ')}"
  end

  def check_score
    case @missed_letters.size
    when 1
      puts "Your head is on the hangman's noose!"
    when 2
      puts "Your body is on the hangman's noose!"
    when 3
      puts "Your right arm is on the hangman's noose!"
    when 4
      puts "Your left arm is on the hangman's noose!"
    when 5
      puts "Your right leg is on the hangman's noose!"
    when 6
      puts "Game over! The word was #{@word.join}."
    else
      puts "The hangman is ready for you #{@player.name}!"
    end
  end

  def player_guess
    loop do
      puts "\nChoose a letter!"
      @guess = gets.chomp.downcase
      break unless @guess.empty? || @guess.size > 1 || @guess =~ /[0-9\s]/
      puts "Sorry that's not a valid choice."
    end
  end

  def check_guess
    if @correct_letters.include?(@guess) || @missed_letters.include?(@guess)
      puts "You've already guessed (#{@guess})."
    elsif @word.include?(@guess)
      @word.each do |char|
        @correct_letters << char if char == @guess
      end
      puts 'Correct!'
    else
      @missed_letters << @guess
      puts 'Sorry, that letter is not included.'
    end
  end

  def display_winner
    puts "Congratulations #{@player.name}, you won! You are free to go."
  end

  def winner?
    return true if @correct_letters.size == @word.size
  end

  def loser?
    return true if @missed_letters.size == 6
  end

  def display_save_message
    loop do
      puts 'Would you like to save your game? (y/n)'
      answer = gets.chomp.downcase
      if answer.include?('y')
        save
        break
      elsif answer.include?('n')
        break
      else
        puts "That's an invalid choice please enter (y/n)."
      end
    end
  end

  def save
    # File.open("#{@player.name}.json", 'w') do |file|
    #   file.puts JSON.dump({
    #     :word => @word,
    #     :missed_letters => @missed_letters,
    #     :correct_letters => @correct_letters
    #   })
    # end
    data = {
      :word => @word,
      :player => @player,
      :missed_letters => @missed_letters,
      :correct_letters => @correct_letters
    }

    File.open("#{@player.name}.json", 'w') do |file|
      file.write(data.to_json)
    end

    puts "Your game has been saved."
  end

  def display_load_message
    loop do
      puts "Would you like load your previous game #{@player.name}? (y/n)"
      answer = gets.chomp.downcase
      if answer.include?('y')
        load
        break
      elsif answer.include?('n')
        break
      else
        puts "That's an invalid choice please enter (y/n)."
      end
    end
  end

  def load
    File.open("#{@player.name}.json", 'r') do |file|
      data = JSON.load file
      Game.new(data['word'], data['player'], data['missed_letters'], data['correct_letters'])
    end
  end
end

Game.new.start
