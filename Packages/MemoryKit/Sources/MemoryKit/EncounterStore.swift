import Foundation
import SharedModels

/// Protocol for encounter persistence backends.
public protocol EncounterStoreProtocol {
    func save(_ encounter: Encounter) async throws
    func fetchAll() async throws -> [Encounter]
    func fetchRecent(limit: Int) async throws -> [Encounter]
    func fetch(id: UUID) async throws -> Encounter?
    func update(_ encounter: Encounter) async throws
    func delete(id: UUID) async throws
    func encounterCount(for surface: String) async throws -> Int
}

/// In-memory encounter store for development and testing.
/// Production will use SwiftData or CoreData.
public actor InMemoryEncounterStore: EncounterStoreProtocol {
    private var encounters: [UUID: Encounter] = [:]

    public init() {}

    public func save(_ encounter: Encounter) async throws {
        encounters[encounter.id] = encounter
    }

    public func fetchAll() async throws -> [Encounter] {
        encounters.values
            .sorted { $0.timestamp > $1.timestamp }
    }

    public func fetchRecent(limit: Int) async throws -> [Encounter] {
        Array(
            encounters.values
                .sorted { $0.timestamp > $1.timestamp }
                .prefix(limit)
        )
    }

    public func fetch(id: UUID) async throws -> Encounter? {
        encounters[id]
    }

    public func update(_ encounter: Encounter) async throws {
        encounters[encounter.id] = encounter
    }

    public func delete(id: UUID) async throws {
        encounters.removeValue(forKey: id)
    }

    public func encounterCount(for surface: String) async throws -> Int {
        encounters.values.filter { encounter in
            encounter.textRegion.tokens.contains { $0.surface == surface }
        }.count
    }
}
