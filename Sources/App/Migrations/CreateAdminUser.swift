import Fluent
import Vapor

struct CreateAdminUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        guard let name = Environment.get("NAME"),
              let username = Environment.get("USERNAME"),
              let password = Environment.get("PASSWORD"),
              let email = Environment.get("EMAIL")
        else {
            fatalError("Admin user credentials not found")
        }
        let passwordHash: String = try Bcrypt.hash(password)

        let user = User(
            name: name,
            username: username,
            password: passwordHash,
            email: email
        )

        try await user.save(on: database)
    }

    func revert(on database: any Database) async throws {
        guard let username = Environment.get("USERNAME") else {
            fatalError("Admin user name not found")
        }
        try await User.query(on: database)
            .filter(\.$username == username)
            .delete()
    }
}
