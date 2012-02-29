{- Learning to Pass arguments between IO functions -}

returnHello :: IO String
returnHello = return "hello"

printAString :: String -> IO ()
printAString str = print (str ++ ".")

main = do returnHello >>= (\x -> return (x ++ " dude")) >>= printAString