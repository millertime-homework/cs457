> module Hw4 where

----------------------------------------------------------------------
CS457/557 Functional Languages, Winter 2012                 Homework 4

Russell Miller
----------------------------------------------------------------------

> data Bit = O | I
>       deriving (Show, Eq)

> type BinNum = [Bit]

a) toBinNum
        Convert an integer to a binary number.

The value of each bit of a binary string is twice the previous bit, so halfOfN
works well to make a recursive call. An even number's binary string ends with 0
and an odd number ends with 1, so with our backwards BinNums we put the O or I
on the front of a cons operator.

Note: I'd argue that (toBinNum 0) is better represented as [] to remove the 
unnecessary leading zeros.

> toBinNum   :: Integer -> BinNum
> toBinNum n | n==0   = [O]
>            | even n = O : toBinNum halfOfN
>            | odd n  = I : toBinNum halfOfN
>              where halfOfN = n `div` 2

Basic Tests: (note that I flipped the strings to make them easier to read)

*Hw4> putStr $ unlines $ map show $ map reverse $ map toBinNum [1..10]
[O,I]
[O,I,O]
[O,I,I]
[O,I,O,O]
[O,I,O,I]
[O,I,I,O]
[O,I,I,I]
[O,I,O,O,O]
[O,I,O,O,I]
[O,I,O,I,O]

*Hw4> toBinNum 22
[O,I,I,O,I,O]

fromBinNum
        Convert a binary number to an integer.

I wanted to mirror the previous function as much as possible. Instead of using
div, I'm multiplying by 2 on my recursive calls. And each I or O determines 
whether the resulting number momentarily becomes odd or even, by either adding
1 or 0 to whatever else we calculate on the recursive part.

> fromBinNum :: BinNum -> Integer
> fromBinNum []     = 0
> fromBinNum (O:ds) = 0 + 2 * (fromBinNum ds)
> fromBinNum (I:ds) = 1 + 2 * (fromBinNum ds)

Basic Tests:
*Hw4> map (fromBinNum . toBinNum) [1..10]
[1,2,3,4,5,6,7,8,9,10]

With a little help from "deriving Eq"...
*Hw4> (map (fromBinNum . toBinNum) [1..10]) == [1..10]
True

b) inc
        Produce a binary number that is equivalent to the given binary number's
        integer value plus one.

I knew that a BinNum with O at its head would just need that O turned to a I.
When there is a I there, I figured I could just add a O to the front of it,
and keep going on down the string like that. It ended up working.

> inc :: BinNum -> BinNum
> inc []     = [I]
> inc (I:ds) = O : inc ds
> inc (O:ds) = I : ds

Basic Tests:
*Hw4> map (fromBinNum . inc . toBinNum) [1..10]
[2,3,4,5,6,7,8,9,10,11]

*Hw4> inc [I,I,O,I,O,I]
[O,O,I,I,O,I]

Property we were asked to satisfy.

> testInc d = (inc . toBinNum) d == (toBinNum . (1+)) d

*Hw4> testInc 4
True
*Hw4> testInc 5
True
*Hw4> testInc 19
True

c) add
        Compute the integer sum of two binary numbers.

WOW. This one blows my mind. Obviously adding a BinNum to an empty list just
returns that BinNum. When the head of d is O, we can just grab the head of e,
because by lining up BinNums you can see they work like that. The line below
follows the same reasoning. The last pattern, though, took me a while. I knew
when I saw two I's that I wanted to somehow "carry the I", but I wasn't sure
how. I tried passing an I into the recursive call, but it made the addition
very inconsistent. Sometimes I needed another I, sometimes I didn't. That's
when I finally realized that inc does JUST what I need - it "carries the I".

> add :: BinNum -> BinNum -> BinNum
> add []     ds     = ds ++ [O]
> add ds     []     = ds ++ [O]
> add (O:ds) (e:es) = e : add ds es
> add (I:ds) (O:es) = I : add ds es
> add (I:ds) (I:es) = O : inc (add ds es)

Basic Tests:
*Hw4> fromBinNum $ add (toBinNum 9) (toBinNum 1)
10
*Hw4> fromBinNum $ add (toBinNum 9) (toBinNum 5)
14
*Hw4> fromBinNum $ add (toBinNum 3) (toBinNum 6)
9
*Hw4> fromBinNum $ add (toBinNum 0) (toBinNum 0)
0
*Hw4> fromBinNum $ add (toBinNum 0) (toBinNum 1)
1

Property we were asked to satisfy.

> testAdd x y = (add x y) == (toBinNum (fromBinNum x + fromBinNum y))

*Hw4> testAdd [O,O,I,O] [I,O,I,O]
False

WHAT False?! Yes, my original implementation of toBinNum did not result in 
trailing "O"s, because of the previous explanation above. add was all set to
work perfectly with these (in my mind) well-formed binary numbers. In order for
it to match the above property correctly, I had to add appends with trailing
"O"s manually. Did I do something wrong? It seems extremely wrong.

With "++ [O]" added...
*Hw4> testAdd [O,O,I,O] [I,O,I,O]
True

d) mul
        Compute the integer product of two binary numbers.

I used Wikipedia as a refernce for long multiplication ideas. Here is their 
example:

       1011   (this is 11 in binary)
     x 1110   (this is 14 in binary)
     ======
       0000   (this is 1011 x 0)
      1011    (this is 1011 x 1, shifted one position to the left)
     1011     (this is 1011 x 1, shifted two positions to the left)
  + 1011      (this is 1011 x 1, shifted three positions to the left)
  =========
   10011010   (this is 154 in binary)

The key elements are the shifts to the left, the fact that any number times 0 is
0 (duh), and the recursive addition.
I knew my recursion would hit a base case of coming to the final digit ([O]). I 
modified the add function's pattern to use [O] instead of [].
From there I wanted to leave the first binNum alone and work across the second
(as is done in the example). When there is a "I", I put the first number down as
the result - the multiplication identity value of x * 1 = x. A "O" drops a [O] 
there, which doesn't have its trailing zeros (but that isn't important).
The recursive calls add a "O" to do the "left shift" called for in the example,
because our binary numbers are backwards.

> mul :: BinNum -> BinNum -> BinNum
> mul [O]     ds = [O]
> mul ds     [O] = [O]
> mul ds (O:es)  = add [O] (O:(mul ds es))
> mul ds (I:es)  = add ds (O:(mul ds es))

Basic Tests:
*Hw4> fromBinNum (mul (toBinNum 3) (toBinNum 2)) 
6
*Hw4> fromBinNum (mul (toBinNum 3) (toBinNum 4)) 
12
*Hw4> fromBinNum (mul (toBinNum 0) (toBinNum 4)) 
0
*Hw4> fromBinNum (mul (toBinNum 1) (toBinNum 4)) 
4

Property we were asked to (discover and) satisfy.

> testMul x y = (mul x y) == (toBinNum (fromBinNum x * fromBinNum y))

*Hw4> testMul (toBinNum 3) (toBinNum 2)
False
*Hw4> mul (toBinNum 3) (toBinNum 2)
[O,I,I,O,O,O]
*Hw4> toBinNum (3 * 2)
[O,I,I,O]
*Hw4> fromBinNum (mul (toBinNum 3) (toBinNum 2))
6

This is great. My implementation is producing extra leading zeros. There is an
issue with "deriving Eq" as it applies to a list of Bits. Is it really False 
that [O,I,I,O,O,O] == [O,I,I,O] ? I don't believe it is. At this point I'd
really like to change the way BinNum is instantiated in Eq. Can we do so with 
the BinNum type alias we defined?

--> instance Eq BinNum where
-->   x == y = x `truncEq` y

--> truncEq :: BinNum -> BinNum -> Bool
--> truncEq x y = and $ zipWith (==) x y

This truncates extra ONES as well as extra zeros!! BAD!