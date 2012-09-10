class GameFlow

  attr_accessor :core

	def initialize
		self.core = GameCore.new
	end

	def make_action(params)
      
    redirect_result = true

    if not params.nil?
      self.core.set_params(params)
      if (not params[:op].nil?)
        redirect_result = { :action => :index }
      end
    else
      self.core.set_params(nil)
    end

		player = self.core.get_current_player
    session_player = self.core.get_session_player
		card = false

    if self.core.game_is_started

      # check for winners
      if self.core.cards_set.length == 0
        winner = false
        
        if player.get_player_cards.length == 0          
          winner = player          
        elsif self.core.get_next_player(player).get_player_cards.length == 0          
          winner = self.core.get_next_player(player)
        end

        if not winner == false
          self.core.end_game
          puts "*"*50
          puts winner.player_name + " !!!!!!!!!!!WIN!!!!!!!!!"
          puts "*"*50
          return
        end

      end

  		if player.user_is_answering?(session_player)

        puts "*"*50
        puts player.player_name
        puts " is answering"
        puts "*"*50

        # Player is answering

        card = player.choose_card_to_answer(self.core.cards_on_table, self.core.get_trump_card)
        if card == false or (card.is_a?(Hash) and card[:result] == true and card[:op] == 'mine')
          # player haven't cards to answer
          
          puts "*"*50
          puts player.player_name
          puts " have no cards to asnwer"
          puts "*"*50

          player.make_mine(self.core.cards_on_table)
          self.core.sort_player_cards(player)
          self.core.cards_on_table = []
          
          # run redirect
          redirect_result = { :action => :index }
          

        elsif (card.is_a?(Hash))          

          return redirect_result

        else
          self.core.push_card_on_table(player, card)
        end

        self.core.set_current_player(self.core.get_session_player)

      else

        if self.core.cards_on_table.empty? # If there is no cards on table than start new session
          
          puts "*"*50
          puts player.player_name
          puts " start new session"
          puts "*"*50

          # Starts new session

          self.core.set_session_player(player)

          if ((player.get_player_cards.length < 6) or (self.core.get_next_player(player).get_player_cards.length < 6)) and (self.core.cards_set.length > 0)
            # Check if count of players cards < 6
            self.core.fill_player_cards(player)
            self.core.fill_player_cards(self.core.get_next_player(player))
          end

          card = player.choose_card_to_start
          if card == false
            self.core.end_game
            # !!! This player win !!!
            puts "*"*50
            puts player.player_name
            puts "!!! WIN !!!"
            puts "*"*50

          
          elsif (card.is_a?(Hash))            

            return redirect_result

          else
            self.core.push_card_on_table(player, card)
            self.core.set_current_player(core.get_next_player(self.core.get_current_player))
          end

        else # if have cards on table than choose card to add

          puts "*"*50
          puts player.player_name
          puts " add card"
          puts "*"*50

          card = player.choose_card_to_add(self.core.cards_on_table)
          
          if card == false or 
            (card.is_a?(Hash) and card[:result] == true and card[:op] == 'clear') or 
            (core.get_next_player(self.core.get_current_player).get_player_cards.length == 0)
            # user havnt card to add 
            # make clear
            
            puts "*"*50
            puts player.player_name + " make clear"          
            puts "*"*50

            if not self.core.release.empty?
              tmp = self.core.release | self.core.cards_on_table
              self.core.release = tmp
            else
              self.core.release = self.core.cards_on_table
            end
            self.core.cards_on_table = []
            self.core.set_current_player(self.core.get_next_player(self.core.get_current_player))
            self.core.set_session_player(self.core.get_current_player)

            # run redirect
            redirect_result = { :action => :index }
            return redirect_result
          
          elsif (card.is_a?(Hash))            

            return redirect_result

          else
            self.core.push_card_on_table(player, card)
            self.core.set_current_player(core.get_next_player(self.core.get_current_player))
          end

        end      

  		end
    else

      puts "*"*50
      puts player.player_name + " !!!!!!!!!!!WIN!!!!!!!!!"
      puts "*"*50

    end

    return redirect_result

	end

end