module ImageD where

import Image

data ImageD color = Rectangle Float Float color
                  | Square Float color
                  | Circle Float color
                  | Semi color
                  | Over (ImageD color) (ImageD color)
                  | Mask (ImageD color) (ImageD color)
                  | Translate Point (ImageD color)
                  | Stretch Float (ImageD color)
                  | XStretch Float (ImageD color)
                  | YStretch Float (ImageD color)
                  | XReflect (ImageD color)
                  | YReflect (ImageD color)
                  | Rotate Float (ImageD color)

render                     :: ImageD color -> Image color
render (Rectangle h w col)  = rectangle h w col
render (Over top bot)       = over (render top) (render bot)