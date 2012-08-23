class GameCore

	attr_accessible :current_player, :game_is_started, :cards_on_table, :cards_set

	def start_game
		self.game_is_started = true
	end

	def set_current_player(player)
		self.current_player = player
	end

	def get_current_player
		return self.current_player
	end

	def make_clear
		self.cards_on_table = []
	end

	def end_game
		self.game_is_started = false
	end

end