#' check - build and publish
#' @inheritParams devtools::build
#' @inheritParams drat::insertPackage
#' @param ... furhter arguments passed through to devtools::check()
#' @param manual For source packages: if FALSE, don't build PDF vignettes
#'        (--no-build-vignettes) or manual (--no-manual).
#' @seealso \link[devtools]{check} \link[devtools]{build} \link[drat]{insertPackage}
#' @export
check_build_publish <-
  function(
    pkg       = ".",
    binary    = FALSE,
    path      = tempdir(),
    repodir   = getOption("dratRepo", "~/git/drat") ,
    action    = "archive",
    commit    = FALSE,
    vignettes = TRUE,
    manual    = FALSE,
    args      = NULL,
    quiet     = FALSE,
    ...
  ){
  check <- devtools::check(pkg=pkg, ...)
  if( length(check$errors)+length(check$warnings) > 0 ){
    return(
      list(
        check   = check,
        build   = FALSE,
        success = FALSE
      )
    )
  }
  build <- devtools::build(pkg = pkg, path = path, binary = binary)
  drat::insertPackage(build, repodir = repodir, action = action, commit = commit)
  return(
    list(
      check   = check,
      build   = build,
      success = TRUE
    )
  )
}


#' build and publish
#' @inheritParams check_build_publish
#' @export
build_publish <-
  function(
    pkg       = ".",
    binary    = FALSE,
    path      = tempdir(),
    repodir   = getOption("dratRepo", "~/git/drat") ,
    action    = "archive",
    commit    = FALSE,
    vignettes = TRUE,
    manual    = FALSE,
    args      = NULL,
    quiet     = FALSE,
    ...
  ){
    build <- devtools::build(pkg = pkg, path = path, binary = binary)
    drat::insertPackage(build, repodir = repodir, action = action, commit = commit)
    return(
      list(
        build   = build
      )
    )
  }