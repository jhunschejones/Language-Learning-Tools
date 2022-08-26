class Deck < ActiveRecord::Base
  has_many :cards, foreign_key: "did"
  has_many :notes, -> { distinct }, through: :cards
end
