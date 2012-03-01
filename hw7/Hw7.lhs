> module Hw7 where

Russell Miller
CS457 Functional Programming Winter 2012

> import IOActions hiding (find)
> import System.IO

QUESTION 1: The find in Data.List

The first argument to the Data.List find is a predicate. This means a function 
that has the type "a -> Bool". The function "even" is a perfect example. The
second argument is a list of the type "[a]". The return value is a "Maybe a",
meaning if the find fails it returns "Nothing". 

The goal is to find the first element of the list that matches the predicate. 
Here are some examples.

Prelude Data.List> find even [2,3,4]
Just 2
Prelude Data.List> find even [1,3,5]
Nothing

> find      :: FilePath -> IO [FilePath]
> find path  = doesDirectoryExist path >>= \isDir ->
>              case isDir of
>                True  -> getDirectoryContents path
>                         >>= inIO (filter notDotDot)
>                         >>= mapM (find . (path </>))
>                         >>= inIO ((path :) . concat)
>                False -> return [path]
>  where notDotDot name = name /= "." && name /= ".."

> testFind = find "." >>= mapM_ putStrLn

*Hw7 Data.List> testFind 
.
./Hw7.lhs
./hw7.pdf
./IOActions.lhs
./Treedot.lhs

QUESTION 2: The find defined here

The first thing our find does is call the function doesDirectoryExist, which was
imported from System.Directory and returns a Bool which is True if the Filepath
given was a directory, and False otherwise. The return value is passed through
the ">>=" operator to a lambda function. The variable is named isDir and there
are two places to branch. Either the Filepath given was a real directory and we
take the first branch, or we take the second branch otherwise. The second branch
simply prints out the Filepath in a single element list. I don't really 
understand why.

Assuming we were given a real directory, which "testFind" does by passing the
current directory ("."), the next thing to do is look at the first branch of the
case statement. First we call getDirectoryContents, which is also part of 
System.Directory. This returns a list of entries in that directory. Next we
apply a filter to that list. We will only return elements of the list for which
the filter returns true, and the function we're using to filter is noDotDot. It
returns true when the file is anything but the "." (current directory) or ".."
(parent directory).

The next step is a recursive call on each of the files in the list. Using the
handy "</>" function to append "path" ++ "/" ++ ... where the last part is each
file in the list, we can now attempt to list contents of directories within the
original Filepath. Without even running the code I can tell that the reason we
filter out the "." and ".." directories is that the first one would cause the
current directory to be searched again each time it is searched. The ".." 
similarly would cause every directory above the current one to be searched. It's
possible it would attempt to reach every directory on the filesystem. However, 
since it would search "a/b" and then "a" again, then "b" again, finding ".." in
"b" it would repeat "a" each time -- an infinite loop.

The final step just makes a pretty print out of each file found, by flattening
the lists that each recursive call to find returned, with the Filepath appended
to the beginning of the resulting string.

[Mark: sorry if this is wordy. perhaps I will attempt to summarize in later 
  questions... I was basically writing about each line in the code as I went.]

> infixl -|

> (-|)  :: IO [FilePath] -> (FilePath -> IO Bool) -> IO [FilePath]
> g -| p = g >>= filterIO p

> filterIO         :: (a -> IO Bool) -> [a] -> IO [a]
> filterIO p []     = return []
> filterIO p (x:xs) = do b <- p x
>                        if b then filterIO p xs >>= inIO (x:)
>                             else filterIO p xs

> testPiping = find "." -| doesFileExist >>= mapM_ putStrLn

*Hw7> testPiping
./Hw7.lhs
./hw7.pdf
./IOActions.lhs
./Treedot.lhs

QUESTION 3: on infixl

I looked up infixl before reading this question or running the code, because I
was curious what it's all about. Apparently there is also infixr and just plain
infix. If you use infixr and run something like the following code:
  find dir -| filt1 -| filt2
you would be applying filt2 before filt1. It's counter-intuitive to do so,
since we're used to doing things like that left-to-right. If you used infix it
would not be associative. I believe that means you can't chain two filters 
together? If you used none, the only way to infix it would be with backticks:
  find dir `-|` filt1
I found out on haskell.org that "If no fixity declaration is given for a 
particular operator, it defaults to infixl 9." It would appear we didn't need to
do that.

> name       :: (FilePath -> Bool) -> FilePath -> IO Bool
> name p f    = return (p f)

> testName = find "."  -|  name ("hs" `isSuffixOf`) >>= mapM_ putStrLn

*Hw7> testName
./Hw7.lhs
./IOActions.lhs
./Treedot.lhs

> haskellFiles = name ("hs" `isSuffixOf`)

> testHaskFiles = find "." -| haskellFiles >>= mapM_ putStrLn

*Hw7> testHaskFiles 
./Hw7.lhs
./IOActions.lhs
./Treedot.lhs

It turns out these are all odd-number length file names.

*Hw7> find "." -| name (even . length) >>= mapM_ putStrLn
*Hw7> find "." -| name (odd . length) >>= mapM_ putStrLn
.
./Hw7.lhs
./hw7.pdf
./IOActions.lhs
./Treedot.lhs

QUESTION 4: rewriting previous expression to verify that those file names are in
fact odd length.

Regarding your e-mail response about this question, I hope it is acceptable 
that the only indication of a problem with the previous expression would be
printing the word "error" instead of the actual filename.

*Hw7> find "." -| name (odd . length) >>= mapM_ (\x -> if odd (length x) then putStrLn x else putStrLn "error")
.
./Hw7.lhs
./hw7.pdf
./IOActions.lhs
./Treedot.lhs

Also, here is an implementation of another student's idea. Putting the length
in the printout.

*Hw7> find "." -| name (odd . length) >>= mapM_ (\x -> if odd (length x) then putStrLn (x ++ " : " ++ show (length x)) else putStrLn "error")
. : 1
./Hw7.lhs : 9
./hw7.pdf : 9
./IOActions.lhs : 15
./Treedot.lhs : 13

Using the size function defined below:

*Hw7> find "." -| name ("hs" `isSuffixOf`) -| size (<1000) >>= mapM_ putStrLn
*Hw7> find "." -| name ("hs" `isSuffixOf`) -| size (<5000) >>= mapM_ putStrLn
./Treedot.lhs

*Hw7> :!ls -l
total 224
-rw-r--r--  1 russellmiller  staff   5971 Feb 29 21:43 Hw7.lhs
-rw-r--r--@ 1 russellmiller  staff   8796 Feb 29 18:17 IOActions.lhs
-rw-r--r--@ 1 russellmiller  staff   2898 Feb 29 18:18 Treedot.lhs
-rw-r--r--@ 1 russellmiller  staff  87772 Feb 23 18:30 hw7.pdf

> size    :: (Integer -> Bool) -> FilePath -> IO Bool
> size p f = do b <- doesFileExist f
>               if b then do h <- openFile f ReadMode
>                            l <- hFileSize h
>                            hClose h
>                            return (p l)
>                    else return False

QUESTION 5:

I've followed the guidelines in the size function, making sure the file exists
and applying p to the result of calling the hinted readFile function.

> contents    :: (String -> Bool) -> FilePath -> IO Bool
> contents p f = do b <- doesFileExist f
>                   if b then do c <- readFile f
>                                return (p c)
>                        else return False

*Hw7> find "." -| contents (even . length . lines) >>= mapM_ putStrLn
*** Exception: ./hw7.pdf: hGetContents: invalid argument (Illegal byte sequence)

Whoops! Doesn't work on pdf files!

*Hw7> find "." -| haskellFiles -| contents (even . length . lines) >>= mapM_ putStrLn
./Hw7.lhs
./IOActions.lhs

> display  :: FilePath -> IO Bool
> display f = do putStrLn f
>                return True

Previous expression, though now Hw7.lhs apparently has an odd number of lines.. 
:)

*Hw7> find "." -| haskellFiles -| contents (even . length . lines) -| display 
./IOActions.lhs
["./IOActions.lhs"]

It is recursively calling find on "IOActions.lhs" and since that is not a 
directory find returns [path]. I don't understand why it wasn't doing this 
before...

NOPE. It's that thing where GHCi does ">>= print" after all expressions! In Hugs
I got no such output.

QUESTION 6:

> queryUser  :: String -> IO Bool
> queryUser s = do putStr (s ++ " (y/n)? ")
>                  i <- getLine
>                  if i!!0 == 'y' || i!!0 == 'Y' then return True
>                                                else return False

Using Hugs:

Hw7> find "." -| haskellFiles -| size (<9000) -| queryUser -| display
./Hw7.lhs (y/n)? y
./IOActions.lhs (y/n)? n
./Treedot.lhs (y/n)? y
./Hw7.lhs
./Treedot.lhs

*Hw7> find "." -| haskellFiles -| size (<9000) -| queryUser -| display
./Hw7.lhs (y/n)? y
./IOActions.lhs (y/n)? n
./Treedot.lhs (y/n)? y
./Hw7.lhs
./Treedot.lhs
["./Hw7.lhs","./Treedot.lhs"]

More on the ">>= print"...

Using Hugs again:

Hw7> find "." -| haskellFiles -| size (<9000) -| queryUser -| display >>= print
./Hw7.lhs (y/n)? y
./IOActions.lhs (y/n)? n
./Treedot.lhs (y/n)? y
./Hw7.lhs
./Treedot.lhs
["./Hw7.lhs","./Treedot.lhs"]

Yep. That is just SILLY! Good thing someone went to all the work of writing 
Hugs! :)