----------------------------------------------------------------------
CS457/557 Functional Languages, Winter 2012

Homework 2: Solutions, grading guide, and commentary
----------------------------------------------------------------------

This file is a literate Haskell script, which means that it
can be loaded directly into a Haskell interpreter like Hugs or
GHCi, bringing the functions that are defined (as indicated by
a '>' character in the first column) into scope.

----------------------------------------------------------------------

[Grading scheme: Maximum points 39 + 21 + 18 + 12 = 90,
further details at the start of each question.]

Question 1:
-----------
[Grading scheme: For each of 13 parts: 2 points for giving
a possible type, and 1 point for explanation/commentary.
Maximum possible points for this question: 39]

We could just ask a Haskell interpreter for some help with
this question, but it's more informative to try figuring out
some answers on our own.  We might not always get the same
answer as the interpreter (which will always return the most
general type that it can find), but that's ok: the question
only asks for a *possible* type.

a) map odd

odd is a function of type Int -> Bool, so map odd will be
a corresponding function that maps lists of Int values to
lists of Bools.  In other words:  map odd :: [Int] -> [Bool]

b) takeWhile null

null is a function from lists to Bool; takeWhile p is a
function that will take an argument list and return the
initial portion for which p returns true.  So takeWhile null
returns the initial portion of a list of lists in which
element is empty.  That is: takeWhile null :: [[a]] -> [[a]]

c) (++[])

This is a section of the append, ++, operator that will add
the empty list on to the end of its argument.  As such, it
can be applied to any list and will return the same list as
its result.   So:  (++[]) :: [a] -> [a]

d) (:[])

This is a section of the cons operator, :.  It will take a
value x as argument and return (x:[]) as a result, which is
the same as [x].  So, if the argument is of type t, then
the result will be a (singleton) list of type [t].
Hence:  (:[]) :: t -> [t]

e) ([]:)

This is a section of the cons operator that adds an empty
list on to the front of its argument.  Because the empty
list is (obviously) a list, this implies that the argument
must be a list of lists.  So:  ([]:) :: [[a]] -> [[a]]

f) [ [], [[]], [[[]]], [[[[]]]], [[[[[    ]]]]] ]

If this example is valid at all, then it must be a list of
some type that includes each of the elements.  For the
rightmost element, [[[[[    ]]]]], there are five levels
of nesting, and hence the element type must be of the form
[[[[[t]]]]] for some t.  All of the other elements in the
list are values of this type, and hence the type of the
full list must be:

  [[[[[[t]]]]]]   (six levels of nesting) for some type t

g) [ [], [[]], [[[]]], [[[[]]]], [[[[[True]]]]] ]

The same argument as in Part (f) applies here too except
that the last element this time is of type [[[[[Bool]]]]],
so the whole list is of type [[[[[[Bool]]]]]], again with
six levels of nesting.

h) [ [True], [[]], [[[]]], [[[[]]]], [[[[[]]]]] ]

This example is ill-typed.  All elements of a list must have
the same type, but in the expression above, the first element
has type [Bool] while the second is [[a]] for some a.  Because
[a] and Bool can never be the same, regardless of what type
we pick for a, this cannot be a valid list in Haskell.

i) map map

map :: (a->b) -> ([a] -> [b]), so if we apply the map
function to the elements in a list of type [a -> b],
then the result will be a list of type [[a] -> [b]].
Hence:

  map map :: [a -> b] -> [[a] -> [b]]

j) map (map odd)

map odd :: [Integer] -> [Bool]       (see part a)
so
map (map odd) :: [[Integer]] -> [[Bool]]

k) map . map

if we apply this to a function f :: a -> b, then we will get
(map . map) f = map (map f), which, by a similar argument to
the one used in (j) above is of type [[a]] -> [[b]].  Thus:

map . map :: (a -> b) -> [[a]] -> [[b]]

l) (map , map)

Each occurrence of map in this pair can be used with a
different function type, so the most general possible type
for this expression is:

   (map, map)
     :: ((a->b) -> [a] -> [b], (c -> d) -> [c] -> [d])

(It's ok if you wrote down more specific types, or if you assumed
the same type for both components of the pair, but it's nice to
know that you can use different types for each of the different
occurrences if you want them ...)

m) [ map id, reverse, map not ]

  map id :: [a] -> [a]
  reverse :: [a] -> [a]
  map not :: [Bool] -> [Bool]

For these types to be the same (so that we can store all of them in
a single list), we need to set a = Bool, and then we have a list in
which all values are functions of type [Bool] -> [Bool].  Hence the
final answer is:

  [ map id, reverse, map not ] :: [[Bool] -> [Bool]]


Question 2:
-----------
[Grading scheme: For each of 7 parts: 3 points for each function
description.  Maximum possible points for this question: 21]

a) odd . (1+)

returns True if and only if its argument is an *even* number.
(Because n+1 wil be odd if, and only if n is even).  You won't
get credit for explaining what this function does if you just
say that it "returns True if (n+1) is odd."

b) odd . (2*)

returns False, regardless of the input number (because no multiple
of two is odd).  This function could also be written as \x -> False,
or as (const False) using the prelude function const.

c) ([1..]!!)

If the input argument is i, then this function returns the ith
element of [1..].  In other words, for i>=0, this function returns
the number (i+1).

d) (!!0)

Returns the first value in a non-empty list; it is equivalent to the
prelude function called "head".

e) reverse . reverse

Reversing a list once and then reversing it again will get us back
to the list that we started with.  In other words, this function is
the identity on (finite) lists.  That is, for any list input, it
returns the same list as a result.  This function doesn't actually
behave as an identity function for *infinite* lists, but we haven't
covered that in class, so I'm not expecting you to be aware of such
details here.

f) reverse . tail . reverse

This function returns the initial portion of a (finite) list (i.e.,
every element of the list except the very last one).  It is similar
to the prelude function called "init".

g) map reverse . reverse . map reverse
 
This is essentially equivalent to the reverse function, but only on
lists with type of the form [[a]].  The two uses of map reverse
ensure that we are working with lists of lists, but the effect of
the first map reverse is cancelled out by the effect of the second,
leaving only the reverse in the middle.  (This assumes, however,
that all of the lists in the input list are finite ...  but that's
another detail that you don't need to worry about yet.)


Question 3:
-----------
[Grading: A full answer to this question requires that you define
3+3+1+1+1 = 9 expressions, each of which is worth 2 points.  So
the maximum possible score for this question is 18 points.  For
each expression, you wil receive 1 point for a correct expression
and 1 point for providing either an explanation or some evidence
of testing.]

Suppose that xs :: [Int], ys :: [[Int]], and zs :: [[[Int]]].  The
sample values given in the question are as follows:

> xs = [1,2] :: [Int]
> ys = [[3], [1,2], [4,5]] :: [[Int]]
> zs = [ [[1], [2], [3]], [[4,5,6]], [[7,8],[9,10]]]  :: [[[Int]]]

We'll use these values to check that the expressions we give in our
answers below give the results that were specified in the question.

a) to calculate the number of integers in each of xs, ys, and zs

  Main> length xs
  2
  Main> sum (map length ys)    -- (i.e.,   (sum . map length) ys)
  5
  Main> sum (map (sum . map length) zs)
                      -- (i.e. (sum . map (sum . map length)) zs)
  10
  Main> 

b) to calculate the sum of the integers in each of xs, ys, and zs

  Main> sum xs
  3
  Main> sum (map sum ys)
  15
  Main> sum (map (sum . map sum) zs)
  55
  Main> 

c) to determine whether xs is an element of ys
   [Hint: consider using a section of the equality operator, ==.]

  Main> not (null (dropWhile (not . (xs==)) ys))
  True
  Main> 

The rationale here is as follows: First drop all of the elements
from ys that are not equal to xs.  If the result is not null, then
we know that there must have been at least one occurence of xs in
ys.

d) to determine whether ys is an element of zs

  Main> not (null (dropWhile (not . (ys==)) zs))
  False
  Main> 

Exactly the same argument as in Part (c) works for us here too,
even though the types are different (one extra level of lists).

e) to determine the position of xs in the list ys (you may assume
for this part of the question that xs definitely is in the list ys.)

  Main> length (takeWhile (not . (xs==)) ys)
  1
  Main> 

In this expression, we take elements from the front of the list that
are not equal to xs.  The number of elements that we take (i.e., the
length of that list) is the position of xs in the original list.


Question 4:
-----------
[Grqding: 4 points for correctly translating the list comprehension
into an equivalent expression using map and concat; 4 points for
tests to verify that the two expressions give the same result; and
4 points for explaining why the list comprehension will always give
a result of zero.  Maximum points for this question: 12.]

Suppose that n :: Int.  Using the rules given in class, show how
the list comprehension 

  [ x - y | x <- [1..n], y <- [1..n] ]

can be rewritten in an equivalent form without comprehensions by
using the map and concat functions.

  [ x - y | x <- [1..n], y <- [1..n] ]

  = concat [ [ x - y | y <- [1..n] ] | x <- [1..n] ]
    { because [ e | gs1, gs2 ] = concat [ [ e | gs2 ] | gs1 ] }

  = concat [ map (\y -> x - y) [1..n] | x <- [1..n] ]
    { because [ e | v <- es ] = map (\v -> e) es }

  = concat (map (\x -> map (\y -> x - y) [1..n]) [1..n])
    { same as previous line }

To verify that this expression gives the same result as the list
comprehension, we'll define:

> comp   n = [ x - y | x <- [1..n], y <- [1..n] ]
> nocomp n = concat (map (\x -> map (\y -> x - y) [1..n]) [1..n])

And now we can run some tests for a couple of small values of n:

  Main> comp 4 == nocomp 4
  True
  Main> comp 100 == nocomp 100
  True
  Main>

Indeed, we can use another list comprehension to run a hundred
test cases:

  Main> and [ comp n == nocomp n | n <- [1..100] ]
  True
  Main> 

Now consider the following expression:

  sum [ x - y | x <- [1..n], y <- [1..n] ]

The result will be zero.  The expression calculates the sum of
n*n numbers.  In this calculation, however, every number that
appears as a positive contribution, x, to the overall sum, also
appears equally many times as a negative contribution to the
suum, and hence the positives cancel out with the negatives
leaving zero as the result.

Optional extra: What result do you get from the expression:
  sum [ x | x <- [1..n], y <- [1..n] ]?
 
This will create a list containing n copies (one for each value
of y) of the numbers from 1 to n (cycling through distinct values
of x).  Thus the result of this expression will be:

   n * sum [1..n]

If you happen to know the closed-form formula for the sum of an
arithmetic progression, namely:

   sum [1..n] = n * (n+1) `div` 2

then you can further reduce the expression above to:

   n * n * (n+1) `div` 2.


----------------------------------------------------------------------
