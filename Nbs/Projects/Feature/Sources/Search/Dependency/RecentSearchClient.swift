//
//  RecentSearchClient.swift
//  Feature
//
//  Created by 여성일 on 10/19/25.
//

import Foundation

import ComposableArchitecture

struct RecentSearchStatic {
  static let maxCount = 6
  static let userDefaultsKey = "recentSearches"
}

@DependencyClient
struct RecentSearchClient {
  var add: @Sendable (String) async throws -> [String]
  var remove: @Sendable (String) async throws -> [String]
  var clear: @Sendable () async throws -> [String]
  var load: @Sendable () async throws -> [String]
}

extension DependencyValues {
  var recentSearchClient: RecentSearchClient {
    get { self[RecentSearchClient.self] }
    set { self[RecentSearchClient.self] = newValue }
  }
}

extension RecentSearchClient: DependencyKey {
  static let liveValue: Self = {
    let maxCount = 6
    let userDefaultsKey = "recentSearches"
    
    return Self(
      add: { searchTerm in
        guard !searchTerm.trimmingCharacters(in: .whitespaces).isEmpty else {
          return UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        }
        
        var searches = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        
        if let index = searches.firstIndex(of: searchTerm) {
          searches.remove(at: index)
        }
        
        searches.insert(searchTerm, at: 0)
        searches = Array(searches.prefix(maxCount))
        
        UserDefaults.standard.set(searches, forKey: userDefaultsKey)
        return searches
      },
      remove: { searchTerm in
        var searches = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        
        if let index = searches.firstIndex(of: searchTerm) {
          searches.remove(at: index)
        }
        
        UserDefaults.standard.set(searches, forKey: userDefaultsKey)
        return searches
      },
      clear: {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        return []
      },
      load: {
        return UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
      }
    )
  }()
}
