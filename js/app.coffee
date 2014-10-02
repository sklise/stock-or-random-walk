---
---

generateData = (n) ->

fakeStocks = (s) ->
  s.setup = ->
    # create canvas
    canvas = s.createCanvas 500,500
    canvas.parent('canvas-container')
    s.noLoop()
    # no loop
    # create "new stock" button
    # new stock button click listener
  s.draw = ->
    console.log 'draw'

$ -> new p5(fakeStocks)