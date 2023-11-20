local BASE = (...):gsub("init$", "")
local NinePatch = require(BASE .. ".NinePatch")

local quilt = {
  _NAME = "quilt",
  _DESCRIPTION = "9-patch graphics for the LÖVE game framework",
  _VERSION = "1.1.0",
  _URL = "https://github.com/binaryfs/quilt",
  _LICENSE = [[
    MIT License

    Copyright (c) 2023 Fabian Staacke

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  ]],
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
function quilt.newNinePatch(texture, x, y, w, h, mt, mr, mb, ml)
  return NinePatch.new(texture, x, y, w, h, mt, mr, mb, ml)
end

return quilt