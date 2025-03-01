//
//  Created by Brett Clifton on 10/23/23.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import CoreTelephony
import UIKit

class DeviceInfoExtractor {
    private let screenSize = UIScreen.main.bounds
    
    private func generateUdid() -> String {
        return NSUUID().uuidString.replacingOccurrences(of: "_", with: "")
    }
    
    private func getUdid(customId: String = "") -> String {
        let AA_UUID_KEY = "adadapted_swift_sdk_uuid"
        let preferences = UserDefaults.standard
        var id = ""
        
        if (!customId.isEmpty) {
            id = customId
            preferences.setValue(id, forKey: AA_UUID_KEY)
        } else if (preferences.object(forKey: AA_UUID_KEY) == nil) {
            id = generateUdid()
            preferences.setValue(id, forKey: AA_UUID_KEY)
        } else {
            id = preferences.value(forKey: AA_UUID_KEY) as? String ?? ""
        }
        return id
    }
    
    func width() -> Int { Int(CGRectGetWidth(self.screenSize)) }
    func height() -> Int { Int(CGRectGetHeight(self.screenSize)) }
    
    func extractDeviceInfo(appId: String, isProd: Bool, customIdentifier: String, params: Dictionary<String, String>) -> DeviceInfo {
        if #available(iOS 16.0, *) {
            return DeviceInfo(
                appId: appId,
                isProd: isProd,
                customIdentifier: customIdentifier,
                scale: Float(UIScreen.main.scale),
                bundleId: Bundle.main.bundleIdentifier ?? "",
                bundleVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
                udid: getUdid(customId: customIdentifier),
                deviceName: UIDevice.current.localizedModel,
                deviceUdid: getUdid(customId: customIdentifier),
                os: "iOS",
                osv: UIDevice.current.systemVersion,
                locale: NSLocale.current.region?.identifier ?? "",
                timezone: TimeZone.current.abbreviation() ?? "",
                carrier: CTTelephonyNetworkInfo().dataServiceIdentifier ?? "Unknown",
                dw: width(),
                dh: height(),
                density: "\(UIScreen.main.scale)",
                isAllowRetargetingEnabled: false,
                sdkVersion: Config.LIBRARY_VERSION,
                createdAt: Int(NSDate().timeIntervalSince1970),
                params: params)
        } else {
            // Fallback on earlier versions
            return DeviceInfo(
                appId: appId,
                isProd: isProd,
                customIdentifier: customIdentifier,
                scale: Float(UIScreen.main.scale),
                bundleId: Bundle.main.bundleIdentifier ?? "",
                bundleVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
                udid: getUdid(customId: customIdentifier),
                deviceName: UIDevice.current.localizedModel,
                deviceUdid: getUdid(customId: customIdentifier),
                os: "iOS",
                osv: UIDevice.current.systemVersion,
                locale: NSLocale.current.regionCode ?? "",
                timezone: TimeZone.current.abbreviation() ?? "",
                carrier: CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.filter({ $0.value.carrierName != nil }).first?.value.carrierName ?? "",
                dw: width(),
                dh: height(),
                density: "\(UIScreen.main.scale)",
                isAllowRetargetingEnabled: false,
                sdkVersion: Config.LIBRARY_VERSION,
                createdAt: Int(NSDate().timeIntervalSince1970),
                params: params)
        }
    }
}
