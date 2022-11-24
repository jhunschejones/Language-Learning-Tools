# Good docs about gathering stats: https://docs.ankiweb.net/stats.html#manual-analysis

class Review < ActiveRecord::Base
  # disable STI as it's not being used here
  self.inheritance_column = :_type_disabled
  self.table_name = "revlog"
  belongs_to :card, foreign_key: "cid"

  # 2.5% of the reviews in my DB no longer have cards
  scope :with_cards, -> { where.associated(:card) }

  class << self
    # `time` field is the ms value for how long the review took
    def total_minutes
      self.all.pluck(:time).sum.to_f / 1000 / 60
    end

    def total_minutes_for(day:)
      raise "`day` must be a Date" unless day.is_a?(Date)
      total_ms = self
        .all
        .filter { |r| Time.at(r.id / 1000).to_date === day } # `id` is the ms timestamp of when the review was completed
        .pluck(:time)
        .sum
        .to_f

      total_ms / 1000 / 60
    end
  end

  def completed_at
    # `id` is the ms timestamp of when the review was completed
    Time.at(id / 1000)
  end
end
