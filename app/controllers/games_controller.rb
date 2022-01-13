require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a
    @selection = @letters.sample(10)
    session[:score]
  end

  def eng_word
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def letter_in_grid
    @answer.chars.sort.all? { |letter| @grid.include?(letter) }
  end

  def score
    @answer = params[:word]
    @grid = params[:grid]
    grid_letters = @grid.each_char { |letter| print letter, ''}

    if !letter_in_grid
      @result = "Sorry, but <b>#{@answer.upcase}</b> can't be built out of #{grid_letters.upcase}.".html_safe
    elsif letter_in_grid == true && eng_word == true
      @result = "Congrats <b>#{@answer.upcase}</b> is a word.".html_safe
      session[:score] += 1
    elsif letter_in_grid == true && eng_word == false
      @result = "<b>#{@answer.upcase}</b> is on the grid but isn't an English word.".html_safe
    end
  end
end
