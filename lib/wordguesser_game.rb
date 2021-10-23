class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  attr_accessor :count
  attr_accessor :check_win_or_lose
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @count = 0
    @word_with_guesses = ''
    word.chars do |letter|
      @word_with_guesses.insert(0, '-')
    end
    @check_win_or_lose = :play
  end

  def letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end

  def guess(word)
    if word.nil?
      raise ArgumentError
    end
    if word.empty?
      raise ArgumentError
    end
    if not letter?(word)
      raise ArgumentError
    end
    word = word.downcase
    if @guesses.include?word or @wrong_guesses.include?word
      return false
    else
      if @word.include?word
        @guesses.insert(0, word)
        i = 0
        @word.chars do |letter|
          if @word[i] == word
            @word_with_guesses[i] = word
          end
          i+=1
        end
        if not @word_with_guesses.include?'-'
          @check_win_or_lose = :win
        end
      else
        @count += 1
        @wrong_guesses.insert(0, word)
      end
      if @count == 7 and @word_with_guesses.include?'-'
        @check_win_or_lose = :lose
      end
      return true
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
