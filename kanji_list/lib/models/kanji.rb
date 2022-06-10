class Kanji < ActiveRecord::Base
  ADDED_STATUS = "added".freeze
  SKIPPED_STATUS = "skipped".freeze
  KANJI_REGEX = /[一-龯]/

  validates :character, presence: true, uniqueness: true, format: { with: KANJI_REGEX }

  scope :added, -> { where(status: ADDED_STATUS) }

  before_save :set_added_to_list_at

  class << self
    def next
      next_caracter = remaining_characters.first&.strip
      next_caracter ? new(character: next_caracter) : nil
    end

    def remaining_characters
      previous_characters = Kanji.pluck(:character)
      new_characters = Word
        .all
        .flat_map { |word| word.split("") }
        .uniq
        .select { |kanji| kanji =~ KANJI_REGEX }

      new_characters - previous_characters
    end
  end

  def add!
    self.status = ADDED_STATUS
    save!
    $logger.debug("Added: #{inspect}") if $logger
    self
  end

  def skip!
    self.status = SKIPPED_STATUS
    save!
    $logger.debug("Skipped: #{inspect}") if $logger
    self
  end

  private

  def set_added_to_list_at
    self.added_to_list_at = Time.now unless added_to_list_at
  end
end
