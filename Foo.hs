module Foo where

import Test.HUnit

-- custom data type
{-
data Day = Sun|Mon|Tue|Wed|Thu|Fri|Sat
        deriving (Eq,Show,Enum)
-}

-- Testing a Merge function

merge              :: [Int] -> [Int] -> [Int]
merge [] ys         = ys
merge (x:xs) []     = x:xs
merge (x:xs) (y:ys)
        | x<y       = x : merge xs (y:ys)
        | y<x       = y : merge (x:xs) ys
        | x==y      = x : merge xs ys
-- lol inefficient
-- merge xs ys = xs ++ ys

testMerge1 = TestCase (assertEqual
                       "merge [1,5,9] [2,3,6,10]"
                       [1,2,3,5,6,9,10]
                       (merge [1,5,9] [2,3,6,10]))

testMerge2 = TestCase (assertEqual
                       "merge [] [1,2,3]"
                       [1,2,3]
                       (merge [] [1,2,3]))

testMerge3 = TestCase (assertEqual
                       "merge [1,2,3] []"
                       [1,2,3]
                       (merge [1,2,3] []))

testMerge4 = TestCase (assertEqual
                       "merge [2] [1,2,3]"
                       [1,2,3]
                       (merge [2] [1,2,3]))

testMerge5 = TestCase (assertEqual
                       "merge [1,2,3] [2]"
                       [1,2,3]
                       (merge [1,2,3] [2]))

mergeTests = TestLabel "merge tests"
           $ TestList [testMerge1, testMerge2, testMerge3, testMerge4, 
                       testMerge5]

runTests = runTestTT mergeTests

main = runTests

data Nat = Zero | Succ Nat
        deriving Show

add :: Nat -> Nat -> Nat
add Zero n     = n
add (Succ m) n = Succ (add m n)

natToInt         :: Nat -> Int
natToInt Zero     = 0
natToInt (Succ m) = 1 + natToInt m

intToNat  :: Int -> Nat
intToNat 0 = Zero
intToNat x = Succ (intToNat (x-1))

-- Using >>= with a list MONADS AHHHH
-- >>= :: [a] -> (a -> [b])

tryit = do { putStr "[1,2,3] >>= (take 3 . repeat) = "
           ; let x = [1,2,3] >>= (take 3 . repeat)
           ; print x
           }

data Date =
  MkDate {
    day   :: Int,
    month :: Int,
    year  :: Int } 
      deriving (Show, Read)

quickSort       :: Ord a => [a] -> [a]
quickSort []     = []
quickSort [x]    = [x]
quickSort (x:xs) = quickSort (filter (<=x) xs) ++ x : quickSort (filter (>x) xs)

sortMin :: Ord a => [a] -> a
sortMin  = head . quickSort