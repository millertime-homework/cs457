module Hw6 where

import Treedot

-- tree-like type for capturing the structure of data values
data VizTree = VizNode String [VizTree]

-- first requirement for using Treedot library
-- a description of how to obtain a node's subtrees
instance Tree VizTree where
  subtrees (VizNode _ xs) = xs

-- second requirement for Treedot
-- description of a node's label
instance LabeledTree VizTree where
  label (VizNode x _) = x

-- type class of visualizable types: types whose values can be converted
-- into appropriate trees of type VizTree
class Viz a where
  toVizTree       :: a -> VizTree
  toVizList       :: [a] -> VizTree
  toVizList []     = VizNode "[]" []
  toVizList (x:xs) = VizNode ":" [toVizTree x, toVizTree xs]

instance Viz Integer where
  toVizTree n = VizNode (show n) []

instance Viz Char where
  toVizTree c = VizNode (show c) []
  toVizList s = VizNode ("\\\""++s++"\\\"") []

instance Viz a => Viz [a] where
  toVizTree = toVizList

instance Viz Bool where
  toVizTree n = VizNode (show n) []

instance Viz Int where
  toVizTree n = VizNode (show n) []

instance (Viz a,Viz b) => Viz (a,b) where
  toVizTree (x,y) = VizNode "," [toVizTree x, toVizTree y]

instance (Viz a, Viz b, Viz c) => Viz (a,b,c) where
  toVizTree (x,y,z) = VizNode ",," [toVizTree x, toVizTree y, toVizTree z]

instance Viz a => Viz (Maybe a) where
  toVizTree Nothing  = VizNode "Nothing" []
  toVizTree (Just x) = VizNode "Just" [toVizTree x]

-- we can now connect the 2 previous items here
viz         :: Viz a => FilePath -> a -> IO ()
viz filename = writeFile filename . toDot . toVizTree