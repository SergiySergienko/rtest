
class MainController < ApplicationController

	before_filter :init  

  def index
  	game = $game_flow
    res = game.make_action(params)
    # Get current state of game
  	@cards_on_table = game.core.cards_on_table
    @release = game.core.release
  	@players = game.core.players
  	@cards_set = game.core.cards_set
  	@trump_card = game.core.get_trump_card
  	@current_player = game.core.get_current_player
    @session_player = game.core.get_session_player
  	@first_player_cards = game.core.players.first.get_player_cards
  	@second_player_cards = game.core.players.last.get_player_cards
  	# END Get current state of game
    if res and res.is_a?(Hash)
      puts "/"*150
      puts res.inspect
      puts "/"*150
      redirect_to res
    end
  end 

  private

  def init
  	if $game_flow.nil?
  		$game_flow = GameFlow.new
  	end
  end

end
