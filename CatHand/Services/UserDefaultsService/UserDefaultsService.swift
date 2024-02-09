//
//  UserDefaultsService.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 09.02.2024.
//

import Foundation

public final class UserDefaultsService {
    
    // MARK: - Keys
    
    private enum Keys {
        static let needShowInstagramSettings = "needShowInstagramSettings"
        static let userInfoInstagram = "userInfoInstagram"
        static let onboardingWasViewed = "onboardingWasViewed"
    }
    
    // MARK: - Public Properties

    public var needShowInstagramSettings: Bool? {
        get { return UserDefaults.standard.bool(forKey: Keys.needShowInstagramSettings) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.needShowInstagramSettings) }
    }
    
    public var userInfoInstagram: UserInfoInstagram? {
        get {
            return try? read(by: Keys.userInfoInstagram)
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: Keys.userInfoInstagram)
            }

            do {
                try write(value: newValue, by: Keys.userInfoInstagram)
            } catch {
                debugPrint("[WARN] error: \(error) while writing [CartResponseEntity] \(#function)")
            }
        }
    }
    
    public var onboardingWasViewed: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.onboardingWasViewed) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.onboardingWasViewed) }
    }

}


// MARK: - Private Helpers

private extension UserDefaultsService {
    
    func read<T: Decodable>(by key: String) throws -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        if let entity = try? PropertyListDecoder().decode(T.self, from: data) {
            return entity
        }
        return nil
    }

    func write<T: Encodable>(value: T, by key: String) throws {
        let data = try PropertyListEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: key)
    }
}

