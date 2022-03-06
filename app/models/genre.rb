# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  iae        :boolean          default(FALSE)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_genres_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Genre < ApplicationRecord
  belongs_to :user
  has_many :events
  has_many :shortcuts, dependent: :destroy

  validates :name,
            presence: {
              message: 'は１文字以上入力してください。'
            },
            uniqueness: {
              scope: :user,
              message: '「%{value}」と同じ名前のジャンルが存在します。',
              case_sensitive: false
            }

  def before_destroy_action
    events.each { |event| event.update(genre_id: nil) }
  end
end
