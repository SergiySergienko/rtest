class GameFlow

	attr_accesible :core

	def initialize
		self.core = GameCore.new
	end

	def make_action(params)

		# 1-st step is give_cards
		# 2-nd step is select_player
		# 3-rd step is choose_card
		# 4-th step is pust_card_on_table

		player = self.core.get_current_player		
		card = false

		if player.user_is_answering?(player) # Step 2
			card = player.choose_card_to_answer(self.core.cards_on_table) # Step 3
		else
			card = player.choose_card_to_push # Step 3
		end
		
		if card == false
			# player havn't cards to answer			
			player.make_mine(self.core.cards_on_table) # Step 4
		else
			# Player starting new session
			player.push_card_on_table(card) # Step 4
		end

	end

end