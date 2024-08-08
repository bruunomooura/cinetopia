//
//  String+Extensions.swift
//  Cinetopia
//
//  Created by Bruno Moura on 04/07/24.
//

import Foundation

extension String {
    func toBrazilianDateFormat() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
          
          if let date = dateFormatter.date(from: self) {
              dateFormatter.dateFormat = "dd/MM/yyyy"
              dateFormatter.locale = Locale(identifier: "pt_BR")
              return dateFormatter.string(from: date)
          }
        return self // Returns the original string if conversion fails
    }
    
    // MARK: Dynamic Variables
    /// Just calling this variable to any string you can obtain its localized version.
    /// Arguments can be applied using the same SwiftUI Text() format:
    ///     "key \(argument)".localized
    var localized: String {
        if let index = self.firstIndex(of: " ") {
            let key = self.prefix(upTo: index)
            var parameter = self.suffix(from: index)
            parameter.removeFirst()
            return String(format: NSLocalizedString("\(key) %@", comment: ""), String(parameter))
        } else {
            return String(localized: LocalizationValue(self))
        }
    }
}
