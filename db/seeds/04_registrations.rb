REGISTRATIONS = [
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "11122233344",
    status: "confirmed",
    confirmed_at: Time.zone.parse("2026-07-01 10:00")
  },
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "22233344455",
    status: "confirmed",
    confirmed_at: Time.zone.parse("2026-07-02 11:30")
  },
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "33344455566",
    status: "pending",
    confirmed_at: nil
  },
  {
    event_name: "Workshop de Credenciamento",
    participant_document_number: "44455566677",
    status: "pending",
    confirmed_at: nil
  },
  {
    event_name: "Summit de Produtos Digitais",
    participant_document_number: "55566677788",
    status: "confirmed",
    confirmed_at: Time.zone.parse("2026-07-05 09:15")
  }
]

REGISTRATIONS.each do |attributes|
  event = Event.find_by!(name: attributes.fetch(:event_name))
  participant = Participant.find_by!(document_number: attributes.fetch(:participant_document_number))

  registration = Registration.find_or_initialize_by(event:, participant:)
  registration.assign_attributes(
    status: attributes.fetch(:status),
    confirmed_at: attributes.fetch(:confirmed_at)
  )
  registration.save!
end
