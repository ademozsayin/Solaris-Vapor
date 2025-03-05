//
//  Announcement.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


import Vapor

/// ✅ Model representing an announcement
struct Announcement: Content, Decodable {
    let id: String
    let startDate: Int64?
    let endDate: Int64?
    let title: String?
    let message: String?
    let isActive: Bool?
    let priority: Int?
    let orderNo: Int?
    let isExpanded: Bool?
    let isPinned: Bool?
    let showSlider: Bool?
    let sliderImageUrl: String?
    let webSliderImageUrl: String?
    let iosSliderImageUrl: String?
    let htmlContent: String?
    let type: Int?
    let routeContent: RouteContent?
    let sliderClientType: String?
    let showForDemoAccount: Bool?
    let sliderClientTypeDesc: String?
}

/// ✅ Model representing route content inside Announcement
struct RouteContent: Content, Decodable {
    let targetAsset: String?
    let collateralAsset: String?
    let announcementHeader: String?
    let announcementDetail: String?
    let announcementId: Int?
    let competitionId: String?
    let competitionSlug: String?
    let preSaleSlug: String?
}
