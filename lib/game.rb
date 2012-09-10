#!/usr/bin/env ruby.exe

require "rubygems"
require "highline/import"

# Load the rails application
require File.expand_path('../../config/application', __FILE__)

# Initialize the rails application
Game::Application.initialize!

require 'singleton'

#
# Emulate MainConrtoller using Singleton pattern
#
class GameController
  attr_accessor :cards_on_table, :release, :players, :cards_set, :trump_card, :current_player, :session_player, :first_player_cards, :second_player_cards, :game_flow
  include Singleton

  def initialize
    self.game_flow = GameFlow.new
  end

  def make_action(params)
    system("cls")
    res = self.game_flow.make_action(params)
    # Get current state of game
    self.cards_on_table = self.game_flow.core.cards_on_table
    self.release = self.game_flow.core.release
    self.players = self.game_flow.core.players
    self.cards_set = self.game_flow.core.cards_set
    self.trump_card = self.game_flow.core.get_trump_card
    self.current_player = self.game_flow.core.get_current_player
    self.session_player = self.game_flow.core.get_session_player
    self.first_player_cards = self.game_flow.core.players.first.get_player_cards
    self.second_player_cards = self.game_flow.core.players.last.get_player_cards
  end

end

#------------------------- Game section ---------------------

if GameController.instance.game_flow.core.game_is_started == true

  params = {:controller => :main, :action => :index}
  GameController.instance.make_action(params)

  while GameController.instance.game_flow.core.game_is_started == true
    params = {:controller => :main, :action => :index}

    puts "Current player: " + GameController.instance.current_player.player_name
    puts "Trump card: " + GameController.instance.trump_card.name + "(" + GameController.instance.trump_card.card_type.name + ")"
    puts "First player cards:"
    GameController.instance.first_player_cards.each do |card|
     puts card.name + "(" + card.card_type.name + ")"
    end

    puts "-"*50
    puts "Table:"
    GameController.instance.cards_on_table.each do |card|
     puts card.name + "(" + card.card_type.name + ")"
    end
    puts "-"*50

    puts "Second player cards:"
    GameController.instance.second_player_cards.each do |card|
     puts card.name + "(" + card.card_type.name + ")"
    end

    if GameController.instance.current_player.player_name == 'Player2'

      puts "-"*50    
      choices = {"Push card" => "1","Make mine" => "2","Make clear" => "3"}
      u_cards = []
      u_card_ids = []
      i = 0
      GameController.instance.second_player_cards.each do |card|
       u_cards[i] = card.name + "(" + card.card_type.name + ")"
       u_card_ids[i] = card.id
       i=i+1
      end

      choose do |menu|
        menu.prompt = "Choose your action "
        menu.index = :letter

        menu.choice "Push card" do
          params = {:action => :index, :op => :push_card } 
          choose do |sub_menu|
            sub_menu.index = :letter
            sub_menu.index_suffix = ") "

            sub_menu.prompt = "Please select card to push "
            
            u_cards.each do |ch|
              sub_menu.choice ch do 
                ind = u_cards.index(ch)
                params[:cid] = u_card_ids[ind]
              end
            end

          end          
        end
        menu.choice "Make mine" do 
          params = {:action => :index, :op => :mine }
        end
        menu.choice "Make clear" do 
          params = {:action => :index, :op => :clear } 
        end

      end      

    end

    GameController.instance.make_action(params)
  
  end

else
  puts "Game ended"
end

#
# End game section
#