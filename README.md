
<!--
README should be used to describe the program. Edit README.Rmd
not README.md. The .Rmd file can be knitted to parse real-code examples and
show their output in the .md file.

To knit, use devtools::build_readme() or outsider.devtools::build()

Edit the template to describe your program: how to install, import and run;
run exemplary, small demonstrations; present key arguments; provide links and
references to the program that the module wraps.

Learn more about markdown and Rmarkdown:
https://daringfireball.net/projects/markdown/syntax
https://rmarkdown.rstudio.com/
-->

# Run [`pathd8`](https://www2.math.su.se/PATHd8/) with `outsider` in R

[![Build
Status](https://travis-ci.org/dombennett/om..pathd8.svg?branch=master)](https://travis-ci.org/dombennett/om..pathd8)

> Date phylogenetic trees without a molecular clock.

<!-- Install information -->

## Install and look up help

``` r
library(outsider)
#> ----------------
#> outsider v 0.1.0
#> ----------------
#> - Security notice: be sure of which modules you install
module_install(repo = "dombennett/om..pathd8")
#> -----------------------------------------------------
#> Warning: You are about to install an outsider module!
#> -----------------------------------------------------
#> Outsider modules install and run external programs
#> via Docker <https://www.docker.com>. These external
#> programs may communicate with the internet and could
#> potentially be malicious.
#> 
#> Be sure to know the module you are about to install:
#> Is it from a trusted developer? Are colleagues using
#> it? Is it supposed to download lots of data? Is it
#> well used (e.g. check number of stars on GitHub)?
#> -----------------------------------------------------
#>  Module information
#> -----------------------------------------------------
#> program: pathd8
#> details: Estimating divergence times in large phylogenetic trees.
#> docker: dombennett
#> github: dombennett
#> url: https://github.com/dombennett/om..pathd8
#> image: dombennett/om_pathd8
#> container: om_pathd8
#> package: om..pathd8
#> Travis CI: Passing
#> -----------------------------------------------------
#> Enter any key to continue or press Esc to quit
# module_help(repo = "dombennett/om..pathd8")
```

<!-- Detailed examples -->

## Detailed example

<!-- Note: set eval=TRUE to run example and show output -->

``` r
library(outsider)
pathd8 <- module_import('pathd8', repo = 'dombennett/om..pathd8')
# Taken from manual
# https://www2.math.su.se/PATHd8/PATHd8manual.pdf
input_text <- "
Sequence length = 1823;

((((Rat:0.007148,Human:0.001808):0.024345,Platypus:0.016588):0.012920,(Ostrich:0.018119,Alligator:0.006232):0.004708):0.028037,Frog:0);

mrca: Rat, Ostrich, minage=260;
mrca: Human, Platypus, fixage=125;
mrca: Alligator, Ostrich, minage=150;
name of mrca: Platypus, Rat, name=crown_mammals;
name of mrca: Human, Rat, name=crown_placentals;
name of mrca: Ostrich, Alligator, name=crown_Archosaurs;

# my own notes, not executed by PATHd8
# fossil Archosaurus minage=260
# fossil Archaeopteryx minage=150
# fossil Eomaia minage=125
"

# write out input file as binary
input_file <- file.path(tempdir(), 'pathd8_input.txt')
input_connection <- file(input_file, 'wb')
write(x = input_text, file = input_connection)
close(input_connection)

# run pathd8
output_file <- file.path(tempdir(), 'pathd8_output.txt')
pathd8(input_file = input_file, output_file = output_file)
#> Calculation finished.

# check output
cat(readLines(con = output_file), sep = '\n')
#> 
#> 
#> ************************************************************************************************
#> *  d 8   C A L C U L A T I O N                                                                 *
#> ************************************************************************************************
#> 
#> Number of informative fixnodes:   1
#> Number of informative minnodes:   2
#> Number of informative maxnodes:   0
#> 
#> d8 tree    : ((((Rat:22.388060,Human:22.388060)crown_placentals:102.611940,Platypus:125.000000)crown_mammals:135.000000,(Ostrich:150.000000,Alligator:150.000000)crown_Archosaurs:110.000000):166.742712,Frog:426.742712);
#> 
#> Ancestor of          Ancestor of          Name                        Age  #Terminals              MPL         Rate *      minage      maxage
#> Rat                  Frog                 -                       426.743           6           86.333       0.202308           -           - 
#> Rat                  Alligator            -                       260.000           5           52.600       0.202308       260.0           - 
#> Rat                  Platypus             crown_mammals           125.000           3           44.667       0.357333       125.0       125.0 
#> Rat                  Human                crown_placentals         22.388           2            8.000       0.357333           -           - 
#> Ostrich              Alligator            crown_Archosaurs        150.000           2           22.000       0.146667       150.0           - 
#> 
#> 
#>   *) Rate = MPL / Age
#> 
#> 
#> ************************************************************************************************
#> *  M P L  C A L C U L A T I O N                                                                *
#> ************************************************************************************************
#> 
#> Clock test confidence: 0.950000
#> Clock tests          : 5   (one for each node)
#> Accepted             : 1
#> Rejected             : 4
#> 
#> MPL tree   : ((((Rat:8.000000,Human:8.000000)crown_placentals:36.666667,Platypus:44.666667)crown_mammals:7.933333,(Ostrich:22.000000,Alligator:22.000000)crown_Archosaurs:30.600000):33.733333,Frog:86.333333);
#> 
#> Ancestor of          Ancestor of          Name                            MPL             #Terminals      Clock test: Acc/Rej
#> Rat                  Frog                 -                        86.333 +/- 13.772               6      Acc
#> Rat                  Alligator            -                        52.600 +/- 8.803                5      Rej, prob=0.000004
#> Rat                  Platypus             crown_mammals            44.667 +/- 9.727                3      Rej, prob=0.012738
#> Rat                  Human                crown_placentals          8.000 +/- 3.917                2      Rej, prob=0.012419
#> Ostrich              Alligator            crown_Archosaurs         22.000 +/- 6.496                2      Rej, prob=0.000911
#> 
#> 
#> ************************************************************************************************
#> *  E N D  C A L C U L A T I O N                                                                *
#> ************************************************************************************************

# clean up
file.remove(input_file)
#> [1] TRUE
file.remove(output_file)
#> [1] TRUE
```

### Key arguments

The `pathd8` function takes just two arguments: `input_file` which
specifies the tree and the run parameters and `output_file` where the
resulting tree is saved.

## Links

Find out more by visiting the [PATHD8
homepage](https://www2.math.su.se/PATHd8/)

## Please cite

  - Estimating divergence times in large phylogenetic trees by Tom
    Britton, Cajsa Lisa Anderson, David Jacquet, Samuel Lundqvist and
    Kåre Bremer, found in *Systematic Biology* 56:5, pp 741 - 752 .
    (The abstract can be found
    [here](http://www.math.su.se/PATHd8/PATHd8-abstract.doc).)
  - Britton, T., B. Oxelman, A. Vinnersten, and K. Bremer. 2002.
    Phylogenetic dating with confidence intervals using mean path
    lengths. *Molecular Phylogenetics and Evolution* 24:58-65.
  - Bennett et al. (2020). outsider: Install and run programs, outside
    of R, inside of R. *Journal of Open Source Software*, In
review

## <!-- Footer -->

<img align="left" width="120" height="125" src="https://raw.githubusercontent.com/ropensci/outsider/master/logo.png">

**An `outsider` module**

Learn more at [outsider
website](https://docs.ropensci.org/outsider/). Want to build your
own module? Check out [`outsider.devtools`
website](https://docs.ropensci.org/outsider.devtools/).
