> module Hw1 where

1. Fractals: I've modified the PPMFractals.lhs file in the attached folder. My 
comments are included in that file.

2. Writing simple functions without recursion

Just using simple Prelude functions to create a list of 2's and multiply them 
together. Since `power of two' is just two times itself n times.

> powerOfTwo :: Int -> Integer
> powerOfTwo n = product (take n (repeat 2))

First I mapped the previous powerOfTwo function to a list of possible values of
n. Knowing the values at the beginning of the list are not going to satisfy the
requirement of v < powerOfTwo n, I checked for values that were less than or
equal to v. I wanted the next element in the list, but rather than storing it or
attempting to calculate it I knew the index of the last element of the list 
would be the same value (since it's zero-based). An even easier way to get that
index is by checking the length of that list.

> logTwo :: Integer -> Int
> logTwo 1 = 0
> logTwo v = length (takeWhile (<=v) (map powerOfTwo [0..]))

Again using simple Prelude functions.

> copy :: Int -> a -> [a]
> copy n x = take n (repeat x)

Since the nth element of the list created by iterate is the point when the
function f has been applied to x n times, I used the index operator to extract
it.

> multiApply :: (a -> a) -> Int -> a -> a
> multiApply f n x = (iterate f x) !! n

Now suppose that we define the following function using multiApply:

> q f n m x = multiApply (multiApply f n) m x

What is the type of this function, and what exactly does it do?
What law of multiApply does this suggest?

Its type would be

(a -> a) (Int -> a) -> Int -> a -> a

The first `multiApply' has type (a -> a) because it's just a function.
Then the (Int -> a) is the result of the `(multiApply f n)' which curries
a function of type `(Int -> a)'.
Finally the `m' is Int and `x' is a. With a result of a.
This is the law of distribution. We're distributing the curried function
property of multiApply upon itself.

3. Studying zip/zipWith

a. zip: Take two lists and combine them one element at a time into tuples.
The canonical example that helps me remember how zip works is

--> zip [1,2,3] ['a','b','c'] = [(1,'a'),(2,'b'),(3,'c')]

zipWith: rather than putting the two corresponding list elements in a tuple,
any function can be used, taking each element as arguments. The documentation 
offers (+) as an example.

--> zipWith (+) [1,2,3] [2,3,4] = [3,5,7]

Here's an example I'll craft myself.

--> range x y = [x..y]

--> zipWith range [1,2,3] [7,8,9] = [[1..7],[2..8],[3..9]]

I've shortened it to the `..' notation for the ranges for succinctness.

b. Here's a version of zipWith written in terms of zip using a list 
comprehension. Using the list of tuples I then apply the given function to the
two elements of each tuple, using fst and snd to extract them.

> myZipWith :: (a -> b -> c) -> ([a] -> [b] -> [c])
> myZipWith f xs ys =  [ (f (fst x) (snd x)) | x <- (zip xs ys) ]

c. With this one I was able to easily write a recursive version. I then 
attempted to pull out the recursive part and attempt to write a `getPair' 
function that would essentially go into a list comprehension and iterate down
the list for me. At some point I realized I was writing an overly complicated
version of zip. I was shocked when I saw how simple this function was.

> adjacents :: [a] -> [(a,a)]
> adjacents xs = zip xs (tail xs)

d. Below is my attempt to nicely print out Pascal's Triangle.

First I was able to write the nextRow function without much trouble. Rather than
using zip to create a list of adjacents, I used the `zipWith' function from 
earlier and gave it the addition function, borrowing the logic from `adjacents'.

> nextRow [] = [1]
> nextRow xs = [1] ++ (myZipWith (+) xs (tail xs)) ++ [1]

Next I created a list of lists which just repeatedly gets next rows n times.

> buildPascal n = take n (iterate nextRow [1])

This function draws a list of lists. 
It doesn't extract the numbers :(
It doesn't insert extra spaces in the line :(
How do I do that?

> drawLoL [] = putStrLn ""
> drawLoL (x:xs) = do
>     print x
>     drawLoL xs

This is a nicer version that lets you specify the size and makes the calls to
the above functions for you.

> drawPascal n = drawLoL (buildPascal n)

e. This is my combination counters. I wrote a simple factorial function first.

> factorial n = product [1..n]

This combination counter, using factorials, is attractive because the well-known
formula is spelled out clearly. The product calculations, however, might not be
as efficient as simply looking up an index in a list as below.

> combFact n r = (factorial n) `div` ((factorial (n-r)) * (factorial r))

This combination counter, searching Pascal's triangle (which is implemented here
as a 2-dimensional list), is attractive because indexing a list is rather easy
to do. It is unattractive because even though we are finding the nth row, I had
to fiddle with it and found out that my `buildPascal' function requires the
argument to be (n+1) instead. Small implementation details like this can be a
nightmare for debugging or simply investigating code. I prefer the 
straightforward approach that is unquestionably correct.

> combPascal n r = (last (buildPascal (n+1))) !! r