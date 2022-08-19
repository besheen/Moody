//
//  Utilities.swift
//  Moody
//
//  Created by Carl on 2022/8/15.
//

import Foundation

extension Sequence where Iterator.Element: AnyObject {
    func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}

extension Array {
    var decomposed: (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}
