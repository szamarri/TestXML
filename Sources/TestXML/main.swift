import Foundation
import XMLCoder

struct Comprobante: Codable {
  let emisor: Emisor
  let datoExtra: String = "Dimension=1"

  enum CodingKeys: String, CodingKey {
    case emisor
    case datoExtra
  }

/*  static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
    switch key {
      case Comprobante.CodingKeys.emisor:
        return .element
      default:
        return .attribute
    }
  }*/
}

struct Emisor: Codable {
  let rfc: String = "RFC435345232"
  let nombre: String = "Saul Zamarripa"

  enum CodingKeys: String, CodingKey {
    case rfc
    case nombre
  }

  static func nodeEncoding(forKey _: CodingKey) -> XMLEncoder.NodeEncoding {
    return .attribute
  }
}

let comprobanteXML = Comprobante(emisor: Emisor())

let encoder = XMLEncoder()

encoder.nodeEncodingStrategy = .custom { codableType, _ in
  guard let barType = codableType as? Emisor.Type else {
    return { _ in .default }
  }
  return barType.nodeEncoding(forKey:)
}
encoder.nodeEncodingStrategy = .custom { type, _ in
  { key in
      guard
        key.stringValue == Comprobante.CodingKeys.emisor.stringValue
      else {
        return .attribute
      }
      return .element
  }
}

let dataXML = try? encoder.encode(comprobanteXML, withRootKey: "Comprobante",
                                  header: XMLHeader(version: 1.0,
                                                    encoding: "UTF-8"))

let xml = String(data: dataXML!, encoding: .utf8)

print(xml!)

