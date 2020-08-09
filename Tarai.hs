module Main where
　
main :: IO ()
main = do
          print (tarai 14 7 0)
　
tarai :: Int -> Int -> Int -> Int
tarai x y z
    | x <= y    = y
    | otherwise = tarai (tarai (x-1) y z)
                        (tarai (y-1) z x)
                        (tarai (z-1) x y)
