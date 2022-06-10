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

    def dump_to_yaml
      File.open(KANJI_YAML_DUMP_PATH, "w") do |file|
        file.write(
          {
            "added_kanji" => Kanji.where(status: ADDED_STATUS).map do |kanji|
              {
                "character" => kanji.character,
                "added_to_list_at" => kanji.added_to_list_at&.strftime("%m/%d/%Y")
              }.compact
            end,
            "skipped_kanji" => Kanji.where(status: SKIPPED_STATUS).map do |kanji|
              {
                "character" => kanji.character,
                "added_to_list_at" => kanji.added_to_list_at&.strftime("%m/%d/%Y")
              }.compact
            end
          }.to_yaml
        )
      end
    end

    def load_from_yaml_dump
      dump = YAML.load(File.open(KANJI_YAML_DUMP_PATH))
      Kanji.destroy_all
      dump["added_kanji"].each do |kanji|
        Kanji.new(
          character: kanji["character"]&.strip,
          added_to_list_at: (kanji["added_to_list_on"] || kanji["added_to_list_at"]) && Date.strptime(kanji["added_to_list_on"] || kanji["added_to_list_at"], "%m/%d/%Y")
        ).add!
      end
      dump["skipped_kanji"].each do |kanji|
        Kanji.new(
          character: kanji["character"]&.strip,
          added_to_list_at: (kanji["added_to_list_on"] || kanji["added_to_list_at"]) && Date.strptime(kanji["added_to_list_on"] || kanji["added_to_list_at"], "%m/%d/%Y")
        ).skip!
      end
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
