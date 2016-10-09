# 1. Load dictionary and choose word between 5-12 characters at random.
# 2. Display _ _ _ for number of charaters in the word.
# 3. Allow the player to make a guess of a letter.
# 4. Update the display to reflect whether the letter was correct or incorrect.
# 5. Add the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game. Serialize your game class.
# 6. When the program first loads, add in an option that allows you to open one of your saved games.

# Classes?
# - Player
# - Guess
# - Game
# - Word
# - Missed (letters)
# - Hangman
# - Correct (letters)

class Player
  def initialize
    # @name = name
  end

  def guess
    # should guess be a class?
  end
end

class Word
  # Load dictionary and choose a word
  def random
    contents = File.open('5desk.txt', 'r').read
    p contents.split()
  end
end

class Game
  def initialize
    @word = Word.new.random
  end

  def display_welcome_message
  end

  def display_hangman
  end

  def display_correct_letters
  end

  def display_missed_letters
  end

  def start
    # steps to play the game
  end
end

Game.new
