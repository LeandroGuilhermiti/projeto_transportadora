class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nome, presence: true

  has_many :packages, foreign_key: 'driver_id'

  before_validation :set_default_cargo, on: :create

  def admin?
    cargo == 'admin'
  end

  def motorista?
    cargo == 'motorista'
  end

  def cliente?
    cargo == 'cliente'
  end

  private

  def set_default_cargo
    self.cargo ||= 'cliente'
  end
end
