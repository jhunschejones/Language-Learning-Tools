class UUID
  REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.freeze

  def self.generate
    `uuidgen`.chomp.downcase
  end
end
