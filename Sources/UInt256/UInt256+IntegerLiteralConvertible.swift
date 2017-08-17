//
//  UInt256+IntegerLiteralConvertible.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//
import Foundation
extension UInt256: ExpressibleByIntegerLiteral {
  
  public init(integerLiteral value: IntegerLiteralType) {
    
    let nvalue = UInt64(value)
    
    assert(nvalue >= 0, "Unsigned integer should be 0 or larger")
    assert(nvalue <= UInt64.max, "Value too large. Use a decimal string isntead.")
    
    if nvalue <= UInt64.max {
      self.init(nvalue)
    } else {
      fatalError("Something went wrong while creating a UInt256 from \(nvalue).")
    }
    
  }
}
