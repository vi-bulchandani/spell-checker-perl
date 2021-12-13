# spell-checker-perl
a simple spell checker written in perl

### How to run?
```
./spell-checker.pl <INPUTFILE> <OUTPUTFILE>
```
Wrong word is displayed and suggestions are given after each wrong word.

### Algorithm used
It uses the levenshtien distance algorithm.
```dictionary.txt``` contains possible words.
Distance is set to 1 for corrections.
