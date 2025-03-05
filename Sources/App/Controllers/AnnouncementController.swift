//
//  AnnouncementController.swift.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//

import Vapor

struct AnnouncementController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let announcement = routes.grouped("api", "announcements")
        announcement.get(use: fetchAnnouncements) // ✅ Registers `GET /api/announcements`
    }

    /// ✅ Fetches announcements with automatic error handling
    @Sendable
    func fetchAnnouncements(req: Request) async throws -> APIResponse<[Announcement]> {
        let fileURL = req.application.directory.resourcesDirectory.appending("Data/announcements.json")

        do {
            // ✅ Read JSON file from Resources/Data directory
            let data = try Data(contentsOf: URL(fileURLWithPath: fileURL))
            let announcements = try JSONDecoder().decode([Announcement].self, from: data)

            return APIResponse(success: true, message: "Announcements retrieved successfully", data: announcements)
        } catch {
            // ✅ Use `APIErrorResponse.fromError(error)` to handle all errors automatically
            throw Abort(.notFound, reason: APIErrorResponse.fromError(error).message)
        }
    }
}
