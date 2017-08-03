import System.Environment (getArgs)
import Data.Function ((&))
import Control.Arrow ((>>>), (&&&))
import Graphics.Gloss.Interface.Pure.Display (Display(InWindow))
import Graphics.Gloss.Interface.Pure.Simulate (simulate)
import Graphics.Gloss.Data.Picture (Path, Point, line)
import Graphics.Gloss.Data.Color (white)

imgSize :: Num a => a
imgSize = 800

main :: IO ()
main = do   (fileName : _) <- getArgs
            init <- normalize . map readPoint . lines <$> readFile fileName
            let window = InWindow fileName (imgSize, imgSize) (100, 20)
            
            simulate window white 1 (init, False) (line . fst) $
                \_ _ (path, done) -> if done then (path, done) else
                    let next = normalize (iterFractal init path)
                    in (next, length next > 100000)

readPoint :: String -> Point
readPoint = words >>> map read >>> ((!! 0) &&& (!! 1))

-- normalize size and location
normalize :: Path -> Path
normalize vertices = do (x, y) <- vertices
                        let newX = (x - minX) * scale - 0.9 * imgSize / 2
                        let newY = (y - minY) * scale - 0.9 * imgSize / 2
                        return (newX, newY)
    where
        minX = vertices & map fst & minimum
        minY = vertices & map snd & minimum
        width  = (vertices & map fst & maximum) - minX
        height = (vertices & map snd & maximum) - minY
        scale = 0.9 * imgSize / max width height

-- pre: path contains at least 2 vertices, and the last vertex is distinct from the first
iterFractal :: Path -> Path -> Path
iterFractal base current = do
    ((v1_x, v1_y), (v2_x, v2_y)) <- current `zip` tail current

    let segWidth  = v2_x - v1_x
    let segHeight = v2_y - v1_y
    let segAngle = atan2 segHeight segWidth
    let angleToRotate = segAngle - pathAngle

    let base' = base
            & map (\(x,y) -> (x - xStart, y - yStart)) -- translate to origin
            & map (rotate angleToRotate) -- rotate

    let size (x, y) = sqrt (x * x + y * y)
    let beforeScalePoint = last base'
    let afterScalePoint = (segWidth, segHeight)
    let proportion = size afterScalePoint / size beforeScalePoint

    base'
        & map (\(x,y) -> (x * proportion, y * proportion)) -- scale down size
        & map (\(x,y) -> (x + v1_x, y + v1_y)) -- translate to segment location

    where
        (xStart, yStart) = head base
        (xEnd  , yEnd  ) = last base
        pathAngle = atan2 (yEnd - yStart) (xEnd - xStart)

-- rotate the given point around the origin
rotate :: Float -> Point -> Point
rotate angle (x, y) = (newX, newY)
    where
        newX = x * cos angle - y * sin angle
        newY = x * sin angle + y * cos angle
