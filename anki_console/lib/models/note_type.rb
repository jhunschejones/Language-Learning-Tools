class NoteType < ActiveRecord::Base
  self.table_name = "notetypes"
  has_many :notes, foreign_key: "mid"
end
