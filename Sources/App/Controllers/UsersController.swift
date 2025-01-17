import Vapor

struct UsersController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")

        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = usersRoute.grouped(
            tokenAuthMiddleware,
            guardAuthMiddleware
        )
        tokenAuthGroup.post(use: createHandler)
        tokenAuthGroup.get(use: getAllHandler)
        tokenAuthGroup.post(use: createHandler)
        tokenAuthGroup.get(":id", use: getHandler)
    }

    @Sendable
    func createHandler(_ req: Request) async throws -> User.Public {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)

        return user.convertToPublic()
    }

    @Sendable
    func getAllHandler(_ req: Request) async throws -> [User.Public] {
        try await User.query(on: req.db).all().convertToPublic()
    }

    @Sendable
    func getHandler(_ req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        return user.convertToPublic()
    }

    @Sendable
    func loginHandler(_ req: Request) async throws -> Token {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        try await token.save(on: req.db)
        return token
    }
}
