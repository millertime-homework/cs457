> module Hw4 where

----------------------------------------------------------------------
CS457/557 Functional Languages, Winter 2012                 Homework 4

Russell Miller
----------------------------------------------------------------------

> data Bit = O | I
>       deriving Show

> type BinNum = [Bit]

a) toBinNum
        Convert an integer to a binary number.

The value of each bit of a binary string is twice the previous bit, so halfOfN
works well to make a recursive call. An even number's binary string ends with 0
and an odd number ends with 1, so with our backwards BinNums we put the O or I
on the front of a cons operator.

> toBinNum   :: Integer -> BinNum
> toBinNum n | n==0   = []
>            | even n = O : toBinNum halfOfN
>            | odd n  = I : toBinNum halfOfN
>              where halfOfN = n `div` 2

Tests: (note that I flipped the strings to make them easier to read)

*Hw4> putStr $ unlines $ map show $ map reverse $ map toBinNum [1..10]
[I]
[I,O]
[I,I]
[I,O,O]
[I,O,I]
[I,I,O]
[I,I,I]
[I,O,O,O]
[I,O,O,I]
[I,O,I,O]

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

Tests:
*Hw4> map (fromBinNum . toBinNum) [1..10]
[1,2,3,4,5,6,7,8,9,10]

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

Tests:
*Hw4> map (fromBinNum . inc . toBinNum) [1..10]
[2,3,4,5,6,7,8,9,10,11]

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
> add []     ds     = ds
> add ds     []     = ds
> add (O:ds) (e:es) = e : add ds es
> add (I:ds) (O:es) = I : add ds es
> add (I:ds) (I:es) = O : inc (add ds es)

Tests:
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

d) Define a function:

--> mul :: BinNum -> BinNum -> BinNum

   that computes the product of its arguments (without converting
   them to Integer values first).  If you're not sure how to proceed,
   you might want to try reminding yourself about long multiplication
   and the see if you can adapt those ideas to this problem.

   Write a law to specify its behavior in relation to the (*) operator
   on Integer values.

   Hint: I'm not going to provide you with a template this time ---
   you've probably seen enough of those by now to be able to construct
   one for yourself. And don't forget that we've already defined some
   useful functions like inc and add for doing arithmetic on BinNum
   values; perhaps one of those will be useful to you here ...

----------------------------------------------------------------------