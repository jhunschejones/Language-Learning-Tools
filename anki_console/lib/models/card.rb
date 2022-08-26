class Card < ActiveRecord::Base
  # disable STI as it's not being used here
  self.inheritance_column = :_type_disabled

  belongs_to :note, foreign_key: "nid"
  belongs_to :deck, foreign_key: "did"

  scope :suspended, -> { where(queue: -1) }
  scope :not_suspended, -> { where.not(queue: -1) }
end
