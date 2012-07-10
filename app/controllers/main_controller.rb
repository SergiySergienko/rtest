
class MainController < ApplicationController

  def test
	require 'game_core.rb'
	core = GameCore::get_core	
	puts '----------------------------'
	puts core.current_session.inspect
	puts '----------------------------'
	return
  end

  def index

    Card::start_game
    @cards_set = Card::give_cards_set
    @cards = Card::get_player_cards(1)
    @second_player_cards = Card::get_player_cards(2)
    @trump_card = Card::get_trump_card

    @cards_on_table = Card::get_cards_on_table

    if @cards_on_table.empty?
      Card::sort_player_cards(1)
      Card::sort_player_cards(2)
      Card::push_card_on_table(1)
    end
    @cards_on_table = Card::get_cards_on_table
  end

  def do_answer
    card = Card.find(params[:card_id])
    Card::push_card_on_table(2, card.id)
    redirect_to :controller => :main, :action => :index
  end

  def make_clear
    Card::make_clear
    redirect_to :controller => :main, :action => :index
  end

  def make_mine
    player = 2
    Card::make_mine(player)
    redirect_to :controller => :main, :action => :index
  end

end
