> module Hw2 where

Russell Miller
HW2 CS457 Functional Programming

Question 1:
-----------
Give possible types for each of the following expressions (or else
explain why you think the expression is ill-typed):
 a) map odd

[Integer] -> [Bool]
Note: I cheated and used :t in GHCi.
This expression is a function. It takes a list of numbers and returns a list of
boolean values describing which of the given numbers was even.

 b) takeWhile null

[[a]] -> [[a]]
This is a function that returns an empty list when you give it a list of lists.

 c) (++[])

[a] -> [a]
This is a function that appends the empty list to a list, thus doing nothing.

 d) (:[])

a -> [a]
This is a function that turns an input value into a single element list 
containing that value in its lone element.

 e) ([]:)

[[a]] -> [[a]]
This function takes a list of lists and adds an empty list as the outer list's 
first element.

 f) [ [], [[]], [[[]]], [[[[]]]], [[[[[    ]]]]] ]

[[[[[[a]]]]]]
It's valid to have [] as the first element of the outermost list, because it's 
actually a list of list of lists of lists of lists of lists, where the lists are 
all empty. By the same respect, [[]] is the same type, and so on.
The reason GHCi says there is a type a is for expressions such as applying this
list to (++[[[[[[3]]]]]]), where a can become Integer.

 g) [ [], [[]], [[[]]], [[[[]]]], [[[[[True]]]]] ]

[[[[[[Bool]]]]]]

 h) [ [True], [[]], [[[]]], [[[[]]]], [[[[[]]]]] ]

ill-typed. This list contains elements of different types. The first element is
type [Bool], but the rest are [[[[[[a]]]]]]. 

 i) map map

[a -> b] -> [[a] -> [b]]
This has been boggling my mind. I sort of understand what the expression means,
but I've had a really hard time applying it to anything. Since map takes a 
function and a list as input, the map on the right is of type 
(a -> b) -> [a] -> [b]
and that is being applied to the map on the left, resulting in a list of 
elements that are type a, and have a function applied to them resulting in type
b. But since the outermost map is also applied to a list all of these smaller
lists must be collected into an outer list.

 j) map (map odd)

A possible type is the following.
[[Integer]] -> [[Bool]]
One way I tried this out was the following.

*Hw2> (map (map odd)) [[1,2,3],[4,5,6],[7,8,9]]
[[True,False,True],[False,True,False],[True,False,True]]

Basically it doesn't apply odd to elements of the outer list, only to elements 
of lists inside it.

 k) map . map

This is MUCH easier to understand than (map map). This one just takes a function 
and a list of lists. The example I used was the following.

*Hw2> (map . map) odd [[1,2,3],[4,5,6]]
[[True,False,True],[False,True,False]]

Here the type is
(Integer -> Bool) -> [[Integer]] -> [[Bool]]

 l) (map , map)

((a -> b) -> [a] -> [b], (a1 -> b1) -> [a1] -> [b1])
That's what GHCi told me the type is.
I knew what it was, but I wrote it wrong. It's two functions, and each takes a
function and a list. They can be completely different types.

Here's an attempt to use (map,map)

> twoFuncs (a,b) f xs ys = ((a f xs), (b f ys))

*Hw2> twoFuncs (map,map) even [1,2,3] [4,5,6]
([False,True,False],[True,False,True])

Thanks Mark, for showing me a cool way to basically do (zipWith ($)) with pairs.

> pairZip (f,g) (x,y) = (f x, g y)

*Hw2> pairZip (pairZip (map, map) (odd, even)) ([1,2,3], [4,5,6])
([True,False,True],[True,False,True])

 m) [ map id, reverse, map not ]

At first I wasn't sure if these 3 functions followed the rule of having the same
type, since that's required for elements of a list. But since id can take any 
type, all that's required for that element is a list. The reverse function also
takes a list, and map not specifies that it is a list of boolean values.
[[Bool] -> [Bool]]
This is what GHCi tells me its type is. The outer list is the list we defined to
hold these functions. 
Thanks Mark, for showing me that we can use zipWith and ($) to apply each 
element of this list to a list of arguments for the functions to take.

Question 2:
-----------
Explain what each of the following functions does.  (Note that
your answers should reflect the behavior of each function at a
high-level and should not just be a restatement of the Haskell
syntax.  For example, you could say that (sum . concat) is a
function that "adds up all of the values in a list of list of
numbers", but you wouldn't get credit for saying that it is
"the composition of the sum and concat functions".)

 a) odd . (1+)

This is the same thing as the function even, because adding 1 to something will
flip its evenness to oddness, and vice versa.

> myEven = odd . (1+)

*Hw2> myEven 6
True
*Hw2> myEven 3
False

 b) odd . (2*)

This is similar to above, only now it always gives the function odd an even 
number, so the result is always False.

> anotherEven = odd . (2*)

*Hw2> anotherEven 3
False
*Hw2> anotherEven 6
False

 c) ([1..]!!)

This function simply adds one to a number. It's doing so by finding the nth 
element of the list [1..], which because of one-indexing instead of zero,
ends up being (n+1)
[when n is the argument given]

> plusOne = ([1..]!!)

*Hw2> plusOne 4
5
*Hw2> plusOne 6
7

 d) (!!0)

This function works exactly like head. It returns the zeroth element of a list.

> myHead = (!!0)

*Hw2> myHead [1,2,3]
1
*Hw2> myHead [3]
3

 e) reverse . reverse

This is simply an id function that only works for a list, because after 
reversing the original list, it is then reversed again returning it to its
original order.

> listId = reverse . reverse

*Hw2> listId [1,2,3]
[1,2,3]

 f) reverse . tail . reverse

This is the same as the init function. It removes the last element of a list.

> myInit = reverse . tail . reverse

*Hw2> myInit [1,2,3,4]
[1,2,3]

 g) map reverse . reverse . map reverse

This is the same as giving reverse a list of lists. The (map reverse)'s are
redundant in that one undoes the other. The reverse in the middle is all that
is really changing anything. The maps do enforce the list of lists requirement, 
though.

> lolReverse = map reverse . reverse . map reverse

*Hw2> lolReverse [[1,2,3],[4,5,6]]
[[4,5,6],[1,2,3]]
*Hw2> reverse [[1,2,3],[4,5,6]]
[[4,5,6],[1,2,3]]

Question 3:
-----------
Suppose that xs :: [Int], ys :: [[Int]], and zs :: [[[Int]]].
Write down expressions that you could evaluate:
 a) to calculate the number of integers in each of xs, ys, and zs

We just use the normal length function.

> countXs :: [Int] -> Int
> countXs = length

*Hw2> countXs [1,2,3]
3

This time we map length to each inner list, result in a list of lengths. We want
to add up all of those lengths for a grand total.

> countYs :: [[Int]] -> Int
> countYs = sum . map countXs

*Hw2> countYs [[1,2,3],[4,5,6]]
6

This time we look at the list of lists in each element of our outer list. We use
countYs because it will give us the number of Ints in each element of our outer
list. That will give us a list of counts. We just need to add it up.

> countZs :: [[[Int]]] -> Int
> countZs = sum . map countYs

*Hw2> countZs [[[1,2,3],[4,5,6]],[[7,8,9]]]
9

 b) to calculate the sum of the integers in each of xs, ys, and zs

We just need a normal sum for xs.

> sumXs :: [Int] -> Int
> sumXs = sum

*Hw2> sumXs [1,2,3]
6

Just like before we have a function sumXs that can find sums of lists, which is
what we have a list of. So we map that function to our list, giving us a list of
sums of each of the elements of our original list, which we then just add up.

> sumYs :: [[Int]] -> Int
> sumYs = sum . map sumXs

*Hw2> sumYs [[1,2,3],[4,5,6]]
21

And just like before, zs is one level deeper. We know that each element of zs is
a list of lists. We can find the sum of that with the function sumYs. So we map
that function to zs, giving us a list of sums of each element of zs, which we
just have to add up.

> sumZs :: [[[Int]]] -> Int
> sumZs = sum . map sumYs

*Hw2> sumZs [[[1,2,3],[4,5,6]],[[7,8,9]]]
45

 c) to determine whether xs is an element of ys
    [Hint: consider using a section of the equality operator, ==.]

This is the first fold I've ever written. I was pretty excited. First I decided
to use == to check whether a list in ys was equal to xs. I figured I'd map that
to the list to get a list of Bools. Then I wanted a way to see if there were any
Trues in that list, and realized that an or (||) would be perfect. I wanted to
combine all of the values of the resulting list with or, and this is what fold
does!

> xsInYs :: [Int] -> [[Int]] -> Bool
> xsInYs xs ys = (foldr (||) False) (map (==xs) ys)

*Hw2> xsInYs [1,2,3] [[1,2,3],[4,5,6]]
True

*Hw2> xsInYs [1,2,3] [[1,2,4],[1,2,5],[4,5,6]]
False

 d) to determine whether ys is an element of zs

This is the exact same function, but the type signatures are different. Since
the (==) works on lists and lists of lists apparently, the function didn't need
to be changed at all.

> ysInZs :: [[Int]] -> [[[Int]]] -> Bool
> ysInZs ys zs = (foldr (||) False) (map (==ys) zs)

*Hw2> ysInZs [[1,2,3],[4,5,6]] [[[1,2,3],[4,5,6]],[[1]],[[7,8]]]
True

*Hw2> ysInZs [[1,2,3],[4,5,6]] [[[1,2,3]],[[4,5,6]],[[1,2]],[[3,4]],[[5,6]]]
False

 e) to determine the position of xs in the list ys (you may assume
    for this part of the question that xs definitely is in the list
    ys.)

Okay I'm using one of the ideas I had for checking if xs is in ys. It didn't
work because takeWhile kind of assumes it's there. It ended up being perfect
when we assume it's there. Basically it checks to see if each value of ys is
xs. It stops when it finds it, and returns the list of elements preceding.
It turns out the length of that list is also the position of the element we
are searching for.

> whereIsXs :: [Int] -> [[Int]] -> Int
> whereIsXs xs ys = length (takeWhile (/=xs) ys)

*Hw2> whereIsXs [1,2,3] [[4,5,6],[1,2,3],[7,8,9]]
1

And to double check THAT.

*Hw2> [[4,5,6],[1,2,3],[7,8,9]] !! 1
[1,2,3]

Question 4:
-----------
Suppose that n :: Int.  Using the rules given in class, show how
the list comprehension 

  [ x - y | x <- [1..n], y <- [1..n] ]

can be rewritten in an equivalent form without comprehensions by
using the map and concat functions.  Use Hugs or GHCi to verify
that the two forms of the expression produce the same result for
some small values of n.

Here I used slide number 35 from last week, and followed the formula. The inner
y generator is converted to a map lambda, but then we map a lambda for x which 
includes y's lambda inside it.

> question4 n = [ x - y | x <- [1..n], y <- [1..n] ]
> q4_myAnswer n = concat (map (\x -> map (\y -> (x-y)) [1..n]) [1..n])

Describing how you arrive at your answer, explain what result you
will get by evaluating an expression of the following form:

  sum [ x - y | x <- [1..n], y <- [1..n] ]

(An informal, intuitive explanation is sufficient; you do not
need to give a formal proof, and you do not need to use a
version of this expression in terms of map and concat.)

My Answer:
I tried this with (n=3) in my head, and saw that it was zero. I verified this 
in the interpreter. I don't usually believe in coincidence. I tried (n=4) and 
(n=5) in the interpreter and convinced myself that it's always zero. I tried
to find symmetry in the list of values. Here's what I came up with.

If the final list is the following...

 [ x1-y1, x1-y2, x1-y3,
   x2-y1, x2-y2, x2-y3,
   x3-y1, x3-y2, x3-y3 ]

Then the sum will be

 x1-y1 + x1-y2 + x1-y3 +
 x2-y1 + x2-y2 + x2-y3 +
 x3-y1 + x3-y2 + x3-y3

Which can be rearranged (and still equivalent) as such

 (x1 + x2 + x3) * 3 +
 ((-y1) + (-y2) + (-y3)) *3

And yet another way to write this is

  (sum xs) * 3 - (sum ys) * 3

But WAIT!! xs and ys are both just [1..n]. Let's substitute ys for xs.

  (sum xs) * 3 - (sum xs) * 3

ZERO!!

(Optional extra: what result will you get from the expression:
  sum [ x | x <- [1..n], y <- [1..n] ]
?)

Because each value of x is repeated n times (thanks to the y generator),
you would get n * sum [1..n]

That is, if you separated the list from
[1,1,1,2,2,2,3,3,3]
into
[1,2,3,1,2,3,1,2,3]
it's obvious that (sum [1..n]) is going to need to be added to (n-1) other 
instances of (sum [1..n]). n * sum [1..n] is somewhat of a simplification of
the concept.

Note: at first I thought that since y wasn't being used the list comprehension
would produce [1..n]. It wasn't until I checked the answer in the interpreter
that I realized how wrong I was. Then I face-palmed and immediately understood
why each value of x is repeated n times.

> checknsumn n = sum [ x | x <- [1..n], y <- [1..n] ]
> nsumn n = n * sum [1..n]

Just some trivial double checking.

*Hw2> let n = 3
*Hw2> checknsumn n == nsumn n
True
*Hw2> let n = 4
*Hw2> checknsumn n == nsumn n
True
*Hw2> let n = 5
*Hw2> checknsumn n == nsumn n
True

--------------------------------------------------------------------------------
--############
--##EXERCISE##
--############ 

Implement the "How many trees will there be?" formula. Slide 26.

Also known as the Catalan Numbers.

(copied from PowerPoint, translated to simplified TeX for disambiguation)
Let t_n  = number of distinct binary tree shapes with n leaves: 
t_1 = 1
t_{n+1} = t_n t_1 + t{n-1} t_2 + ... + t_2 t_{n-1} + t_1 t_n 

Working out some examples to help myself understand it:

t_2 = t_1 t_1
    = 1 * 1
    = 1

t_3 = t_2 t_1 + t_1 t_2
    = 1 * 1   + 1 * 1
    = 2

t_4 = t_3 t_1 + t_2 t_2 + t_1 t_3
    = 2 * 1   + 1 * 1   + 1 * 2
    = 5 

The first few values in this sequence: 
[1,1,2,5,14,42,132,429,1430,4862,16796, ...]

So really we need to:
  - create 2 lists.
    [1..(n-1)] and [(n-1),(n-2)..1]
  - map catalan to each element.
  - obtain the product of corresponding elements (zipWith)
  - sum all of the elements

Another thing I realized is that we don't need 2 lists originally. By creating
one list of [1..(n-1)] and mapping catalan to it, we can just reverse the 
resulting list. Haskell's where clause is perfect for doing so.

> catalan 0 = 0
> catalan 1 = 1
> catalan n = sum (zipWith (*) xs (reverse xs))
>        where xs = map catalan [1..(n-1)]

> allCatalan = map catalan [1..]

*Hw2> take 11 allCatalan
[1,1,2,5,14,42,132,429,1430,4862,16796]

It works!