---
---

# Line graph logic adapted from https://gist.github.com/benjchristensen/2579599

auth_token = "5vaxABzaaPu3ST4bsMM3"

chart =
  w: 500
  h: 200

perlin = new toxi.math.noise.PerlinNoise()

@get_stock = (symbol, callback) ->
  $.ajax(
    type: "GET"
    url: "https://www.quandl.com/api/v1/datasets/WIKI/#{symbol}.json?rows=365&column=4&auth_token=#{auth_token}"
    success: callback
  )

@previous_array_element = (array, index) ->
  if index > 0
    array[index-1]
  else
    false

# Enter a coef between 0 and 1 and generates a function that returns a boolean skewed
@skew = (coef) ->
  -> Math.random() > coef

# Perlin noise not just random
@walk = (i) -> perlin.noise(i)

@get_random_walk = (length, skew_coef, callback) ->
  s = skew(skew_coef)
  result = []
  _.times length, (i) ->
    prev = previous_array_element(result, i) || [-1,0]
    result.push [i, prev[1] + (if s() then 1 else -1) * walk(i)]
  callback(result)

@draw_graph = (el, data, chart) ->
  data.reverse()

  x = d3.scale.linear().domain([0, data.length]).range([0, chart.w]);
  y = d3.scale.linear().domain([d3.min(data, (i) -> i[1]), d3.max(data, (i) -> i[1])]).range([chart.h,0]);

  @chart_line = d3.svg.line()
    .x((d,i) -> x(i))
    .y((d,i) -> y(d[1]))

  graph = d3.select(el).append("svg:svg").attr("width", chart.w).attr("height", chart.h)
  graph.append("svg:path").attr("d", @chart_line(data))

$ ->
  get_stock "FB", (res) -> draw_graph("#stock1", res.data, chart)
  get_stock "QCOM", (res) -> draw_graph("#stock2", res.data, chart)
  get_random_walk 365, .7, (data) -> draw_graph("#stock3", data, chart)
  get_random_walk 365, .48, (data) -> draw_graph("#stock4", data, chart)
