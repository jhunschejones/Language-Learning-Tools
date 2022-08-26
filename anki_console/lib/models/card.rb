class Card < ActiveRecord::Base
  # disable STI as it's not being used here
  self.inheritance_column = :_type_disabled

  belongs_to :note, foreign_key: "nid"

  scope :suspended, -> { where(queue: -1) }
end
