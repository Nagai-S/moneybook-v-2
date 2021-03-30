class FlexDate
  def self.valid_date?(year, month, day)
    return Date.valid_date?(year, month, 10) && day>=1 && day<=31
  end

  def self.return_date(year, month, day)
    if Date.valid_date?(year, month, day)
      return Date.new(year, month, day)
    else
      10.times do |i|
        if Date.valid_date?(year, month, day-i-1)
          return Date.new(year, month, day-i-1)
          break
        end
      end
    end
  end
end