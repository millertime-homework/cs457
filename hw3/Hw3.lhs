> module Hw3 where

Russell Miller
CS457 Functional Programming
Winter 2012 - Mark Jones
Homework 3

Question 1:
-----------
a) Write a function padTo :: Int -> String -> String such that
padTo n s is a string of length n, padded if necessary with extra
spaces on the left.  For example:

  Main> padTo 6 "abc"
  "   abc"
  Main> padTo 4 "abc"
  " abc"
  Main> padTo 2 "abc"
  "bc"

[You are encouraged (although not required) to write your definition
of padTo by composing combine a pipeline of functions.]


One part of the solution to this question will involve adding a specific number
of spaces to a string. This expression represents empty strings of length n.

> nSpaces n = take n $ repeat ' '

*Hw3> nSpaces 3
"   "
 123  -- just counting visually :)

Assuming the integer argument for padTo is greater than the length of the 
string, we would just be adding an nSpaces string to the front of it.

> addnSpaces n w = (take n $ repeat ' ') ++ w

*Hw3> addnSpaces 3 "abc"
"   abc"
 123

The hard part is correctly truncating strings where the integer argument is 
less than the length of the string, because we need to cut the beginning of the
word instead of the end. Here's a simple function that handles this when we 
know n is less than the length of w.

> trunc n w = reverse $ take n $ reverse w

*Hw3> trunc 3 "abcd"
"bcd"

Now I just need to put all the pieces together. The (take n) might seem like an
error on the far right end, but we simply know there will be less than or equal
to that many spaces of padding necessary. Without specifying a length the code
hangs, probably on the (++) trying to concatenate an infinite list. The (take n)
on the left corrects any extra spaces added.

> padToDolla n w = reverse $ take n $ (reverse w) ++ (repeat ' ')

> padTo n = reverse
>         . take n
>         . flip (++) (repeat ' ')
>         . reverse

*Hw3> padTo 6 "abc"
"   abc"
*Hw3> padTo 4 "abc"
" abc"
*Hw3> padTo 2 "abc"
"bc"

 ################## N # E # X # T ###################################

b) The purpose of this question is to construct a function, multable,
that can output (square) multiplication tables of any given size, as
shown in the following examples:

  Main> multable 3
  1  2  3
  2  4  6
  3  6  9

  Main> multable 4
   1   2   3   4
   2   4   6   8
   3   6   9  12
   4   8  12  16

  Main> multable 10
    1    2    3    4    5    6    7    8    9   10
    2    4    6    8   10   12   14   16   18   20
    3    6    9   12   15   18   21   24   27   30
    4    8   12   16   20   24   28   32   36   40
    5   10   15   20   25   30   35   40   45   50
    6   12   18   24   30   36   42   48   54   60
    7   14   21   28   35   42   49   56   63   70
    8   16   24   32   40   48   56   64   72   80
    9   18   27   36   45   54   63   72   81   90
   10   20   30   40   50   60   70   80   90  100

Your implementation should be constructed by replacing the "..."
portions of the following code with appropriate expressions.

  multable  = putStr . showTable . makeTable

  makeTable  :: Integer -> [[Integer]]
  makeTable n = ...

  showTable  :: [[Integer]] -> String
  showTable   = ...

You will probably need to use the padTo function that you defined
in Part (a).  You are also welcome to define additional auxiliary
functions to use in the definitions of makeTable or showTable if
you find it convenient to do so.  Note that multable should ensure
that all of the columns in the output are properly aligned.

> multable = putStr . showTable . makeTable

This uses the formula from class for 'group' to take the list I came up with and
groups the table by rows. The list I created is a simple calculation that 
corresponds to how a multiplication table is actually formed.

> makeTable :: Int -> [[Int]]
> makeTable n = takeWhile (not . null) $ map (take n) $ iterate (drop n) xs
>         where xs = [(x*y) | x <- [1..n], y <- [1..n] ]

First this converts the Ints to Strings. Then padTable adds padding to each
String. Then we flatten each row with concat. Then unlines adds a newline to
each row and turns the list into a single String.

> showTable :: [[Int]] -> String
> showTable = unlines
>           . map concat
>           . padTable
>           . (map . map) show

Following the where clause first, this checks the length of the strings in the
table and finds the maximum, adding 2 extra spaces for visual snazz. It uses the
result to apply the padTo function to every element of the table.

> padTable :: [[String]] -> [[String]]
> padTable tab = (map . map) (padTo n) tab
>       where n = (2+) $ maximum $ map maximum $ (map . map) length tab

 ################## N # E # X # T ###################################

Question 2:
-----------
a) There are many different ways to construct a non-empty list using
only non-empty list enumerations and the ++ operator.  For example,
the list [1,2,3] can be constructed by writing [1,2,3], ([1]++[2,3]),
or (([1]++[2])++[3]) (and these are not the only options).

Your task is to define a function

  allWays   :: [Integer] -> [String]
  allWays xs = ...

that will produce a list of strings that show all of the possible
ways to build the given list of integers in this way, provided that
the input list is not empty.  To help you to display the output
from this function in a readable manner, you may use the following
function:

  layout :: [String] -> IO ()
  layout  = putStr
          . unlines
          . zipWith (\n l -> show n ++ ") " ++ l) [1..]

Remember also that you can convert an arbitrary list of integers
into a printable string by applying the show function.

For example, here is what you might see when you use these functions
together in a Hugs or GHCi session:

  Main> layout (allWays [1,2,3])
  1) [1,2,3]
  2) ([1]++[2,3])
  3) ([1]++([2]++[3]))
  4) ([1,2]++[3])
  5) (([1]++[2])++[3])

  Main>

Note that it is not necessary for your solution to list the generated
strings in the same order as shown in this input.  If you happen to
come up with a different variation of the code that lists them in a
different order, that will be just fine.  However, you should follow
the convention used above in which parentheses are placed around any
use of the ++ operator.  You may find it convenient to use the following
function to help construct strings that are in this format:

  appString    :: String -> String -> String
  appString l r = "(" ++ l ++ "++" ++ r ++ ")"

[hint: The splits function that was used in the natural language
processing example may also be very useful in this task.]

Looking at the splits function we were shown in class.

> splits      :: [a] -> [([a], [a])] 
> splits ts    = zip (initsNE ts) (tailsNE ts) 

We need to redefine inits to not include empty values. I'll call it initsNE as
in "inits Not Empty"

> initsNE       :: [a] -> [[a]] 
> initsNE [x]    = [] 
> initsNE (x:xs) = map (x:) ([]:initsNE xs) 

Same for tails.

> tailsNE       :: [a] -> [[a]] 
> tailsNE [x]    = [] 
> tailsNE (x:xs) = xs : tailsNE xs

Here's a preliminary version of allWays that uses splits.
  
  allWays xs = (show xs) : map (\x -> "(" ++ show (fst x) ++ "++" ++ 
                                show (snd x) ++ ")") (splits xs)

I tried it out and got this:

*Hw3> layout (allWays [1,2,3])
1) [1,2,3]
2) ([1]++[2,3])
3) ([1,2]++[3])

The things that are missing are recursive calls to inner lists. I tried to 
simply call the same function on the result of splits and got an Infinite Type
error. I think the tuples we're getting from splits are a good type to hold the
portions of the splitted list, but we need to handle them in a special way.

I tried a million other things to figure this one out. At one point I had 
multiple functions that were going to pass lists and tuples back and forth.
Having the tuples nested in other tuples and lists changed the type, meaning the
values didn't match the expected types.

I even thought I might be able to build a tree using a custom data type that 
could hold lists or tuples. But because of the recursion, even those types 
wouldn't work after a few layers.

Part of the problem may have been the original splits function. It provides
the splits as shown above, but not anything deeper where sublists are split as
well.

Honestly I was completely stuck. I was at a wall. I got a lot of help with 
understanding how a recursive list comprehension could do this. After studying
the information I was given over and over, I wrote it out across a white board.

Basically this is 3 loops using generators in a list comprehension. The n value
in the outermost loop determines where the original (or portion of the original) 
list will be split. The l value is taken from a list of strings generated 
recursively, splitting the first portion of the split until it can't be split 
any more. The default empty list pattern catches to enforce termination. The 
innermost loop handles the right-hand side of each split, working just like the 
left side.

> allWays   :: [Int] -> [String]
> allWays [] = []
> allWays xs = show xs : [ appString l r | n <- [1..(length xs - 1)],
>                                          l <- allWays (take n xs),
>                                          r <- allWays (drop n xs) ]

> appString    :: String -> String -> String
> appString l r = "(" ++ l ++ "++" ++ r ++ ")"

> layout :: [String] -> IO ()
> layout  = putStr
>         . unlines
>         . zipWith (\n l -> show n ++ ") " ++ l) [1..]


 ################## N # E # X # T ###################################

b) Of course, in practice, there is no need to include parentheses
in expressions that construct lists using the notation shown in
Part (a).  For example, ([1]++([2]++[3])) and (([1]++[2])++[3])
are equivalent to [1]++[2]++[3] because the ++ operator is
associative.  Write a new function:

  noParens   :: [Integer] -> [String]
  noParens xs = ...

that generates a list of strings showing all of the possible
ways to construct the given input list using only ++ and list
enumeration, without any repetition.  For example, here is an
example showing how this function might be used in a Haskell
interpreter:

  Main> layout (noParens [1,2,3])
  1) [1,2,3]
  2) [1]++[2,3]
  3) [1]++[2]++[3]
  4) [1,2]++[3]

  Main>

Note here that there are only 4 output lines in this particular
example, so you cannot produce the output for noParens simply
by removing the open and close parenthesis characters from the
output of allWays.  [hint: indeed, your definition of noParens
will probably have a different structure to your definition of
allWays, although it might still make good use of the splits
function ...]

When I was working on allWays I was reading examples in your e-mails, and I knew
that they were actually for noParens, but I didn't know that there was going to
be differentiation in the actual lists. As I was constructing the expression for
allWays, I felt like making a recursive call for the left side of the splits 
would cause redundant strings.

When I got to noParens I changed appString, removing the parentheses. The other
change necessary was in the list comprehension of noParens, but really I already
knew how to do it. I just took out the recursive call that I actually had to add
to get allWays to produce the correct strings.

> noParens   :: [Int] -> [String]
> noParens [] = []
> noParens xs = show xs : [ appNoPString l r | n <- [1..(length xs - 1)],
>                                              l <- [show (take n xs)],
>                                              r <- noParens (drop n xs) ]

> appNoPString    :: String -> String -> String
> appNoPString l r = l ++ "++" ++ r
