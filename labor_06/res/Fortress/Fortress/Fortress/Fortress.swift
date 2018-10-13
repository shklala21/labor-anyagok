import CoreLocation
import Foundation
import MobileCoreServices

enum EncodingError: Error {
  case invalidData
}

public let fortressBundle = Bundle(for: Fortress.self)
public let fortressTypeId = "hu.bme.aut.fortress"

public final class Fortress: NSObject, Codable {
  public let name: String

  let imageName: String
  public var image: UIImage? {
    return UIImage(named: imageName, in: fortressBundle, compatibleWith: nil)
  }

  public let shortDescription: String

  let latitude: Double
  let longitude: Double
  public var coordinates: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  init(name: String, imageName: String, shortDescription: String, longitude: Double, latitude: Double) {
    self.name = name
    self.imageName = imageName
    self.shortDescription = shortDescription
    self.longitude = longitude
    self.latitude = latitude
  }
}

extension Fortress: NSItemProviderWriting {
  // MARK: - NSItemProviderWriting
  public static var writableTypeIdentifiersForItemProvider: [String] {
    return [fortressTypeId, kUTTypeImage as String, kUTTypeText as String]
  }

  public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
    let progress = Progress(totalUnitCount: 100)
    switch typeIdentifier {
    case fortressTypeId:
      let data = try? JSONEncoder().encode(self)
      progress.completedUnitCount = 100
      completionHandler(data, nil)
    case String(kUTTypeImage) where image != nil:
      completionHandler(image!.pngData(), nil)
    case String(kUTTypeText):
      completionHandler(name.data(using: .utf8), nil)
    default:
      completionHandler(nil, EncodingError.invalidData)
    }
    return progress
  }
}

extension Fortress: NSItemProviderReading {
  // MARK: - NSItemProviderReading
  public static var readableTypeIdentifiersForItemProvider: [String] {
    return [fortressTypeId]
  }

  public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Fortress {
    guard typeIdentifier == fortressTypeId, let fortress = try? JSONDecoder().decode(Fortress.self, from: data) else {
      throw EncodingError.invalidData
    }
    return fortress
  }
}
