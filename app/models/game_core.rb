require 'observer'
class GameCore
  
  include Observable

  attr_accessor :session_player, :current_player, :players, :game_is_started, :cards_on_table, :cards_set, :input_params, :trump_card, :release
	
  #
  # class constructor
  #
  def initialize
		self.start_game
		if self.players.nil?
      
      self.players = []
      self.cards_on_table = []
      self.release = []
      self.cards_set = Card.find(:all)
      self.cards_set.shuffle!
      self.get_trump_card

			player1 = AiPlayer.new('Player1')
			self.fill_player_cards(player1)			
			#self.sort_player_cards(player1)

			player2 = Player.new('Player2')
      self.add_observer(player2)
			self.fill_player_cards(player2)
			#self.sort_player_cards(player2)

			self.players << player1
			self.players << player2
			self.set_session_player(player1)
			self.set_current_player(player1)
			# TODO: fill cards_set and select trumph card
		end
    send_update
	end

# TODO make observer call after each method call

  # def self.method_missing(meth, *args)
  #   puts "+"*50
  #   puts "Was called " + meth.to_s + " method"
  #   puts "+"*50
  #   if self.players.length > 0
  #     self.players.each_index do |indx|
  #       self.players[indx].core = self
  #     end
  #   end    
  #   super
  # end

	#
  # Implements game start action
  #
  def start_game
		self.game_is_started = true
    send_update
  end

  #
  # Select new or return exist trump card
  #
  def get_trump_card
    if self.trump_card.nil?
      trump_index = rand(self.cards_set.length)
      self.trump_card = self.cards_set[trump_index]
      self.cards_set.delete_at(trump_index)
    end    
    send_update
    return self.trump_card
  end

  #
  # This function sort player's cards
  #
  def sort_player_cards(player)
    p_cards = player.get_player_cards
    p_cards.sort! { |a,b| a.card_weight <=> b.card_weight }
    p_cards.each_with_index do |card, index|
      if self.trump_card.card_type.name == card.card_type.name
        p_cards.delete_at(index)
        p_cards.push(card)
      end
    end
    player.player_cards = p_cards
    send_update
  end

  #
  # This function add cards to player's set
  #
  def fill_player_cards(player)
  	p_cards = []
    
  	if self.cards_set.length > 0
  		p_cards = player.get_player_cards
	  	while ((p_cards.length < 6) and (self.cards_set.length > 0)) do
	      card_from_set = rand(self.cards_set.length-1)
	      p_cards << self.cards_set[card_from_set]
	      self.cards_set.delete_at(card_from_set)
	    end
  	end

  	tmp = player.player_cards | p_cards
  	player.player_cards = tmp
  	self.sort_player_cards(player)
    send_update
  	return player.player_cards
  end

  #
  # This function pushing selected card on table
  #
  def push_card_on_table(player, card)
  	p_cards = player.get_player_cards
  	if key = p_cards.index(card)
  		self.cards_on_table << card
  		p_cards.delete_at(key)
  		player.player_cards = p_cards
		end
    send_update
		return self.cards_on_table
  end

  #
  # This function return next player
  #
  def get_next_player(player)
  	result = player
  	if (not self.players.nil?) and (not self.players.empty?)
  		if self.players.first == player
  			result = self.players.last
  		else
  			result = self.players.first
  		end
  	end
    send_update
  	return result
  end

	#
  # This function set player frim params as current
  #
  def set_current_player(player)
		self.current_player = player
    send_update
	end
	
  def get_current_player
		return self.current_player
	end

	def set_session_player(player)
		self.session_player = player
    send_update
	end

	def get_session_player
		return self.session_player
	end

	def set_params(params)
		self.input_params = params
    send_update
	end

	def get_params
		return self.input_params
	end

	def make_clear
		self.cards_on_table = []
    send_update
	end

	def end_game
		self.game_is_started = false
    send_update
	end

private

  #
  # Part of observer pattert, notify observer classes about observable update  
  #
  def send_update
    changed
    notify_observers(self)
  end

end