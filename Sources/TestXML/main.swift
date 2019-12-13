import Foundation
import XMLCoder

struct Comprobante: Codable {
  let emisor: Emisor
  let receptor: Receptor
  let cfdi: String = "Dimension=1"
  let xsi: String = "Dimension=1"
  let schemalocation: String = "Dimension=1"
  let version: String = "3.3"
  let serie: String = "NCRD"
  let folio: String = "37467"
  let fecha: String = "2019-11-26"

  enum CodingKeys: String, CodingKey {
    case emisor = "cfdi:Emisor"
    case receptor = "cfdi:Eeceptor"
    case cfdi = "xmlns:cfdi"
    case xsi = "xmlns:xsi"
    case schemalocation = "xsi:SchemaLocation"
    case version
    case serie
    case folio
    case fecha
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
  let regimenfiscal: String = "601"

  enum CodingKeys: String, CodingKey {
    case rfc = "Rfc"
    case nombre = "Nombre"
    case regimenfiscal = "RegimenFiscal"
  }

  static func nodeEncoding(forKey _: CodingKey) -> XMLEncoder.NodeEncoding {
    return .attribute
  }
}

struct Receptor: Codable {
  let rfc: String = "SIN NUMERO"
  let nombre: String = " "
  let usocfdi: String = " "

  enum CodingKeys: String, CodingKey {
    case rfc = "Rfc"
    case nombre = "Nombre"
    case usocfdi = "UsoCFDI"
  }

  static func nodeEncoding(forKey _: CodingKey) -> XMLEncoder.NodeEncoding {
    return .attribute
  }
}

let comprobanteXML = Comprobante(emisor: Emisor(), receptor: Receptor())

let encoder = XMLEncoder()

encoder.nodeEncodingStrategy = .custom { codableType, _ in
  guard let barType = codableType as? Emisor.Type else {
    return { _ in .default }
  }
  return barType.nodeEncoding(forKey:)
}
encoder.nodeEncodingStrategy = .custom { codableType, _ in
  guard let barType = codableType as? Receptor.Type else {
    return { _ in .default }
  }
  return barType.nodeEncoding(forKey:)
}

encoder.nodeEncodingStrategy = .custom { type, _ in
  { key in
      guard
        key.stringValue == Comprobante.CodingKeys.emisor.stringValue ||
        key.stringValue == Comprobante.CodingKeys.receptor.stringValue
      else {
        return .attribute
      }
      return .element
  }
}

let dataXML = try? encoder.encode(comprobanteXML, withRootKey: "cfdi:Comprobante",
                                  header: XMLHeader(version: 1.0,
                                                    encoding: "UTF-8"))

let xml = String(data: dataXML!, encoding: .utf8)

print(xml!)
