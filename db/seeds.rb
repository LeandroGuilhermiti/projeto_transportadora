# Limpando banco
puts "Limpando banco de dados..."
Vehicle.destroy_all
Package.destroy_all
User.destroy_all

puts "Criando usuários..."
User.create!(
  nome: 'Administrador',
  email: 'admin@rotagily.com',
  password: 'password123',
  cargo: 'admin'
)

User.create!(
  nome: 'Carlos Motorista',
  email: 'carlos@rotagily.com',
  password: 'password123',
  cargo: 'motorista'
)

User.create!(
  nome: 'Cliente',
  email: 'cliente@rotagily.com',
  password: 'password123',
  cargo: 'cliente'
)

puts "Criando veículos..."
Vehicle.create!(placa: 'ABC-1234', modelo: 'Van Mercedez', capacidade: 1500)
Vehicle.create!(placa: 'XYZ-9876', modelo: 'Caminhão Volvo FH 540', capacidade: 30000)

puts "Seeds finalizados com sucesso!"
