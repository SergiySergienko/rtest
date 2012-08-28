class GameCore

  attr_accessor :session_player, :current_player, :players, :game_is_started, :cards_on_table, :cards_set, :input_params, :trump_card

	def initialize
		self.start_game
		if self.players.nil?
      
      self.players = []
      self.cards_on_table = []
      self.cards_set = Card.find(:all)
      self.get_trump_card

			player1 = AiPlayer.new('Player1')
			self.fill_player_cards(player1)			
			#self.sort_player_cards(player1)

			player2 = Player.new('Player2')
			self.fill_player_cards(player2)
			#self.sort_player_cards(player2)

			self.players << player1
			self.players << player2
			self.set_session_player(player1)
			self.set_current_player(player1)
			# TODO: fill cards_set and select trumph card
		end
	end

	def start_game
		self.game_is_started = true
  end

  def get_trump_card
    if self.trump_card.nil?
      trump_index = rand(self.cards_set.length)
      self.trump_card = self.cards_set[trump_index]
      self.cards_set.delete_at(trump_index)
    end    
    return self.trump_card
  end

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
  end

  #TODO: This function call recursion when cards_set length < 6
  def fill_player_cards(player)
  	p_cards = []
  	if self.cards_set.length == 1
  		p_cards << self.cards_set.first
  		self.cards_set.delete_at(0)
  	elsif self.cards_set.length > 1
  		p_cards = player.get_player_cards
	  	while ((p_cards.length < 6) or (self.cards_set.length == 0)) do
	      card_from_set = rand(self.cards_set.length)
	      p_cards << self.cards_set[card_from_set]
	      self.cards_set.delete_at(card_from_set)
	    end
  	end
  	tmp = player.player_cards | p_cards
  	player.player_cards = tmp
  	self.sort_player_cards(player)
  	return player.player_cards
  end

  def push_card_on_table(player, card)
  	p_cards = player.get_player_cards
  	if key = p_cards.index(card)
  		self.cards_on_table << card
  		p_cards.delete_at(key)
  		player.player_cards = p_cards
		end
		return self.cards_on_table
  end

  def get_next_player(player)
  	result = player
  	if (not self.players.nil?) and (not self.players.empty?)
  		if self.players.first == player
  			result = self.players.last
  		else
  			result = self.players.first
  		end
  	end
  	return result
  end

	def set_current_player(player)
		self.current_player = player
	end

	def get_current_player
		return self.current_player
	end

	def set_session_player(player)
		self.session_player = player
	end

	def get_session_player
		return self.session_player
	end

	def set_params(params)
		self.input_params = params
	end

	def get_params
		return self.input_params
	end

	def make_clear
		self.cards_on_table = []
	end

	def end_game
		self.game_is_started = false
	end

end