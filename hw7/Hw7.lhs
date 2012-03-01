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

