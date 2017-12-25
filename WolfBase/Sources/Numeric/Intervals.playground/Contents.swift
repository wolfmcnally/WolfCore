import WolfBase

let i = 0 .. 1
print(i) // Interval(0.0 .. 1.0)

let j = -20 .. 5
print(j) // Interval(-20.0 .. 5.0)

let k = 0.0 .. 100.0
print(k) // Interval(0.0 .. 100.0)

let f: Frac = 0.5
let n = f.lerpedFromFrac(to: j)

print(n) // -7.5
print(n.lerpedToFrac(from: j)) // 0.5

let m = n.lerped(from: j, to: k)
print(m) // 50.0
