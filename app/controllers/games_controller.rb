require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map do ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if (english_word?(@word)) && (word_in_grid(@word, @letters))
      @result = "Congratulations! #{@word} is a valid english word"
    elsif (english_word?(@word)) && ((word_in_grid(@word, @letters) == false))
      @result = "Sorry but #{@word} cannot be built out of #{@letters}"
    elsif (english_word?(@word) == false) && (word_in_grid(@word, @letters) == false)
      @result = "Sorry but #{@word} doesn't seem to be a valid english word"
    end
  end

  def word_in_grid(attempt, grid)
    attempt_final = attempt.upcase.chars
    attempt_final.all? {|letter| grid.count(letter) >= attempt_final.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end
end
