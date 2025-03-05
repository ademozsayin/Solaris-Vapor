//
//  APIResponse.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


import Vapor

/// ✅ Generic response model for API success & error handling
struct APIResponse<T: Content>: Content {
    let success: Bool
    let message: String
    let data: T?

    init(success: Bool, message: String, data: T? = nil) {
        self.success = success
        self.message = message
        self.data = data
    }
}

/// ✅ Generic error response model
/// ✅ Standardized error response for API errors
struct APIErrorResponse: Content {
    let success: Bool
    let code: Int
    let message: String

    /// ✅ Initialize with a specific error code & message
    init(code: HTTPResponseStatus, message: String) {
        self.success = false
        self.code = Int(code.code) // Automatically get status code
        self.message = message
    }

    /// ✅ Automatically converts `AbortError` to `APIErrorResponse`
    static func fromError(_ error: Error) -> APIErrorResponse {
        if let abortError = error as? AbortError {
            return APIErrorResponse(code: abortError.status, message: abortError.reason)
        } else {
            return APIErrorResponse(code: .internalServerError, message: "An unexpected error occurred.")
        }
    }
}
