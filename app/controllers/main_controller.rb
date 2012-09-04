
class MainController < ApplicationController

	before_filter :init

  def asd    
    a = [1,2,3 ]
    b = [1,4,5]
    a = a | b
    puts "*"*50
    puts a.inspect
    puts "*"*50
    return
  end

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

  def make_mine
    current_player = $game_flow.core.get_current_player
    current_player.make_mine($game_flow.core.cards_on_table)
    $game_flow.core.cards_on_table = []
    redirect_to :action => :index
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
