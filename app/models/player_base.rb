class PlayerBase

  attr_accessor :player_id, :player_name, :player_cards

	def initialize(player_name)
		self.player_name = player_name
		self.player_cards = []
	end

	def pick_cards_from_set(cards_set)
  end

  def get_player_cards
  	result = []
  	if not self.player_cards.nil?
  		result = self.player_cards
  	end
    return result
  end

	def choose_card_to_start
		result = false
		if (not self.get_player_cards.nil?) and (not self.get_player_cards.empty?)
			result = self.get_player_cards.first
		end
    return result
	end

	def choose_card_to_answer(cards_on_table, trump_card)
		last_card = cards_on_table.last
		result = false
		
		if last_card.card_type.name == trump_card.card_type.name
			# select ony from trump cards
			self.player_cards.each_index do |key|
				card = self.player_cards[key]
				if card.card_type.name == last_card.card_type.name and card.card_weight > last_card.card_weight
		      result = card
		      return result	    	
		    end	    
			end
		else
			#check for card with same type
			self.player_cards.each_index do |key|
				card = self.player_cards[key]
				if card.card_type.name == last_card.card_type.name and card.card_weight > last_card.card_weight
		      result = card
		      return result
		    end	    
			end
			#check for trump card
			self.player_cards.each_index do |key|
				card = self.player_cards[key]
				if card.card_type.name == trump_card.card_type.name
		      result = card
		      return result	    	
		    end	    
			end
		end
    
    return result
	end

	def choose_card_to_add(cards_on_table)
		result = false
		
		self.player_cards.each do |card|			
			cards_on_table.each do |t_card|				
				if card.card_weight == t_card.card_weight
		      result = card
		      return result
		    end	    
			end			
		end
    
    return result
	end

	def user_is_answering?(session_player)
		result = true
		if self.player_name == session_player.player_name
			result = false
		end
		return result
	end

	def make_mine(cards_on_table)
		tmp = self.player_cards | cards_on_table
		self.player_cards = tmp
	end

end