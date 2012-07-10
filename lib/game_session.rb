class GameSession
	
	attr_accessor :current_player
	@session_is_done = FALSE
	
	def initialize(current_player)
		@current_player = current_player
	end
	
	def make_action(cards_on_table)
		if cards_on_table.nil?
			card = @current_player.get_smallest_card
			@current_player.push_card(card)
		else
			last = cards_on_table.last
			if @current_player.can_answer?(last['card'])
				card = @current_player.get_card_to_anwer(last['card'])
				@current_player.push_card(card)
			else
				@current_player.make_mine(cards_on_table)
				@session_is_done = TRUE
			end
		end
	end
	
	def session_is_done?
		@session_is_done
	end
	
end
