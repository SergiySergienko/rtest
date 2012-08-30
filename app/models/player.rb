class Player < PlayerBase

	def choose_card_to_start
		si = Si::InputSystem.new(self.core, self)
    return si.analyze_data
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

end