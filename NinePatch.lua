local POS_INDEX = 1
local UV_INDEX = 2
local COLOR_INDEX = 3

local abs = math.abs
local max = math.max
local lg = love.graphics

--- Return whether the two numbers `a` and `b` are close to each other.
--- @param a number
--- @param b number
--- @return boolean
--- @nodiscard
--- @package
local function almostEqual(a, b)
  return abs(a - b) <= 1e-09 * max(abs(a), abs(b))
end

--- Clamp a value between a lower an an upper bound.
--- @param value number
--- @param min number The lower bound
--- @param max number The upper bound
--- @return number clampedValue
--- @nodiscard
--- @package
local function clamp(value, min, max)
  return value < min and min or (value > max and max or value)
end

--- A 9-patch image is a resizable image with defined stretchable regions.
---
--- The 9-patches implemented by this class are based on meshes, which have the following structure:
--- <pre>
---  1    2    3    4
---  ┌────┬────┬────┐
---  │  / │  / │  / │
---  5 /  6 /  7 /  8
---  ├────┼────┼────┤
---  │  / │  / │  / │
---  9 / 10 / 11 / 12
---  ├────┼────┼────┤
---  │  / │  / │  / │
--- 13 / 14 / 15 / 16
---  └────┴────┴────┘
--- </pre>
--- * The top-left, top-right, bottom-left and bottom-right patches each have a static size
--- * The top and bottom patches can stretch horizontally
--- * The left and right patches can stretch vertically
--- * The patch in the middle can stretch in all directions
--- @class quilt.NinePatch
--- @field protected _mesh love.Mesh
--- @field protected _marginLeft number Width of left column
--- @field protected _marginTop number Height of top row
--- @field protected _marginRight number Width of right column
--- @field protected _marginBottom number Height of bottom row
--- @field protected _width number
--- @field protected _height number
local NinePatch = {}
NinePatch.__index = NinePatch

NinePatch.VERTEX_MAP = {
  1, 2, 5, 5, 2, 6,
  2, 3, 6, 6, 3, 7,
  3, 4, 7, 7, 4, 8,
  5, 6, 9, 9, 6, 10,
  6, 7, 10, 10, 7, 11,
  7, 8, 11, 11, 8, 12,
  9, 10, 13, 13, 10, 14,
  10, 11, 14, 14, 11, 15,
  11, 12, 15, 15, 12, 16,
}

--- @param texture love.Texture Texture that contains the 9-patch
--- @param x integer X position of the 9-patch on the texture
--- @param y integer Y position of the 9-patch on the texture
--- @param w integer Width of the 9-patch
--- @param h integer Height of the 9-patch
--- @param mt integer Height of the top patch row
--- @param mr integer Width of the right patch column
--- @param mb integer Height of the bottom patch row
--- @param ml integer Width of the left patch column
--- @return quilt.NinePatch
--- @nodiscard
function NinePatch.new(texture, x, y, w, h, mt, mr, mb, ml)
  --- @type quilt.NinePatch
  local self = setmetatable({}, NinePatch)

  self._mesh = love.graphics.newMesh(16, "triangles", "dynamic")
  self._mesh:setVertexMap(self.VERTEX_MAP)
  self._mesh:setTexture(texture)
  self._marginTop = mt
  self._marginRight = mr
  self._marginBottom = mb
  self._marginLeft = ml

  local tw, th = texture:getDimensions()

  self._mesh:setVertexAttribute(1,  UV_INDEX,            x / tw,            y / th)
  self._mesh:setVertexAttribute(2,  UV_INDEX,     (x + ml) / tw,            y / th)
  self._mesh:setVertexAttribute(3,  UV_INDEX, (x + w - mr) / tw,            y / th)
  self._mesh:setVertexAttribute(4,  UV_INDEX,      (x + w) / tw,            y / th)
  self._mesh:setVertexAttribute(5,  UV_INDEX,            x / tw,     (y + mt) / th)
  self._mesh:setVertexAttribute(6,  UV_INDEX,     (x + ml) / tw,     (y + mt) / th)
  self._mesh:setVertexAttribute(7,  UV_INDEX, (x + w - mr) / tw,     (y + mt) / th)
  self._mesh:setVertexAttribute(8,  UV_INDEX,      (x + w) / tw,     (y + mt) / th)
  self._mesh:setVertexAttribute(9,  UV_INDEX,            x / tw, (y + h - mb) / th)
  self._mesh:setVertexAttribute(10, UV_INDEX,     (x + ml) / tw, (y + h - mb) / th)
  self._mesh:setVertexAttribute(11, UV_INDEX, (x + w - mr) / tw, (y + h - mb) / th)
  self._mesh:setVertexAttribute(12, UV_INDEX,      (x + w) / tw, (y + h - mb) / th)
  self._mesh:setVertexAttribute(13, UV_INDEX,            x / tw,      (y + h) / th)
  self._mesh:setVertexAttribute(14, UV_INDEX,     (x + ml) / tw,      (y + h) / th)
  self._mesh:setVertexAttribute(15, UV_INDEX, (x + w - mr) / tw,      (y + h) / th)
  self._mesh:setVertexAttribute(16, UV_INDEX,      (x + w) / tw,      (y + h) / th)

  -- First patch is set here, because its vertices will never change.
  self._mesh:setVertexAttribute(1, POS_INDEX, 0, 0)
  self._mesh:setVertexAttribute(2, POS_INDEX, ml, 0)
  self._mesh:setVertexAttribute(5, POS_INDEX, 0, mt)
  self._mesh:setVertexAttribute(6, POS_INDEX, ml, mt)

  self:setColor(1, 1, 1, 1)

  self._width = 0
  self._height = 0
  self:setSize(w, h)

  return self
end

--- Create a 9-patch from the specified options table.
--- @param options table
--- @return quilt.NinePatch
--- @nodiscard
function NinePatch.fromOptions(options)
  return NinePatch.new(
    assert(options.texture, "texture required"),
    assert(options.x, "x required"),
    assert(options.y, "y required"),
    assert(options.width, "width required"),
    assert(options.height, "height required"),
    assert(options.marginTop, "marginTop required"),
    assert(options.marginRight, "marginRight required"),
    assert(options.marginBottom, "marginBottom required"),
    assert(options.marginLeft, "marginLeft required")
  )
end

--- Get the internal mesh.
--- Do not manipulate the mesh, unless you know what you are doing.
--- @return love.Mesh mesh
--- @nodiscard
function NinePatch:getMesh()
  return self._mesh
end

--- @return number marginTop Height of top row
--- @return number marginRight Width of right column
--- @return number marginBottom Height of the bottom row
--- @return number marginLeft Width of the left column
--- @nodiscard
function NinePatch:getMargin()
  return self._marginTop, self._marginRight, self._marginBottom, self._marginLeft
end

--- Get the minimum width and height of the 9-patch, which is the sum of its margins.
--- @return number minWidth
--- @return number minHeight
--- @nodiscard
--- @see quilt.NinePatch.getSize
function NinePatch:getMinSize()
  return self._marginLeft + self._marginRight,
    self._marginTop + self._marginBottom
end

--- @return number width
--- @return number height
--- @nodiscard
--- @see quilt.NinePatch.getMinSize
function NinePatch:getSize()
  return self._width, self._height
end

--- Resize the 9-patch to the specified size.
---
--- The specified size is automatcally clamped to the minimum size.
--- @param width number
--- @param height number
--- @return quilt.NinePatch self
function NinePatch:setSize(width, height)
  local minWidth, minHeight = self:getMinSize()

  width = math.max(width, minWidth)
  height = math.max(height, minHeight)

  if almostEqual(width, self._width) and almostEqual(height, self._height) then
    return self
  end

  local stretchWidth = width - minWidth
  local stretchHeight = height - minHeight
  local ml, mt = self._marginLeft, self._marginTop
  local mr, mb = self._marginRight, self._marginBottom

  self._mesh:setVertexAttribute(3,  POS_INDEX,      ml + stretchWidth,                       0)
  self._mesh:setVertexAttribute(4,  POS_INDEX, ml + stretchWidth + mr,                       0)
  self._mesh:setVertexAttribute(7,  POS_INDEX,      ml + stretchWidth,                      mt)
  self._mesh:setVertexAttribute(8,  POS_INDEX, ml + stretchWidth + mr,                      mt)
  self._mesh:setVertexAttribute(9,  POS_INDEX,                      0,      mt + stretchHeight)
  self._mesh:setVertexAttribute(10, POS_INDEX,                     ml,      mt + stretchHeight)
  self._mesh:setVertexAttribute(11, POS_INDEX,      ml + stretchWidth,      mt + stretchHeight)
  self._mesh:setVertexAttribute(12, POS_INDEX, ml + stretchWidth + mr,      mt + stretchHeight)
  self._mesh:setVertexAttribute(13, POS_INDEX,                      0, mt + stretchHeight + mb)
  self._mesh:setVertexAttribute(14, POS_INDEX,                     ml, mt + stretchHeight + mb)
  self._mesh:setVertexAttribute(15, POS_INDEX,      ml + stretchWidth, mt + stretchHeight + mb)
  self._mesh:setVertexAttribute(16, POS_INDEX, ml + stretchWidth + mr, mt + stretchHeight + mb)

  self._width = width
  self._height = height

  return self
end

--- @param width number
--- @return quilt.NinePatch self
function NinePatch:setWidth(width)
  return self:setSize(width, self._height)
end

--- @param height number
--- @return quilt.NinePatch self
function NinePatch:setHeight(height)
  return self:setSize(self._width, height)
end

--- Set the color of the whole 9-patch mesh.
---
--- Each color component is given as a floating point value in the range from 0 to 1.
--- @param r number
--- @param g number
--- @param b number
--- @param a number? alpha (default: 1)
--- @return quilt.NinePatch self
--- @overload fun(self: quilt.NinePatch, rgba: table): quilt.NinePatch
--- @see quilt.NinePatch.setVertexColor
function NinePatch:setColor(r, g, b, a)
  if type(r) == "table" then
    r, g, b, a = r[1], r[2], r[3], r[4]
  end
  for vertex = 1, self._mesh:getVertexCount() do
    self._mesh:setVertexAttribute(vertex, COLOR_INDEX, r, g, b, a)
  end
  return self
end

--- Draw the 9-patch on the screen.
---
--- This method is a simple wrapper around the `love.graphics.draw` function.
--- @param ... any Arguments for `love.graphics.draw`
--- @return quilt.NinePatch self
function NinePatch:draw(...)
  lg.draw(self._mesh, ...)
  return self
end

return NinePatch