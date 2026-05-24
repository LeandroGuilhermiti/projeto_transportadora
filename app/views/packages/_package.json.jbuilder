json.extract! package, :id, :codigo_rastreio, :destinatario, :endereco, :status, :peso, :dimensoes, :driver_id, :created_at, :updated_at
json.tracking_events package.tracking_events.order(created_at: :desc) do |event|
  json.extract! event, :id, :status, :descricao, :localizacao, :created_at
end
json.url package_url(package, format: :json)
