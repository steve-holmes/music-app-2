//
//  CMTime+Valid.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import AVFoundation

extension CMTime {
    var isValid : Bool { return flags.contains(.valid) }
    var indefinite: Bool { return flags.contains(.indefinite) }
}
