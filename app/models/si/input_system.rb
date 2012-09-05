class Si::InputSystem

	attr_accessor :input_params, :player, :core, :action

	# possible actions
	# 1. push_card - push card on table
	# 2. make_mine - current player will take all cards from table
	# 

	def initialize(core, player, action)
		self.input_params = core.input_params
		self.core = core
		self.player = player
		self.action = action
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
		if (not self.input_params[:cid].nil?)
			
			if (self.action == 'choose_card_to_answer') or (self.action == 'choose_card_to_start')

				p_cards = self.player.get_player_cards
				last_card = self.core.cards_on_table.last
				if p_cards.length > 0
					selected_card = false
					p_cards.each do |card|
						if card.id.to_s == self.input_params[:cid]
							selected_card = card
						end
					end
					
					if last_card.nil?
						# start new session
						if selected_card
							result = selected_card
						end
					else
						# answering					
						if selected_card and validate_card_kick(last_card, selected_card)
							result = selected_card
						end
					end

				end
			
			elsif self.action == 'choose_card_to_add'
				
				p_cards = self.player.get_player_cards
				
				if p_cards.length > 0
					
					selected_card = false
					p_cards.each do |card|
						if card.id.to_s == self.input_params[:cid]
							selected_card = card
						end
					end

					if selected_card and validate_card_add(self.core.cards_on_table, selected_card)
						result = selected_card
					end					

				end

			end

		end
		return result
	end

	def mine
		result = {:result => false, :error_text => 'Error'}
		if self.action == 'choose_card_to_answer' and (self.core.get_current_player == self.player)
			result = {:result => true, :op => 'mine', :error_text => 'Success'}
		end
		return result
	end

	def clear
		result = {:result => false, :error_text => 'Error'}
		if self.action == 'choose_card_to_add' and (self.core.get_current_player == self.player)
			result = {:result => true, :op => 'clear', :error_text => 'Success'}
		end
		return result
	end

private

	def validate_card_kick(last_card, selected_card)
		result = false
		trump_card = self.core.get_trump_card
		if last_card.card_type.name == trump_card.card_type.name
			if selected_card.card_type.name == last_card.card_type.name and selected_card.card_weight > last_card.card_weight
				result = true
			end
		else
			if (selected_card.card_type.name == last_card.card_type.name and selected_card.card_weight > last_card.card_weight) or (last_card.card_type.name != trump_card.card_type.name and selected_card.card_type.name == trump_card.card_type.name)
				result = true
			end
		end

		return result
	end

	def validate_card_add(cards_on_table, selected_card)
		
		result = false
		
		cards_on_table.each do |card|
			if selected_card.card_weight == card.card_weight
				result = true
			end
		end

		return result

	end

end