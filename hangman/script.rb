## all related to the clas player, instances and data
class Player
  attr_accessor :name, :word, :letters_played, :guesses, :winning

  def initialize(name, word_to_guess)
    @name = name
    @word = Array.new(word_to_guess.length, '_')
    @letters_played = []
    @guesses = 6
    @word_to_guess = word_to_guess.split('')
    @winning = false
  end

  def win
    @winning = true
    puts "#{@name} wins!"
  end

  def select_letter
    puts 'select your letter'
    gets.chomp.downcase
  end

  def check_letter_alphabet(letter)
    letter.match?(/[A-Za-z]/)
  end

  def check_length(letter)
    letter.length == 1
  end

  def letter_not_played(letter)
    @letters_played.none?(letter)
  end

  def check_valid_letter
    letter = select_letter
    until letter_not_played(letter) && check_length(letter) && check_letter_alphabet(letter)
      puts 'Select a letter that has not been played!' unless letter_not_played(letter)
      puts 'Select only a letter!' unless check_length(letter)
      puts 'Select a letter from the alphabet!' unless check_letter_alphabet(letter)
      letter = select_letter
    end
    letter
  end

  def guess
    letter = check_valid_letter
    @word_to_guess.each_index do |index|
      @word[index] = @word_to_guess[index] if @word_to_guess[index] == letter
    end
    letters_played.push(letter)
    @guesses -= 1 unless @word_to_guess.include?(letter)
  end

  def display_word
    puts @word.join('')
  end

  def display_letters_played
    puts "You have played the letters (#{@letters_played.join(' , ')})"
  end

  def check_win
    win if @word.join('') == @word_to_guess.join('')
  end
end

def select_word
  dictionary = File.new('google-10000-english-no-swears.txt').read.split("\n")
  dictionary_filtered = dictionary.map { |element| element if element.length >= 5 && element.length <= 12 }.compact
  dictionary_filtered.sample
end

def user_name
  puts 'select your username!'
  gets.chomp
end

def play_round(player)
  player.guess
  player.display_word
  player.display_letters_played unless player.winning
  puts "#{player.name} loose!" if player.guesses.zero?
end

def save_game(game)
  Dir.mkdir('games') unless Dir.exist?('games')
  puts 'select the name to save your game!'
  filename = "games/#{gets.chomp}.msg"
  File.open(filename, 'w') do |file|
    file.puts Marshal.dump(game)
  end
end

def deserialized(file)
  file_serialized = File.open(file)
  Marshal.load(file_serialized)
end

def save_game?(player)
  return if player.winning || player.guesses.zero?

  puts 'Save game?'
  answer = %w[yes no]
  saving = gets.chomp.downcase
  until answer.include?(saving)
    puts 'Please, type yes or no!'
    saving = gets.chomp.downcase
  end
  true if saving == 'yes'
end

def name_of_game
  puts 'type a name to load your game'
  "games/#{gets.chomp}.msg"
end

def turn(user)
  return if user.winning

  until user.guesses.zero? || user.winning
    play_round(user)
    user.check_win
    save_game(user) if save_game?(user)
  end
end

def load_game?
  puts 'Do you want to load a game?'
  loading = gets.chomp.downcase
  answer = %w[yes no]
  until answer.include?(loading)
    puts 'Please, type yes or no!'
    loading = gets.chomp.downcase
  end
  true if loading == 'yes'
end

if load_game?
  game_file = name_of_game
  until File.exist?(game_file)
    puts 'select a existing file!'
    game_file = name_of_game
  end
  player = deserialized(game_file)
  puts "Game loaded! \n #{player.display_word} \n #{player.display_letters_played}"
else
  player = Player.new(user_name, select_word)
end
turn(player)
