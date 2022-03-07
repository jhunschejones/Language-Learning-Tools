class Sentence < ActiveRecord::Base
  validates :japanese_sentence, presence: true, uniqueness: true
  validates :english_sentence, presence: true
  validates :pcloud_file_id, presence: true, uniqueness: true
end
