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
}
