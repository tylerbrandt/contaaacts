import CryptoKit
import Foundation

// MARK: - ChaChaCoder

let SEKRIT_KEY = "9da3569571f43b05a97a879e4230a3c47cf0a8a8bb4621abe9d569b00b3ad01f"

public struct ChaChaCoder {
  public static let `default` = ChaChaCoder(key: .init(hexString: SEKRIT_KEY))

  private let key: SymmetricKey

  public func encrypt(_ data: Data) throws -> Data {
    let sealedBox = try ChaChaPoly.seal(data, using: key)
    return sealedBox.combined
  }

  public func decrypt(_ data: Data) throws -> Data {
    let sealedBox = try ChaChaPoly.SealedBox(combined: data)
    return try ChaChaPoly.open(sealedBox, using: key)
  }
}

extension SymmetricKey {
  fileprivate init(hexString: String) {
    let keyData = Data(hexString: hexString)!
    self = SymmetricKey(data: keyData)
  }
}

extension Data {

  /// Create `Data` from a hexadecimal string representation.
  ///
  /// Adopted from https://gist.github.com/nicklockwood/81b9f122f3db9e7132be7bd61d0c0cea
  public init?(hexString: String) {
    guard hexString.count % 2 == 0 else {
      assertionFailure("Hex strings must have an even length to be properly converted to data.")
      return nil
    }
    let count = hexString.count / 2
    var data = Data(capacity: count)
    var i = hexString.startIndex
    for _ in 0 ..< count {
      let j = hexString.index(after: i)
      if var byte = UInt8(hexString[i ... j], radix: 16) {
        data.append(&byte, count: 1)
      } else {
        return nil
      }
      i = hexString.index(after: j)
    }
    self = data
  }

}
