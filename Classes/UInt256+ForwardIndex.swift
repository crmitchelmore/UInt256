//
//  UInt256+ForwardIndex.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.

// Preliminary implementation to conform to UnsignedInteger. Unused and untested.

// Conforming to ForwardIndex results in a duplicate symbol error.
extension UInt256 { //: ForwardIndex {
    func succ() -> UInt256 {
        return self + UInt256(1)
    }
    func pred() -> UInt256 {
        return self + UInt256(1)
    }
}