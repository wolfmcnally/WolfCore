//
// WolfPipe
//

// ComposeOperator.swift
precedencegroup ForwardCompositionPrecedence {
    associativity: left
    higherThan: ForwardApplicationPrecedence
}

precedencegroup BackwardsCompositionPrecedence {
    associativity: right
    higherThan: ForwardApplicationPrecedence
}

precedencegroup SingleTypeCompositionPrecedence {
    associativity: left
    higherThan: ForwardApplicationPrecedence
}

infix operator >>> : ForwardCompositionPrecedence
infix operator <<< : BackwardsCompositionPrecedence
infix operator <> : SingleTypeCompositionPrecedence

// EffectfulComposeOperator.swift
precedencegroup EffectfulCompositionPrecedence {
    associativity: left
    higherThan: ForwardApplicationPrecedence
}

infix operator >=> : EffectfulCompositionPrecedence

// PipeOperator.swift
precedencegroup ForwardApplicationPrecedence {
    associativity: left
    higherThan: BackwardApplicationPrecedence
}

precedencegroup BackwardApplicationPrecedence {
    associativity: right
    higherThan: ComparisonPrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator |> : ForwardApplicationPrecedence
infix operator <| : BackwardApplicationPrecedence

//
// WolfNesting
//

// NestingOperator.swift
precedencegroup NestingOperatorPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

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

// StringFloatPrecision.swift
precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

infix operator %% : AttributeAssignmentPrecedence

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
