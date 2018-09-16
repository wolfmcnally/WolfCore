//
//  Time.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/10/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

public let nanosecondsPerSecond = 1_000_000_000.0
public let millisecondsPerSecond = 1_000.0
public let oneSecond: TimeInterval = 1.0

public let oneMinute: TimeInterval = 60 * oneSecond
public let minutesPerHour = 60.0
public let oneHour: TimeInterval = oneMinute * minutesPerHour
public let hoursPerDay = 24.0
public let minutesPerDay = minutesPerHour * hoursPerDay
public let oneDay: TimeInterval = oneMinute * minutesPerDay
public let daysPerWeek = 7.0
