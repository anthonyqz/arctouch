//
//  Extensions.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import Foundation

extension NSDate {
    
    func toString(dateStyle:DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        return formatter.string(from: self as Date)
    }
    
}
