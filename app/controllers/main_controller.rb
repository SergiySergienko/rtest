
class MainController < ApplicationController

	before_filter :init

  def asd    
    a = $game_flow
    puts "!"*50
    puts a.inspect
    a.make_action(params)
  end

  def index
  	game = $game_flow  	
    game.make_action(params)
    # Get current state of game
  	@cards_on_table = game.core.cards_on_table
  	@players = game.core.players
  	@cards_set = game.core.cards_set
  	@current_player = game.core.get_current_player
  	@first_player_cards = game.core.players.first.get_player_cards
  	@second_player_cards = game.core.players.last.get_player_cards
  	# END Get current state of game
  end

  def dsa
  	$game_flow.core.end_game
  	redirect_to :action => :asd
  end

  private

  def init
  	if $game_flow.nil?
  		$game_flow = GameFlow.new
  	end
  end

end
