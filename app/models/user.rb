class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :trackable,
         :timeoutable, :lockable

  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts

  validates :name, presence: true
end
