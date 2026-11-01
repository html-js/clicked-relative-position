// One click, four coordinate spaces: from the desktop down to the box-relative
// fraction that survives a different screen. Pastel watercolor style.
#import "_wash.typ": *
#let W = 184mm
#let H = 88mm
#set page(width: W, height: H, margin: 0mm, fill: paper)
#set text(font: "C059", size: 7pt, fill: ink)

#speckle(700, W, H)

#let NY = 47mm
#let X = (26mm, 70.5mm, 115mm, 159.5mm)
#blob(X.at(0), NY, 18.5mm, 16mm, rose, 1)
#blob(X.at(1), NY, 18.5mm, 16.5mm, lilac, 2)
#blob(X.at(2), NY, 18.5mm, 16mm, mint, 3)
#blob(X.at(3), NY, 18.5mm, 16.5mm, butter, 4)

#let node(x, name, sub, body) = centered(x, NY - 10.5mm, 28.5mm)[
  #set par(leading: 0.55em)
  #text(size: 11pt)[#name] \
  #text(size: 5.8pt, style: "italic", fill: lead)[#sub]
  #v(1.1mm)
  #text(size: 6pt)[#body]
]
#node(X.at(0), "Desktop", mono("screen_x, screen_y"))[The pointer measured from the corner of the primary screen.]
#node(X.at(1), "Viewport", mono("client_x, client_y"))[The visible page area. Scrolling and window position drop out.]
#node(X.at(2), "Box", mono("stage_x, stage_y"))[The click area itself, in CSS pixels from its top-left corner.]
#node(X.at(3), "Fraction", mono("norm_x, norm_y"))[A share of the box width and height, from 0 to 1.]

#for i in range(3) {
  let a = X.at(i) + 16.8mm
  let b = X.at(i + 1) - 16.8mm
  pencil(a, b, NY, 1)
}
#let step(i, body) = centered((X.at(i) + X.at(i + 1)) / 2, NY + 19.5mm, 40mm,
  text(size: 6pt, style: "italic")[#body])
#step(0)[minus the viewport origin]
#step(1)[minus the box corner]
#step(2)[divided by the box size]

#at(12mm, 9mm, text(size: 16pt, style: "italic")[Four ways to say where])
#at(12mm, 17.4mm, text(size: 7pt, fill: lead)[one click, measured from the whole desktop down to the box you clicked in])
#centered(W / 2, 78.5mm, 168mm, text(size: 6.2pt, style: "italic", fill: lead)[
  Pixel values change with the screen, the window and the zoom level. The fraction does not, so it is the one to carry elsewhere.])
