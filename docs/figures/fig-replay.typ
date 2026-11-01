// Capture a point in one box, replay it in a box of another size: the
// fraction carries over, the pixels are recomputed. Pastel watercolor style.
#import "_wash.typ": *
#let W = 184mm
#let H = 88mm
#set page(width: W, height: H, margin: 0mm, fill: paper)
#set text(font: "C059", size: 7pt, fill: ink)

#speckle(700, W, H)

#let FX = 0.62
#let FY = 0.35
// captured box (4:3) and replay box (16:9)
#let A = (x: 16mm, y: 30mm, w: 44mm, h: 33mm)
#let B = (x: 110mm, y: 28.5mm, w: 60mm, h: 33.75mm)

#blob(A.x + A.w / 2, A.y + A.h / 2, 27mm, 21mm, rose, 5)
#blob(85mm, 46mm, 15mm, 13mm, lilac, 6)
#blob(B.x + B.w / 2, B.y + B.h / 2, 35mm, 22mm, mint, 7)

#let marked(r, seed) = {
  pencil-box(r.x, r.y, r.w, r.h, seed)
  let px = r.x + r.w * FX
  let py = r.y + r.h * FY
  dotted((r.x, py), (px, py))
  dotted((px, r.y), (px, py))
  at(px - 1.3mm, py - 1.3mm, circle(radius: 1.3mm, stroke: (paint: ink, thickness: 0.6pt), fill: none))
  at(px - 0.45mm, py - 0.45mm, circle(radius: 0.45mm, fill: ink, stroke: none))
}
#marked(A, 1)
#marked(B, 2)

#let under(r, title, px) = centered(r.x + r.w / 2, r.y + r.h + 3mm, r.w + 14mm)[
  #set par(leading: 0.55em)
  #text(size: 7.5pt)[#title] \
  #text(size: 5.8pt, style: "italic", fill: lead)[point at #px]
]
#under(A, "captured in an 800 × 600 box", "x 496, y 210 px")
#under(B, "replayed in a 1600 × 900 box", "x 992, y 315 px")

#centered(85mm, 39mm, 30mm)[
  #set par(leading: 0.55em)
  #text(size: 12pt)[0.62, 0.35] \
  #text(size: 5.8pt, style: "italic", fill: lead)[fraction of the box]
]
#pencil(A.x + A.w + 6mm, 72mm, 46mm, 1)
#pencil(98mm, B.x - 5mm, 46mm, 1)

#at(12mm, 9mm, text(size: 16pt, style: "italic")[Capture here, replay anywhere])
#at(12mm, 17.4mm, text(size: 7pt, fill: lead)[the fraction carries over; the pixels are worked out again for the new box])
#centered(W / 2, 79mm, 168mm, text(size: 6.2pt, style: "italic", fill: lead)[
  new point = box corner + fraction × box size, for x and for y alike])
