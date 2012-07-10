class PlayerBase
  @player_name
  @player_cards
  
  def get_player_name
	@player_name
  end
  
  def set_player_name(name)
	@player_name = name
  end
  
  def get_card_to_add
  end
  
  def get_smallest_card
  end  
  
  def get_cards
	@player_cards
  end
  
  def set_cards(cards)
	@player_cards = cards
  end
  
  def fill_player_cards
	
  end
  
  def push_card(card)
  end
  
  def add_card(card)
	@player_cards << card
  end
  
  def remove_card(card)
	@player_cards.each_with_index do |k,v|
		if v.id == card.id
			@player_cards.delete_at(k)
		end
	end
  end
  
end
