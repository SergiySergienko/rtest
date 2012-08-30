class Si::InputSystem

	attr_accessor :input_params, :player, :core

	# possible actions
	# 1. push_card - push card on table
	# 2. make_mine - current player will take all cards from table
	# 

	def initialize(core, player)
		self.input_params = core.input_params
		self.core = core
		self.player = player
	end

	def analyze_data
		result = {:result => false, :error_text => 'Unknown operation'}
		if (not self.input_params.nil?) and (not self.input_params[:op].nil?) and (not self.player.nil?)
			result = self.send(self.input_params[:op].to_s)
		end
		return result
	end

	def push_card
		result = {:result => false, :error_text => 'Unknown operation'}
		if (not self.input_params[:id].nil?)
			p_cards = self.player.get_player_cards
			last_card = self.core.cards_on_table.last
			if p_cards.length > 0
				selected_card = false
				p_cards.each do |card|
					if card.id.to_i = self.input_params[:id].to_i
						selected_card = card
					end
				end
				if selected_card and validate_card_kick(last_card, selected_card)
					result = selected_card
				end
			end			
		end
		return result
	end

	def validate_card_kick(last_card, selected_card)
		result = false
		trump_card = self.core.get_trump_card
		if last_card.card_type.name == trump_card.card_type.name
			if selected_card.card_type.name == last_card.card_type.name and selected_card.card_weight > last_card.card_weight
				
			end
		else
			if selected_card.card_type.name == last_card.card_type.name and selected_card.card_weight > last_card.card_weight

			end
		end

		return result
	end

end