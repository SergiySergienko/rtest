class PlayerBase

  attr_accessor :player_id, :player_name, :player_cards

	def initialize(player_name)
		self.player_name = player_name
	end

	def push_card_on_table(card)
	end

	def pick_cards_from_set(cards_set)
  end

  def get_player_cards
    return self.player_cards
  end

	def choose_card_to_start
    return false
	end

	def choose_card_to_answer(cards_on_table)
	end

	def user_is_answering?(current_player)
		result = false
		if self.player_id == current_player.player_id
			result = true
		end
		return result
	end

	def make_mine(cards_on_table)
		self.player_cards = self.player_cards | cards_on_table
	end

end