
Convenience wrapper for 'drat' and 'devtools'
=============================================

**Version**

0.1.0

**Description**

Building packages with 'devtools' is easy. Publishing packages with 'drat' is easy too. Combining both is two lines of code too much - hence 'dratful'. The package aims at making the check-build-publish workflow a super easy one-liner.

**License**

MIT + file LICENSE

**Installation**

(stable) developement versions:

``` r
install.packages("dratful", repos = "https://petermeissner.github.io/drat/")
```

**Example Usage**

The following will:

-   check the package using `devtools::check()`
-   then (if no errors and warnings were produced) build it into a temporary directory using `devtools::build()`
-   then insert it into the drat repo (defaults to `~/git/drat`) using `drat::insertPackage()`

``` r
dratful::check_build_publish()
```
