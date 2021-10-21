module FundUsersHelper
  def plus_minus_gain_value(value)
    value > 0 ? "+" + value.to_s(:delimited) : value.to_s(:delimited)
  end
end
