NCAA
====

Data and code for analyzing effects of NCAA baseball aluminum bat regulations

# Dissertation Project Details
This is the github repository for my dissertation, tentatively titled:
* _Perceptual-Cognitive Skills and Domain-Specific Expertise among Professional Baseball Umpires: A Quantitative Analysis of Ball-Strike Judgment and Decision Making._

## Background
I'll be using PITCHf/x data from the 2011 Major League Baseball (MLB) season to estimate umpires' ability to distinguish pitches which cross the front edge of home plate within a given batter's unique strike zone from those that do not enter the strike zone.  What distinguishes this project from the the work of others (e.g., [MacMahon & Starkes (2010)](http://www.ncbi.nlm.nih.gov/pubmed/18409106), [Fast (2007)](http://www.baseballprospectus.com/article.php?articleid=14572), and [Mills](http://princeofslides.blogspot.com/) ([2013a](http://jse.sagepub.com/content/early/2013/05/02/1527002513487740); [2013b](http://onlinelibrary.wiley.com/doi/10.1002/mde.2630/abstract)) is the theoretical foundation--which is rooted mainly in the educational, cognitive, and sport psychology traditions.

## Methodology
The data are arranged in a hierarchical format with pitch-level information at level one and umpire-level information at level two.  The umpire's decision on the location of each pitch is treated as a binary outcome variable (1 = correct; 0 = incorrect) in a generalized linear mixed model.

Level one predictor variables include:
```
Pitch location (1 of 9 strike zone regions; 1 of 4 ball zone regions)
Pitch count (0-0, 0-1, ..., 3-2)
```
Level two predictor variables include:
```
Umpire experience (in seasons)
Aggregated umpire postseason experience (in number of series assigned)
```

Feel free to contact me with questions, comments, and suggestions:
aaronbaggett@gmail.com
