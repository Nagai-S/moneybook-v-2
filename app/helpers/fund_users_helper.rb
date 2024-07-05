module FundUsersHelper
  def fund_users_data_for_glaph
    fund_users_array = []
    @fund_users.each do |fund_user|
      fund_users_array.push(
        [omit_string(fund_user.fund.name), fund_user.now_value({scale: true}).round]
      )
    end
    fund_users_array.sort { |a, b| (-1) * (a[1] <=> b[1]) }
  end
end
