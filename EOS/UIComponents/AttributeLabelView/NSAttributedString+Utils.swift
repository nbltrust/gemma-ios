//
//  Created by Pavel Sharanda on 21.02.17.
//  Copyright © 2017 psharanda. All rights reserved.
//

import Foundation

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let str = NSMutableAttributedString(attributedString: lhs)
    str.append(rhs)
    return str
}

public func + (lhs: String, rhs: NSAttributedString) -> NSAttributedString {
    let str = NSMutableAttributedString(string: lhs)
    str.append(rhs)
    return str
}

public func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
    let str = NSMutableAttributedString(attributedString: lhs)
    str.append(NSAttributedString(string: rhs))
    return str
}
