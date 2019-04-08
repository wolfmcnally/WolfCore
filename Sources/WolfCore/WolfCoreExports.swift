@_exported import WolfNesting
@_exported import WolfNumerics
@_exported import WolfOSBridge
@_exported import WolfPipe
@_exported import ExtensibleEnumeratedName
@_exported import WolfStrings
@_exported import WolfWith
@_exported import WolfFoundation

//
// WolfPipe
//

// ComposeOperator.swift
infix operator >>> : ForwardCompositionPrecedence
infix operator <<< : BackwardsCompositionPrecedence
infix operator <> : SingleTypeCompositionPrecedence

// EffectfulComposeOperator.swift
infix operator >=> : EffectfulCompositionPrecedence

// PipeOperator.swift
infix operator |> : ForwardApplicationPrecedence
infix operator <| : BackwardApplicationPrecedence

//
// WolfNesting
//

// NestingOperator.swift
infix operator => : NestingOperatorPrecedence

//
// WolfWith
//

// WithOperator.swift
infix operator • : CastingPrecedence
infix operator •• : CastingPrecedence
infix operator ••• : CastingPrecedence

//
// WolfStrings
//

// AttributedStringOperator.swift
postfix operator §
postfix operator §?

// CreateRegularExpressionOperator.swift
prefix operator ~/

// MatchRegularExpressionOperator.swift
infix operator ~?
infix operator ~??

//
// WolfFoundation
//

// InheritsFromOperator.swift
infix operator <- : ComparisonPrecedence

// InvalidateAndAssignOperator.swift
infix operator ◊= : AssignmentPrecedence

// ReferenceOperator.swift
postfix operator ®

// TweakOperator.swift
prefix operator ‡

//
// WolfNumerics
//

// ApproximatelyEqualsOperator.swift
infix operator ≈ : ComparisonPrecedence
infix operator !≈ : ComparisonPrecedence

// IntervalCreationOperator.swift
infix operator .. : RangeFormationPrecedence

// PercentOperator.swift
postfix operator %
