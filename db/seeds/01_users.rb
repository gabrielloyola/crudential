USERS = [
  {
    name: "Admin Crudential",
    email: "admin@crudential.test",
    role: "admin",
    password: "password"
  },
  {
    name: "Equipe Credenciamento",
    email: "staff@crudential.test",
    role: "staff",
    password: "password"
  }
].index_by { |attributes| attributes.fetch(:email) }

USERS.each_value do |attributes|
  user = User.find_or_initialize_by(email: attributes.fetch(:email))
  user.assign_attributes(attributes)
  user.save!
end
