//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

import Foundation
import CUInt256

public struct UInt256: CustomStringConvertible { // : UnsignedInteger
    /*
     UnsignedInteger consists of a whole bunch of protocols. I implemented all that I could find, even if not always correctly.
     */

    // Store as an array with the most significant value first:
    // var value: [UInt32]

    // Use 8 vars instead; This should make elliptic curve math at least 20x faster.
    var part0: UInt32 // Most significant
    var part1: UInt32
    var part2: UInt32
    var part3: UInt32
    var part4: UInt32
    var part5: UInt32
    var part6: UInt32
    var part7: UInt32

    subscript(index: Int) -> UInt32 {
        get {
            switch index {
            case 0:
                return part0
            case 1:
                return part1
            case 2:
                return part2
            case 3:
                return part3
            case 4:
                return part4
            case 5:
                return part5
            case 6:
                return part6
            case 7:
                return part7
            default:
                assert(false, "Invalid index")
                return 0
            }
        }

        mutating set(newValue) {
            assert(index < 8, "Invalid index")

            switch index {
            case 0:
                part0 = newValue
            case 1:
                part1 = newValue
            case 2:
                part2 = newValue
            case 3:
                part3 = newValue
            case 4:
                part4 = newValue
            case 5:
                part5 = newValue
            case 6:
                part6 = newValue
            case 7:
                part7 = newValue
            default:
                assert(false, "Invalid index")
            }
        }
    }

    public init(_ part0: UInt32, _ part1: UInt32, _ part2: UInt32, _ part3: UInt32, _ part4: UInt32, _ part5: UInt32, _ part6: UInt32, _ part7: UInt32) {
        self.part0 = part0
        self.part1 = part1
        self.part2 = part2
        self.part3 = part3
        self.part4 = part4
        self.part5 = part5
        self.part6 = part6
        self.part7 = part7
    }

    public init() {
        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = 0
        self.part7 = 0
    }

    public init(_ value: UInt32) {
        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = 0
        self.part7 = UInt32(value)
    }

    public init(_ value: Int64) {
        let uvalue = UInt64(value)
        let leftDigit: UInt32 = UInt32(uvalue >> 32)
        let rightDigit: UInt32 = UInt32((uvalue << 32) >> 32)

        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = leftDigit
        self.part7 = rightDigit
    }

    public init(_ value: UInt64) {
        let leftDigit: UInt32 = UInt32(value >> 32)
        let rightDigit: UInt32 = UInt32((value << 32) >> 32)

        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = leftDigit
        self.part7 = rightDigit
    }

    public init(_ value: Int) {
        let uvalue = UInt64(value)
        let leftDigit: UInt32 = UInt32(uvalue >> 32)
        let rightDigit: UInt32 = UInt32((uvalue << 32) >> 32)

        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = leftDigit
        self.part7 = rightDigit
    }

    public init(hexString: String) {
        var hexString = hexString

        // First we perform some sanity checks on the string. Then we chop it in 8 pieces and convert each to a UInt32.
        assert(hexString.characters.count > 0, "Can't be empty")

        // Assert if string isn't too long
        assert(hexString.characters.count <= 64, "Too large")

        hexString = hexString.uppercased()

        // Assert if string has any characters that are not 0-9 or A-F
        for character in hexString.characters {
            switch character {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
        }

        // Pad zeros
        if hexString.characters.count < 64 {
            for _ in 1 ... (64 - hexString.characters.count) {
                hexString = "0" + hexString
            }
        }

        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = 0
        self.part7 = 0

        var i = 0

        for char in hexString.characters {
            var increment: UInt32 = 0

            switch char {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                let stringChar: String = "\(char)"
                increment = UInt32(Int(stringChar)!)
            case "A":
                increment = 10
            case "B":
                increment = 11
            case "C":
                increment = 12
            case "D":
                increment = 13
            case "E":
                increment = 14
            case "F":
                increment = 15
            default:
                assert(false, "Unexpected digit")
            }

            let incrementor: UInt32 = 16 ^^ (7 - (UInt32(i) % 8))
            increment = increment * incrementor

            switch i {
            case 0 ..< 8:
                self.part0 += UInt32(increment)
            case 8 ..< 16:
                self.part1 += increment
            case 16 ..< 24:
                self.part2 += increment
            case 24 ..< 32:
                self.part3 += increment
            case 32 ..< 40:
                self.part4 += increment
            case 40 ..< 48:
                self.part5 += increment
            case 48 ..< 56:
                self.part6 += increment
            case 56 ..< 64:
                self.part7 += increment
            default:
                break
            }

            i += 1
        }
    }

    public init(decimalString: String) {
        // First we perform some sanity checks on the string. Then we convert it to a hex string.

        assert(decimalString.characters.count > 0, "Can't be empty")

        // Assert if string longer than 78 characters
        assert(decimalString.characters.count <= 78, "Too large")

        // Assert if string has any characters that are not 0-9
        for character in decimalString.characters {
            switch character {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
        }

        // Pad zeros
        var paddedDecimalString = decimalString

        if decimalString.characters.count < 78 {
            for _ in 1 ... (78 - decimalString.characters.count) {
                paddedDecimalString = "0" + paddedDecimalString
            }
        }

        assert(paddedDecimalString <= "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Too large")

        var hexString: String = BaseConverter.decToHex(decimalString)

        if hexString == "" {
            hexString = "0"
        }

        self.init(hexString: hexString)
    }

    public static var allZeros: UInt256 {
        return UInt256(0, 0, 0, 0, 0, 0, 0, 0)
    }

    public static var max: UInt256 {
        return UInt256(UInt32.max, UInt32.max, UInt32.max, UInt32.max, UInt32.max, UInt32.max, UInt32.max, UInt32.max)
    }

    public static var min: UInt256 {
        return UInt256.allZeros
    }

    public static func secureRandom(_ max: UInt256) -> UInt256 {
        while (true) {
            let candidate = UInt256(arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max), arc4random_uniform(UInt32.max))

            if candidate < max {
                return candidate
            }
        }
    }

    // TODO: double check value
    public var toData: Data {
        let val: [UInt32] = [part0.bigEndian, part1.bigEndian, part2.bigEndian, part3.bigEndian, part4.bigEndian, part5.bigEndian, part6.bigEndian, part7.bigEndian]
        let point = UnsafePointer<UInt32>(val)
        return Data(bytes: point, count: 32)
    }
}
