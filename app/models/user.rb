class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :accounts, dependent: :destroy
  has_many :genres, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :events, dependent: :destroy

  def total_value
    sum=0
    self.accounts.each do |account|
      sum+=account.value
    end
    return sum
  end

  def expense_genres
    a=[]
    self.genres.each do |genre|
      a << genre unless genre.iae
    end
    return a
  end

  def income_genres
    a=[]
    self.genres.each do |genre|
      a << genre if genre.iae
    end
    return a
  end
  
end
