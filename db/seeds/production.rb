role = Role.create(name: 'admin')
user = User.create(email: "admin@example.com", password: "password", role: [role])
