class Card < ActiveRecord::Base
  attr_accessible :name, :card_type, :card_weight
  belongs_to :card_type

  @@cards_set = []
  @@player_cards = []
  @@cards_on_table = []
  @@trump_card = nil
  @@game_is_started = FALSE
  @@played_games = 0
  @@stock = []
  @@step = 'game'
  @@end_of_move = FALSE

  def self.set_end_on_move(val)
    @@end_of_move = val
  end
  def self.get_end_on_move
    @@end_of_move
  end

  def self.start_game
    if @@game_is_started == FALSE
      self::give_cards_set
      self::get_player_cards(1)
      self::get_player_cards(2)
      self::get_trump_card
      @@game_is_started = TRUE
    end
  end

  def self::player_has_cards_to_add?(player)
    result = FALSE
    if not self::get_player_card_to_add(player).empty?
      result = TRUE
    end
    return result
  end

  def self::get_player_card_to_add(player)
    result = []
    if not @@player_cards[player].empty? and not @@cards_on_table.empty?
      @@cards_on_table.each_with_index do |val, key|
        @@player_cards[player].each_with_index do |v, k|
          if v.card_weight == val['card'].card_weight
            result << {'pcards_key' => k, 'pcards_card' => v}
          end
        end
      end
    end
    return result
  end

  def self.game_is_started?
    @@game_is_started
  end

  def self.get_cards_on_table
    @@cards_on_table
  end

  def self.give_cards_set
    if @@cards_set.empty?
      @@cards_set = Card.find :all
    else
      @@cards_set
    end
  end

  def self.get_player_cards(player)

    if @@cards_set.empty?
      self.give_cards_set
    end

    if @@player_cards[player].nil? or @@step == 'clear'
      if @@player_cards[player].nil?
        @@player_cards[player] = []
      end
      while @@player_cards[player].length < 6
        card_from_set = rand(@@cards_set.length)
        @@player_cards[player] << @@cards_set[card_from_set]
        @@cards_set.delete_at(card_from_set)
      end
    end

    return @@player_cards[player]
  end

  def self.sort_player_cards(player)
    player_cards = self::get_player_cards(player)
    player_cards.sort! { |a,b| a.card_weight <=> b.card_weight }
    player_cards.each_with_index do |card, index|
      if card.is_trump_card?
        player_cards.delete_at(index)
        player_cards.push(card)
      end
    end
  end

  def self::get_next_player
    if not @@stock.empty?
      puts "--"*20
      puts @@stock.last
      puts "--"*20
    end
    if not @@cards_on_table.empty?
      if @@cards_on_table.last['player'].to_int == 1
        return 2
      end
    elsif not @@stock.empty? and not @@stock.last.nil? and @@stock.last['player'].to_int == 2
      return 2
    end
    return 1
  end

  def self.push_card_on_table(player, card_id=nil)
    player_cards = self::get_player_cards(player)
    if @@cards_on_table.empty?
      @@cards_on_table << { 'player' => player, 'card' => player_cards.first }
      player_cards.delete_at(0)
    else
      if not card_id.nil?
        player_cards.each_with_index do |c, ind|
          if c.id == card_id
            @@cards_on_table << { 'player' => player, 'card' => player_cards[ind] }
            player_cards.delete_at(ind)
          end
        end
      else
        if self::player_has_cards_to_add?(player)
          card = self::get_player_card_to_add(player).first
          @@cards_on_table << { 'player' => player, 'card' => player_cards[card['pcards_key']] }
          player_cards.delete_at(card['pcards_key'])
        end
      end
    end
    @@player_cards[player] = player_cards
  end

  def self.make_clear
    @@step = 'clear'
    @@cards_on_table.each do |c|
      @@stock.push(c)
    end
    #@@stock << @@cards_on_table
    @@cards_on_table = []
    self::get_player_cards(1)
    self::get_player_cards(2)
    @@step = 'game'
  end

  def self.make_mine(player)
    @@step = 'mine'
    @@cards_on_table.each do |c|
      @@player_cards[player] << c['card']
    end
    @@cards_on_table = []
    self::sort_player_cards(player)
    player = (player == 1 ? 2 : 1)
    self::get_player_cards(player)
    self::sort_player_cards(player)
    @@step= 'game'
  end

  def is_trump_card?
    if @@trump_card.card_type.name == self.card_type.name
      return true
    end
    return false
  end

  def self.get_trump_card
    if @@trump_card.nil?
      trump_index = rand(@@cards_set.length)
      @@trump_card = @@cards_set[trump_index]
      @@cards_set.delete_at(trump_index)
    end
    return @@trump_card
  end

  def can_kick_card?(card)
    result = FALSE
    if card.card_type.name == self.card_type.name and card.card_weight < self.card_weight
      result = TRUE
    end
    if card.card_type.name != @@trump_card.card_type.name && self.card_type.name == @@trump_card.card_type.name
      result = TRUE
    end
    return result
  end

  def do_action(card_type)

  end

  def get_cards

  end

end
