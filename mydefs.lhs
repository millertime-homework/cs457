Here are my notes:

> inits []     = []
> inits (x:xs) = [] : map (x:) (inits xs)

inits (1:2:3:[])
 = [] : map (1:) (inits (2:3:[]))
 = [] : map (1:) ([] : map (2:) (inits (3:[])))
 = [] : map (1:) ([] : map (2:) ([] : map (3:) (inits [])))
 = [] : map (1:) ([] : map (2:) ([] : map (3:) []))
 = [] : map (1:) ([] : map (2:) [[]])
 = [] : map (1:) ([] : [[2]])
 = [] : [[1], [1,2]]
 = [ [], [1], [1,2] ]

> mylast (x:[])    = x
> mylast (x:y:xs)  = last (y:xs)

