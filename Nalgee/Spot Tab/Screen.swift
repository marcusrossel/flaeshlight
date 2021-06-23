//
//  Screen.swift
//  Nalgee
//
//  Created by Marcus Rossel on 18.06.21.
//

import SwiftUI

enum Screen {
    
    private static var currentPPI: Double? {
        #if targetEnvironment(simulator)
        326
        #else
        switch UIDevice.modelName {
        case /* Touch 7th Gen.*/     "iPod9,1":                  return 326
        case /* iPhone 6s */         "iPhone8,1":                return 326
        case /* iPhone 6s Plus */    "iPhone8,2":                return 401
        case /* iPhone SE 1 */       "iPhone8,4":                return 326
        case /* iPhone 7 */          "iPhone9,1", "iPhone9,3":   return 326
        case /* iPhone 7 Plus */     "iPhone9,2", "iPhone9,4":   return 401
        case /* iPhone 8 */          "iPhone10,1", "iPhone10,4": return 326
        case /* iPhone 8 Plus */     "iPhone10,2", "iPhone10,5": return 401
        case /* iPhone X */          "iPhone10,3", "iPhone10,6": return 458
        case /* iPhone XR */         "iPhone11,8":               return 326
        case /* iPhone XS */         "iPhone11,2":               return 458
        case /* iPhone XS Max */     "iPhone11,4", "iPhone11,6": return 458
        case /* iPhone 11 */         "iPhone12,1":               return 326
        case /* iPhone 11 Pro */     "iPhone12,3":               return 458
        case /* iPhone 11 Pro Max */ "iPhone12,5":               return 458
        case /* iPhone SE 2 */       "iPhone12,8":               return 326
        case /* iPhone 12 mini */    "iPhone13,1":               return 476
        case /* iPhone 12 */         "iPhone13,2":               return 460
        case /* iPhone 12 Pro */     "iPhone13,3":               return 460
        case /* iPhone 12 Pro Max */ "iPhone13,4":               return 458
        default:                                                 return nil
        }
        #endif
    }
    
    static func points(for length: Measurement<UnitLength>) -> Double? {
        guard let ppi = currentPPI else { return nil }
        let pixels = ppi * length.converted(to: .inches).value
        return pixels / Double(UIScreen.main.scale)
    }
}

extension UIDevice {
    
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return  machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}
