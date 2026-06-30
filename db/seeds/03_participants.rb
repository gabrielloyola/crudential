PARTICIPANTS = [
  {
    name: "Ana Martins",
    email: "ana.martins@example.com",
    document_number: "11122233344"
  },
  {
    name: "Bruno Almeida",
    email: "bruno.almeida@example.com",
    document_number: "22233344455"
  },
  {
    name: "Carla Souza",
    email: "carla.souza@example.com",
    document_number: "33344455566"
  },
  {
    name: "Diego Pereira",
    email: "diego.pereira@example.com",
    document_number: "44455566677"
  },
  {
    name: "Elisa Costa",
    email: "elisa.costa@example.com",
    document_number: "55566677788"
  }
].index_by { |attributes| attributes.fetch(:document_number) }

PARTICIPANTS.each_value do |attributes|
  participant = Participant.find_or_initialize_by(document_number: attributes.fetch(:document_number))
  participant.assign_attributes(attributes)
  participant.save!
end
