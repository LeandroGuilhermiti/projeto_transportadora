class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nome, presence: true

  has_many :packages, foreign_key: 'driver_id'

  before_validation :set_default_cargo, on: :create
  before_save :limpar_regiao_atuacao_se_nao_for_motorista

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

  def limpar_regiao_atuacao_se_nao_for_motorista
    self.regiao_atuacao = nil unless motorista?
  end
end
