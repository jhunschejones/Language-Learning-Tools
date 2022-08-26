class Deck < ActiveRecord::Base
  has_many :cards, foreign_key: "did"
end
