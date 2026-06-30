CREDENTIALS = [
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "11122233344",
    status: "active",
    issued_at: Time.zone.parse("2026-07-01 10:05"),
    expires_at: Time.zone.parse("2026-08-15 23:59")
  },
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "22233344455",
    status: "active",
    issued_at: Time.zone.parse("2026-07-02 11:35"),
    expires_at: Time.zone.parse("2026-08-15 23:59")
  },
  {
    event_name: "Summit de Produtos Digitais",
    participant_document_number: "55566677788",
    status: "active",
    issued_at: Time.zone.parse("2026-07-05 09:20"),
    expires_at: Time.zone.parse("2026-10-21 23:59")
  }
]

CREDENTIALS.each do |attributes|
  registration = Registration.joins(:event, :participant).find_by!(
    events: { name: attributes.fetch(:event_name) },
    participants: { document_number: attributes.fetch(:participant_document_number) }
  )

  credential = Credential.find_or_initialize_by(registration:)
  credential.assign_attributes(
    status: attributes.fetch(:status),
    issued_at: attributes.fetch(:issued_at),
    expires_at: attributes.fetch(:expires_at)
  )
  credential.save!
end
