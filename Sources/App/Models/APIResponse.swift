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
struct APIErrorResponse: Content {
    let success: Bool
    let error: String

    init(_ error: String) {
        self.success = false
        self.error = error
    }
}
