class GameFlow

  attr_accessor :core

	def initialize
		self.core = GameCore.new
	end

	def make_action(params)
    puts "*"*50
    puts params.inspect
    puts "*"*50
		player = self.core.get_current_player		
		card = false

		if player.user_is_answering?(player)

      # Player is answering

      card = player.choose_card_to_answer(self.core.cards_on_table)
      if card == false
        # player havn't cards to answer
        player.make_mine(self.core.cards_on_table)
      else
        player.push_card_on_table(card)
      end

    else

      # Starts new session

      if player.get_player_cards.length < 6
        # Check if count of players cards < 6
        player.pick_cards_from_set(core.cards_set)
        core.get_next_player.pick_cards_from_set(core.cards_set)
      end

      card = player.choose_card_to_start
      if card == false
        # !!! This player win !!!
        puts "!!"*50
        puts player.player_name
        puts "!!! WIN !!!"
        puts "!!"*50
      else
        player.push_card_on_table(card)
        player.set_current_player(core.get_next_player)
      end

		end

	end

end