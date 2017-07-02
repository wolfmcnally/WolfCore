//
//  SkinValue.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

public protocol SkinValue: Interpolable, Equatable {
}

extension Bool: SkinValue {
  public func interpolated(to other: Bool, at frac: Frac) -> Bool {
    return frac.ledge(self, other)
  }
}

extension Color: SkinValue {
  public func interpolated(to other: Color, at frac: Frac) -> Color {
    return blend(from: self, to: other, at: frac)
  }
}

extension String: SkinValue {
  public func interpolated(to other: String, at frac: Frac) -> String {
    return frac.ledge(self, other)
  }
}

extension FontStyle: SkinValue {
  public func interpolated(to other: FontStyle, at frac: Frac) -> FontStyle {
    return frac.ledge(self, other)
  }
}
