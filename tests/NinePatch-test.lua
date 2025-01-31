local lovecase = require("libs.lovecase")
local NinePatch = require("NinePatch")

local expect = lovecase.expect
local image = love.graphics.newImage("assets/simple-rpg-gui.png")
local suite = lovecase.newSuite("NinePatch")

--- @param r number
--- @param g number
--- @param b number
--- @param a number?
--- @return number r
--- @return number g
--- @return number b
--- @return number a
--- @nodiscard
local function convertColor(r, g, b, a)
  return math.floor(r * 255) / 255,
    math.floor(g * 255) / 255,
    math.floor(b * 255) / 255,
    math.floor((a or 1) * 255) / 255
end

suite:describe("new()", function ()
  suite:test("should create a 9-patch with the given properties", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    expect.equal({300, 200}, {patch:getSize()})
    expect.equal({20, 30, 40, 50}, {patch:getMargin()})
    expect.equal({80, 60}, {patch:getMinSize()})
  end)
end)

suite:describe("fromOptions()", function ()
  suite:test("should create a 9-patch from the given options table", function ()
    local patch = NinePatch.fromOptions{
      texture = image,
      x = 0,
      y = 0,
      width = 300,
      height = 200,
      marginTop = 20,
      marginRight = 30,
      marginBottom = 40,
      marginLeft = 50,
    }
    expect.equal({300, 200}, {patch:getSize()})
    expect.equal({20, 30, 40, 50}, {patch:getMargin()})
    expect.equal({80, 60}, {patch:getMinSize()})
  end)
  suite:test("should raise an error if a mandatory option is missing", function ()
    expect.error(function ()
      local patch = NinePatch.fromOptions{}
    end)
  end)
end)

suite:describe("setSize()", function ()
  suite:test("should set the size of the 9-patch", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setSize(400, 500)
    expect.equal({400, 500}, {patch:getSize()})
  end)
  suite:test("should be constrained by the min size", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setSize(10, 10)
    expect.equal({patch:getMinSize()}, {patch:getSize()})
  end)
end)

suite:describe("getSize()", function ()
  suite:test("should initially return the size of the texture quad", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    expect.equal({300, 200}, {patch:getSize()})
  end)
end)

suite:describe("setWidth()", function ()
  suite:test("should set the width of the 9-patch", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setWidth(400)
    expect.equal({400, 200}, {patch:getSize()})
  end)
end)

suite:describe("setHeight()", function ()
  suite:test("should set the height of the 9-patch", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setHeight(400)
    expect.equal({300, 400}, {patch:getSize()})
  end)
end)

suite:describe("setColor()", function ()
  suite:test("should set the color of all vertices", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setColor(0.1, 0.2, 0.3, 0.4)

    local mesh = patch:getMesh()
    for vertex = 1, mesh:getVertexCount() do
      expect.almostEqual({convertColor(0.1, 0.2, 0.3, 0.4)}, {mesh:getVertexAttribute(vertex, 3)})
    end
  end)
  suite:test("should set alpha to 1 by default", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setColor(1, 1, 1)

    local mesh = patch:getMesh()
    for vertex = 1, mesh:getVertexCount() do
      expect.almostEqual({1, 1, 1, 1}, {mesh:getVertexAttribute(vertex, 3)})
    end
  end)
  suite:test("should accept a table", function ()
    local patch = NinePatch.new(image, 0, 0, 300, 200, 20, 30, 40, 50)
    patch:setColor{0.1, 0.2, 0.3, 0.4}

    local mesh = patch:getMesh()
    for vertex = 1, mesh:getVertexCount() do
      expect.almostEqual({convertColor(0.1, 0.2, 0.3, 0.4)}, {mesh:getVertexAttribute(vertex, 3)})
    end
  end)
end)

return suite