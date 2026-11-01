// Shared pastel-watercolor helpers for the figures in this folder: soft
// washes on speckled paper with pencil flows. Imported by the fig-*.typ files.
#let paper = rgb("#fbf8f2")
#let ink   = rgb("#3f3a44")
#let lead  = rgb("#6d6a74")
#let rose  = rgb("#f2a3b6")
#let lilac = rgb("#b7a4ee")
#let mint  = rgb("#93d8bf")
#let butter = rgb("#f3cf86")

#let at(x, y, body) = place(top + left, dx: x, dy: y, body)
#let centered(x, y, w, body) = at(x - w / 2, y, block(width: w, align(center, body)))
#let rnd(i) = calc.abs(calc.fract(calc.sin(i * 12.9898) * 43758.5453))
#let mono(s, size: 5.6pt) = box(text(font: "DejaVu Sans Mono", size: size, s))

// Watercolor blob: faint layers of a noisy ellipse, a darker wet edge on the
// outermost pool, and a sprinkle of granulation on top.
#let blob(cx, cy, rx, ry, c, seed, layers: 18, alpha: 93%, grains: 80) = {
  for l in range(layers) {
    let s = seed * 17 + l * 101
    let sc = if l < 2 { 1.0 - l * 0.03 } else { 0.55 + 0.42 * rnd(s + 999) }
    let ox = (rnd(s + 1) - 0.5) * rx * 0.14
    let oy = (rnd(s + 2) - 0.5) * ry * 0.14
    let pts = range(120).map(i => {
      let a = i * 3deg
      let f = 1.0
      for k in range(2, 7) {
        f += 0.15 / k * (rnd(s + k) - 0.5) * 2 * calc.sin(k * a + rnd(s + k + 50) * 360deg)
      }
      for k in range(11, 19) {
        f += 0.014 * (rnd(s + k) - 0.5) * 2 * calc.sin(k * a + rnd(s + k + 70) * 360deg)
      }
      (cx + ox + rx * sc * f * calc.cos(a), cy + oy + ry * sc * f * calc.sin(a))
    })
    let edge = if l == 0 { (paint: c.darken(22%).transparentize(62%), thickness: 0.5pt) } else { none }
    at(0mm, 0mm, polygon(fill: c.transparentize(alpha), stroke: edge, ..pts))
  }
  for g in range(grains) {
    let a = rnd(seed * 7 + g) * 360deg
    let r = calc.sqrt(rnd(seed * 11 + g)) * 0.85
    at(cx + rx * r * calc.cos(a), cy + ry * r * calc.sin(a),
      circle(radius: 0.06mm + rnd(seed + g) * 0.14mm, fill: c.darken(30%).transparentize(70%), stroke: none))
  }
}

#let speckle(n, W, H) = for i in range(n) {
  at(rnd(i + 3000) * W, rnd(i + 7000) * H, circle(radius: 0.06mm + rnd(i + 11) * 0.1mm,
    fill: lead.transparentize(82% + rnd(i) * 12%), stroke: none))
}

// Pencil line: two slightly offset strokes, plus a chevron when dir is not 0.
#let pencil(x0, x1, y, dir) = {
  for (dy, t) in ((0mm, 15%), (0.25mm, 70%)) {
    at(0mm, 0mm, line(start: (x0, y + dy), end: (x1, y + dy * 0.4), stroke: (paint: lead.transparentize(t), thickness: 0.5pt, cap: "round")))
  }
  if dir != 0 {
    let tip = if dir > 0 { x1 } else { x0 }
    for s in (1, -1) {
      at(0mm, 0mm, line(start: (tip, y), end: (tip - dir * 2mm, y + s * 1.2mm), stroke: (paint: lead, thickness: 0.5pt, cap: "round")))
    }
  }
}

// Pencil rectangle: each side drawn twice with a small wobble.
#let pencil-box(x, y, w, h, seed) = {
  let j(i) = (rnd(seed * 31 + i) - 0.5) * 0.3mm
  let sides = (((x, y), (x + w, y)), ((x + w, y), (x + w, y + h)),
               ((x + w, y + h), (x, y + h)), ((x, y + h), (x, y)))
  for (n, (a, b)) in sides.enumerate() {
    for (k, t) in ((0, 10%), (1, 68%)) {
      let o = j(n * 4 + k)
      at(0mm, 0mm, line(start: (a.at(0) + o, a.at(1) + o), end: (b.at(0) - o, b.at(1) + o),
        stroke: (paint: lead.transparentize(t), thickness: 0.5pt, cap: "round")))
    }
  }
}

#let dotted(a, b) = at(0mm, 0mm, line(start: a, end: b,
  stroke: (paint: lead.transparentize(20%), thickness: 0.35pt, dash: "dotted")))
