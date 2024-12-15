import Fluent

struct CreateToken: AsyncMigration {
    typealias TokenKey = Token.Key
    typealias Schema = Token.Schema
    typealias UsersSchema = User.Schema

    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(TokenKey.value, .string, .required)
            .field(TokenKey.userID, .uuid, .required, .references(UsersSchema.title, FieldKey.id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
