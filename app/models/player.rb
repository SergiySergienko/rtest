class Player < PlayerBase

	def choose_card_to_start
		si = Si::InputSystem.new(self.core, self, 'choose_card_to_start')
    return si.analyze_data
	end

	def choose_card_to_answer(cards_on_table, trump_card)
		si = Si::InputSystem.new(self.core, self, 'choose_card_to_answer')
    return si.analyze_data
	end

	def choose_card_to_add(cards_on_table)
		si = Si::InputSystem.new(self.core, self, 'choose_card_to_add')
    return si.analyze_data
	end

end