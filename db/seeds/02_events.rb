admin = User.find_by!(email: "admin@crudential.test")
staff = User.find_by!(email: "staff@crudential.test")

EVENTS = [
  {
    name: "Rails Conf Sao Paulo",
    description: "Encontro para pessoas desenvolvedoras Ruby on Rails.",
    starts_at: Time.zone.parse("2026-08-15 09:00"),
    ends_at: Time.zone.parse("2026-08-15 18:00"),
    capacity: 120,
    status: "published",
    user: admin
  },
  {
    name: "Workshop de Credenciamento",
    description: "Treinamento pratico para operacao de check-in.",
    starts_at: Time.zone.parse("2026-09-03 14:00"),
    ends_at: Time.zone.parse("2026-09-03 17:00"),
    capacity: 40,
    status: "draft",
    user: staff
  },
  {
    name: "Summit de Produtos Digitais",
    description: "Palestras sobre descoberta, entrega e operacao de produtos.",
    starts_at: Time.zone.parse("2026-10-20 10:00"),
    ends_at: Time.zone.parse("2026-10-21 17:00"),
    capacity: 250,
    status: "published",
    user: admin
  }
].index_by { |attributes| attributes.fetch(:name) }

EVENTS.each_value do |attributes|
  event = Event.find_or_initialize_by(name: attributes.fetch(:name), user: attributes.fetch(:user))
  event.assign_attributes(attributes)
  event.save!
end
