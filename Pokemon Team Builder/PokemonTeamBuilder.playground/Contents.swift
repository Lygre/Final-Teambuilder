import Cocoa


var range = ClosedRange.init(uncheckedBounds: (lower: 0.08, upper: 0.8))
range
print(range)
let rule = FloatingPointRoundingRule.toNearestOrAwayFromZero
var doubleValue = Decimal.init(0.62156843)
//doubleValue.rounded(rule)
//var roundedVal = String(format: "%.3f", doubleValue)
let scale = 2
var roundedValue = Decimal()
NSDecimalRound(&roundedValue, &doubleValue, scale, NSDecimalNumber.RoundingMode.plain)
roundedValue
roundedValue *= 100

