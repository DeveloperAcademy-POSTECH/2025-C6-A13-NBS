//
//  AppVersionCheck.swift
//  Nbs
//
//  Created by 홍 on 11/20/25.
//

import UIKit

enum VersionError: Error {
  case invalidResponse, invalidBundleInfo
}

final class AppVersionCheck {
  
  static let shared = AppVersionCheck()
  private init() { }
  
  static func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
    guard let info = Bundle.main.infoDictionary,
          let currentVersion = info["CFBundleShortVersionString"] as? String,
          let identifier = info["CFBundleIdentifier"] as? String,
          let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)")
    else {
      throw VersionError.invalidBundleInfo
    }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      do {
        if let error = error { throw error }
        guard let data = data else { throw VersionError.invalidResponse }
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
        guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
          throw VersionError.invalidResponse
        }
        let needUpdate = currentVersion.compare(version,options: .numeric) == .orderedAscending
        completion(needUpdate, nil)
      } catch {
        completion(nil, error)
      }
    }
    task.resume()
    return task
  }
  
  static func appUpdate() {
    let appId = "6754357960"
    DispatchQueue.main.async {
      if let url = URL(string: "https://apps.apple.com/kr/app/\(appId)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(url, options: [:], completionHandler: {_ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              exit(0)
            }
          })
        } else {
          UIApplication.shared.openURL(url)
        }
      }
    }
  }
}
