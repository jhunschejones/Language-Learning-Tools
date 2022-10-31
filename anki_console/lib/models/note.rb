class Note < ActiveRecord::Base
  has_many :cards, foreign_key: "nid"
  belongs_to :note_type, foreign_key: "mid"

  scope :leeches, -> { where("tags LIKE ?", "%leech%") }
  scope :all_cards_suspended, -> { where.not(id: Card.not_suspended.select(:nid)) }
end
