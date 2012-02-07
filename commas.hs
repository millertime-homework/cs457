
group  :: Int -> [a] -> [[a]]
group n = takeWhile (not . null)
        . map (take n)
        . iterate (drop n)

commas :: Integer -> String
commas  = reverse
        . foldr1 (\xs ys -> xs ++ "," ++ ys)
        . group 3
        . reverse
        . show
