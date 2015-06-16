class UniqReference
  def self.generate
    loop do
      slug = reference
      unless Ticket.find_by_slug(slug)
        return slug
        break
      end
    end
  end

  private

  def self.random_chars
    Array.new(3) { [*'A'..'Z'].sample }.join
  end

  def self.random_hex
    Array.new(2) { rand(16).to_s(16).upcase }.join
  end

  def self.reference
    [random_chars, random_hex, random_chars, random_hex, random_chars].join('-')
  end
end