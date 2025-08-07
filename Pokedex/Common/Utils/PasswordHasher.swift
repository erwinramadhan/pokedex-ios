//
//  PasswordHasher.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 06/08/25.
//

import Foundation
import Sodium

final class PasswordHasher {
    private let sodium = Sodium()
    private let hashLength = 64
    private let saltLength = Sodium().pwHash.SaltBytes
    private let opsLimit = Sodium().pwHash.OpsLimitInteractive
    private let memLimit = Sodium().pwHash.MemLimitInteractive
    private let algorithm = PWHash.Alg.Argon2ID13

    /// Hash password and return base64 string (salt + hash)
    func hash(password: String) -> String? {
        guard let salt = sodium.randomBytes.buf(length: saltLength) else {
            return nil
        }

        guard let hash = sodium.pwHash.hash(
            outputLength: hashLength,
            passwd: Array(password.utf8),
            salt: salt,
            opsLimit: opsLimit,
            memLimit: memLimit,
            alg: algorithm
        ) else {
            return nil
        }

        let combined = Data(salt + hash).base64EncodedString()
        return combined
    }

    /// Verify password from base64 encoded hash that already stored
    func verify(password: String, storedHash: String) -> Bool {
        guard let combinedData = Data(base64Encoded: storedHash) else {
            return false
        }

        let salt = Array(combinedData.prefix(saltLength))
        let originalHash = Array(combinedData.dropFirst(saltLength))

        guard let newHash = sodium.pwHash.hash(
            outputLength: originalHash.count,
            passwd: Array(password.utf8),
            salt: salt,
            opsLimit: opsLimit,
            memLimit: memLimit,
            alg: algorithm
        ) else {
            return false
        }

        return newHash == originalHash
    }
}
