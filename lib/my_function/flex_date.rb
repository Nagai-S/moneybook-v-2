module MyFunction
  class FlexDate < Date
    def initialize(year, month, day)
      if Date.valid_date?(year, month, day)
        super(year, month, day)
      else
        status = false;
        10.times do |i|
          if Date.valid_date?(year, month, day - i - 1)
            super(year, month, day - i - 1)
            status = true
            break
          end
        end
        unless status
          super(year, month, day)
        end
      end
    end

    def self.valid_date?(year, month, day)
      return super(year, month, 10) && day >= 1 && day <= 31
    end

  end
end
