-- | Make sure this program runs without leaking memory
import FRP.Sodium
import Control.Applicative
import Control.Exception
import Control.Monad

verbose = False

main = do
    (et, _) <- sync newEvent
    t <- sync $ hold (0 :: Int) et
    (eChange, pushC) <- sync $ newEvent
    out <- sync $ do
        oout <- hold t $ (\_ -> t) <$> eChange
        switch oout
    kill <- sync $ listen (values out) $ \x ->
        if verbose then print x else (evaluate x >> return ())
    forM_ [0..] $ \i -> do
        sync $ pushC ()
    kill

