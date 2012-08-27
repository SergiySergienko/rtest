class GameCore

  attr_accessor :session_player, :current_player, :players, :game_is_started, :cards_on_table, :cards_set

	def initialize
		self.start_game
		if self.players.nil?
      self.players = []
			player1 = AiPlayer.new('Player1')
			player2 = Player.new('Player2')
			self.players << player1
			self.players << player2
			self.current_player = player1
			# TODO: fill cards_set and select trumph card
		end
	end

	def start_game
		self.game_is_started = true
  end

  def fill_player_cards(player)
  end

  def get_next_player(player)

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