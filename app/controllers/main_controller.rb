
class MainController < ApplicationController


  def test
    require 'game_core.rb'
    core = GameCore::get_core
    puts '----------------------------'
    puts core.current_session.inspect
    puts '----------------------------'
    #return
  end

  def start
    Card::start_game
    Card::give_cards_set
    Card::get_player_cards(1)
    Card::get_player_cards(2)
    Card::get_trump_card
    redirect_to :action => :index
  end

  def index

    @cards_set = Card::give_cards_set
    @cards = Card::get_player_cards(1)
    @second_player_cards = Card::get_player_cards(2)
    @trump_card = Card::get_trump_card
    @cards_on_table = Card::get_cards_on_table

    @player = Card::get_next_player
    puts "!!"*30
    puts @player.inspect
    puts "!!"*30
    if @player == 1
      if not @cards_on_table.empty?
        if Card::player_has_cards_to_add?(@player)
          redirect_to :action => :next_player_move
        else
          redirect_to :action => :make_clear
        end
      end
    end

  end

  def sort_cards
    if @cards_on_table.empty?
      Card::sort_player_cards(1)
      Card::sort_player_cards(2)
    end
  end

  def next_player_move
    player = Card::get_next_player
    Card::push_card_on_table(player)
    redirect_to :action => :index
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
