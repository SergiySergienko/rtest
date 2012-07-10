class GameCore

	require 'player_base.rb'
	require 'user_player.rb'
	require 'ai_player.rb'
	require 'game_session.rb'
	
	attr_accessor :current_core_class, :current_session
		
	@@instance = GameCore.new
	
	def initialize
	puts '******************************************'
		if @@instance.nil?
			@@instance = GameCore.new
		else
			@@instance
		end
		start_game
	end
	
	@@cards_on_table = []
	@@game_is_started = FALSE
	@@stock = []
	@player
	
	
	def self.get_core
		return @@instance
	end
	
	def start_game
		if not @@game_is_started
			@@game_is_started = TRUE
			@player['user'] = UserPlayer.new
			@player['ai'] = AiPlayer.new
			@current_session = GameSession.new(@player['ai'])
			while not @current_session.session_is_done? == TRUE
				@current_session.make_action(@@cards_on_table)
			end
		end
	end
	
	def get_current_player
		# user || 'ui'
		result = @player['user']
		if not @@cards_on_table.nil?
			last = @@cards_on_table.last
			result = @player[last['player']]
		end
		return result
	end
	
	def process
		start_game
		player = get_current_player
		
		if player.class == 'AiPlayer'
			if not @@cards_on_table.nil?
				if player.is_has_cards_to_add?
					player.push_card(player.get_card_to_add)
				else
					player.push_card(player.get_smallest_card)
				end
			else
				player.push_card(player.get_smallest_card)
			end
		end
		
	end
	
	def end_game
	end
	
	def make_clear
		@@cards_on_table.each_with_index do |k,v|
			@@stock << v
		end
		@@cards_on_table = []
		
	end
	
	def make_mine(player)
	end
	
	private_class_method :new
	
end
