module MusicTest where

import Haskore.Music
import Haskore.Melody
import Haskore.Basic.Pitch
import Haskore.Basic.Duration
import Data.List as L

import Snippet

-- goal
arrange_melody 1 m1 m2 = [m1, m2, m2]
arrange_melody 2 m1 m2 = [m2, m1, m2]
arrange_melody 3 m1 m2 = [m2, m2, m1]

combine_melody         = line . L.intersperse hnr
make_test n m1 m2      = combine_melody $ arrange_melody n m1 m2

pitch_line = line . map ( \x -> x o en () ) where o = 1 :: Octave