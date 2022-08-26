class Note < ActiveRecord::Base
  has_many :cards, foreign_key: "nid"

  scope :leeches, -> { where("tags LIKE ?", "%leech%") }
  scope :all_cards_suspended, -> { where.not(id: Card.not_suspended.select(:nid)) }
end
