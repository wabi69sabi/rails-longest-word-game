class WordGameController < ApplicationController

  def game
    def generate_grid()
        # TODO: generate random grid of letters
        grid_size = rand(5..15)
        grid = []
        grid_size.times do
        letter = [*('A'..'Z')].sample
        grid << letter
      end
      grid
    end
    @grid = generate_grid()
  end

  def score
    @grid = params[:grid]
    @attempt = params[:attempt]
    @time = params[:time].to_f
    @result = run_game(@attempt, @grid, @time)
  end

  def run_game(attempt, grid, time)
    # TODO: runs the game and return detailed hash of result
    result = {}
    translation = translate(attempt.downcase)
    result[:translation] = translation
    result[:time] = time
    message, score = game_conditionals(attempt, grid, translation)
    result[:score] = score ? (1 / result[:time]) + attempt.length : 0
    result[:translation] = nil if attempt == translation
    result[:message] = message
    return result
  end

  def game_conditionals(attempt, grid, translation)
    score = false
    if !(attempt.upcase.chars.all? { |x| grid.count(x) >= attempt.upcase.count(x) })
      message =  "not in the grid"
    elsif attempt == translation
      message =  "not an english word"
    else
      message =  "well done"
      score = true
    end
    return message, score
  end

  def translate(attempt)
    # TODO: translate into french
    key = "a2427b65-0399-46eb-a812-66211c0e90c5"
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{key}&input=#{attempt}"
    translated_word = JSON.parse(open(url).read)
    return translated_word["outputs"][0]["output"]
  end

end
