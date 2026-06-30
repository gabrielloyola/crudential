ACCESS_LOGS = [
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "11122233344",
    result: "granted",
    attempted_at: Time.zone.parse("2026-08-15 08:55")
  },
  {
    event_name: "Rails Conf Sao Paulo",
    participant_document_number: "22233344455",
    result: "granted",
    attempted_at: Time.zone.parse("2026-08-15 09:10")
  },
  {
    event_name: "Summit de Produtos Digitais",
    participant_document_number: "55566677788",
    result: "denied",
    attempted_at: Time.zone.parse("2026-10-20 08:30")
  }
]

ACCESS_LOGS.each do |attributes|
  registration = Registration.joins(:event, :participant).find_by!(
    events: { name: attributes.fetch(:event_name) },
    participants: { document_number: attributes.fetch(:participant_document_number) }
  )
  credential = Credential.find_by!(registration:)

  access_log = AccessLog.find_or_initialize_by(
    registration:,
    credential:,
    attempted_at: attributes.fetch(:attempted_at)
  )
  access_log.assign_attributes(result: attributes.fetch(:result))
  access_log.save!
end
