class Card < ActiveRecord::Base
  attr_accessible :name, :card_type, :card_weight
  belongs_to :card_type

end
