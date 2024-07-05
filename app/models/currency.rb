# == Schema Information
#
# Table name: currencies
#
#  id         :bigint           not null, primary key
#  locale     :string(255)
#  mark       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Currency < ApplicationRecord

  validates :name,
            presence: {
              message: 'は１文字以上入力してください。'
            },
            uniqueness: {
              message: '「%{value}」と同じ名前の通貨が存在します。',
              case_sensitive: false
            }

  validates :mark,
            presence: {
              message: 'は１文字以上入力してください。'
            },
            uniqueness: {
              message: '「%{value}」と同じマークの通貨が存在します。',
              case_sensitive: false
            }
end
