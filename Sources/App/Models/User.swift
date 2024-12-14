import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String

    @Children(for: \.$user)
    var exams: [Exam]

    @Field(key: "password")
    var password: String

    @Field(key: "email")
    var email: String

    @OptionalField(key: "profilePicture")
    var profilePicture: String?

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        username: String,
        password: String,
        email: String,
        profilePicture: String? = nil
    ) {
        self.name = name
        self.username = username
        self.password = password
        self.email = email
        self.profilePicture = profilePicture
    }

    final class Public: Content {
        var id: UUID?
        var name: String
        var username: String

        init(id: UUID? = nil, name: String, username: String) {
            self.id = id
            self.name = name
            self.username = username
        }
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension User {
    func convertToPublic() -> User.Public {
        User.Public(id: id, name: name, username: username)
    }
}

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        map {
            $0.convertToPublic()
        }
    }
}
