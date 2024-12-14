import Fluent

struct CreateUser: AsyncMigration {
    typealias UserKey = User.Key
    typealias Schema = User.Schema

    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(UserKey.name, .string, .required)
            .field(UserKey.username, .string, .required)
            .field(UserKey.password, .string, .required)
            .field(UserKey.email, .string, .required)
            .unique(on: UserKey.email)
            .unique(on: UserKey.email)
            .field(UserKey.profilePicture, .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
