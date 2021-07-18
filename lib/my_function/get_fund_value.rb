require "open-uri"
require "nokogiri"

# id = "JP90C000FHD2"
module MyFunction
  module GetFundValue
    def get_now_value_of_fund(id)
      url = "https://www.rakuten-sec.co.jp/web/fund/rakuten-bank/detail.html?ID="+id
      charset = nil
      html = open(url) do |page|
        charset = page.charset
        page.read
      end
      
      contents = Nokogiri::HTML.parse(html,nil,charset)
      value_str = contents.xpath('//span[@class="value-01"]').inner_text
      value = value_str.gsub(",", "")
      
      return value.to_i
    end
  end
end