
Convenience wrapper for 'drat' and 'devtools'
=============================================

**Version**

0.1.3

**Description**

Building packages with 'devtools' is easy. Publishing packages with 'drat' is easy too. Combining both is two lines of code too much - hence 'dratful'. The package aims at making the check-build-publish workflow a super easy one-liner.

**License**

MIT + file LICENSE

**Installation**

(stable) developement versions:

``` r
install.packages("dratful", repos = "https://petermeissner.github.io/drat/")
```

**Putting packages into your repository (your own CRAN, your drat, ...)**

The following will:

-   check the package using `devtools::check()`
-   then (if no errors and warnings were produced) build it into a temporary directory using `devtools::build()`
-   then insert it into the drat repo (defaults to `~/git/drat`) using `drat::insertPackage()`

``` r
dratful::drat()
```

If less defaults and more fine control is needed `check_build_publish()` is a version of drat that allows to manipulate options for all three wrapped up fucntions.

**Getting packages from a drat repository**

While you can install packages from drat repositories as shown in the install section (using the repos option of `install.packages()`) or add repositories by using `drat::addRepo()` the dratful package offers an alternative way in line with devtools' install functions.

The following snippet showcases `install_drat` which takes a package name and a Github user name to use a Github hosted package repository as additional source for packages:

``` r
dratful::install_drat("dratful", "petermeissner")
```
