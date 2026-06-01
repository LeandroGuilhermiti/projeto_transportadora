class Package < ApplicationRecord
  belongs_to :driver, class_name: "User", optional: true
  belongs_to :user, optional: true
  has_many :tracking_events, dependent: :destroy

  CAPITAL_COORDINATES = {
    "Manaus - AM"                => { top: 23.3, left: 32.7 },
    "Belém - PA"                 => { top: 20, left: 55.9 },
    "Macapá - AP"                => { top: 15.2, left: 50.8 },
    "Boa Vista - RR"             => { top: 9.8, left: 31.4 },
    "Porto Velho - RO"           => { top: 35.7, left: 25 },
    "Rio Branco - AC"            => { top: 38.6, left: 16.4 },
    "Cuiabá - MT"                => { top: 48.9, left: 40.6 },
    "Palmas - TO"                => { top: 39, left: 56.1 },
    "São Luís - MA"              => { top: 20, left: 63 },
    "Teresina - PI"              => { top: 27.5, left: 67.8 },
    "Fortaleza - CE"             => { top: 24.2, left: 75.1 },
    "Natal - RN"                 => { top: 29, left: 82.3 },
    "João Pessoa - PB"           => { top: 31.8, left: 83 },
    "Recife - PE"                => { top: 34.1, left: 82.8 },
    "Maceió - AL"                => { top: 37.3, left: 81.1 },
    "Aracaju - SE"               => { top: 40.4, left: 78.7 },
    "Salvador - BA"              => { top: 44.5, left: 76.3 },
    "Goiânia - GO"               => { top: 53.6, left: 54.1 },
    "Brasília - DF"              => { top: 51.5, left: 57.3 },
    "Campo Grande - MS"          => { top: 62.6, left: 43.8 },
    "Belo Horizonte - MG"        => { top: 61, left: 65.5 },
    "Vitória - ES"               => { top: 62.2, left: 72.3 },
    "Rio de Janeiro - RJ"        => { top: 68.1, left: 66.8 },
    "São Paulo - SP"             => { top: 69.7, left: 59.3 },
    "Curitiba - PR"              => { top: 74.4, left: 54 },
    "Florianópolis - SC"         => { top: 79.3, left: 56.1 },
    "Porto Alegre - RS"          => { top: 85.3, left: 50 },
  }.freeze

  scope :em_rota,   -> { where(status: ['Pendente', 'Processando', 'em_transito', 'em rota']) }

  def map_coordinates
    CAPITAL_COORDINATES[regiao] || { top: 50, left: 50 }
  end

  before_create :gerar_codigo_rastreio

  private

  def gerar_codigo_rastreio
    return if codigo_rastreio.present?

    loop do
      codigo = "RTG-#{rand(10000..99999)}-BR"
      unless Package.exists?(codigo_rastreio: codigo)
        self.codigo_rastreio = codigo
        break
      end
    end
  end
end

