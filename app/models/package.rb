class Package < ApplicationRecord
  belongs_to :driver, class_name: "User", optional: true

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

