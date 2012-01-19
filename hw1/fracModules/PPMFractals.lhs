> module Main(main) where
> import Fractals
> import Regions

Drawing Fractals with ppm output:

[Russell] I've modified the ppmPalette function to be a wider range of colors
(63 instead of 31) hoping to get less of the definitive lines between colors,
and I've tried a sloppy hand-written formula for allowing the colors to be
darker because I didn't much like the brightness. The result is kinda cool,
because the colors work well together. This was after a multitude of different
formulas I experimented with, and looking at some RGB values in an online
color wheel.

Okay addendum, I actually came back because I was still getting weird bright
colors and wanted something that looked better. Narrowed down the range of
colors, used a very simple formula, love the way it came out.

> type PPMcolor = (Int, Int, Int)
> ppmPalette :: [PPMcolor]
> ppmPalette  = [ (i*3,i*2,i) | i<-[16..ppmMax] ]
> ppmMax      = 63 :: Int

> ppmRender  :: Grid PPMcolor -> [String]
> ppmRender g = ["P3", show w ++ " " ++ show h, show ppmMax]
>               ++ [ show r ++ " " ++ show g ++ " " ++ show b
>                  | row <- g, (r,g,b) <- row ]
>               where w = length (head g)
>                     h = length g

> ppmFrac :: String -> (Point -> [Point]) -> Grid Point -> IO ()
> ppmFrac file frac points
>          = writeFile file
>              (unlines
>                (draw points frac ppmPalette ppmRender))

> ppmTest prefix frac regions
>   = sequence_ [ ppmFrac (prefix ++ ".ppm") frac (r 1024 768)
>               | (n, r) <- zip [1..] regions ]

[Russell] In order to find the right region I looked at the regions used in
the Julia and Mandelbrot samples. I really liked the way the Julia fractals
looked on the julia3 sample. I zoomed in quite a bit further on a specific
point and really liked it.

> main = do ppmTest "hw1" juliaFrac [grid (-0.15,0.65) (-0.05,0.75)]
> --main = ppmFrac "mand.ppm" mandelbrot (region1 1024 768)
> --main = do ppmTest "mand"  mandelbrot mandregions
> --          ppmTest "julia" juliaFrac julregions

