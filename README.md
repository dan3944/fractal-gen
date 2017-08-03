# fractal-gen

This program is a toy project of mine that generates fractals.

Given an initial path specified in a text file, it will repeat that shape in an animation to generate a fractal, and will continue until it is rendering at least 100,000 line segments.

For example, to specify a right angle whose coordinates are (0, 0), (0, 1), (1, 1) one would create a text file with the following contents:
```
0 0
0 1
1 1
```
This will generate the [Levy C Curve](https://en.wikipedia.org/wiki/L%C3%A9vy_C_curve). More examples of input paths are in the examples folder.

(Note: the rule this algorithm uses to generate fractals doesn't work if the starting point is the same as the end point.)

To run the program, do `runhaskell fractals.hs <inputfile>`. For example, `runhaskell fractals.hs examples/eyes.txt`.

This was developed in GHC 7.10.3 using the Gloss graphics package for Haskell. To use Gloss, run `cabal install gloss` or `stack install gloss`.
