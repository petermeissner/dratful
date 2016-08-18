#' the ultimative shortcut all-default function to check_build_publish()
#' @inheritParams devtools::build
#' @inheritParams drat::insertPackage
#' @export
dratful <-
  function(pkg=".", repodir=getOption("dratRepo", "~/git/drat")){
    res <- list()
    git <- list()
    # commit message
    desc    <- read_dcf(pkg)
    git_message <- paste(desc$Package, desc$Version, "[ dratful::dratful() ]")
    # try to access repo and make repo object
    repo <- tryCatch(
      git2r::repository(repodir),
      error = function(e){
        FALSE
      }
    )
    # git : pull
    git$pull <- git_pull(repo)
    # build package : check, build, put in repo
    res1 <- check_build_publish(pkg = pkg, repodir = repodir)
    if(res1$success){
      res2 <- check_build_publish(pkg = pkg, repodir = repodir, binary=TRUE)
    }else{
      return( list(source_package = res1, git = git) )
    }
    # git : add, commit, push
    if( res2$success ){
      git$add    <- git_add(repo)
      git$commit <- git_commit(repo, message=git_message)
      git$push   <- git_push(repo)
    }else{
      git$add    <- git_add(repo)
      git$commit <- git_commit(repo, message=git_message)
      git$push   <- FALSE
    }
    # add README.md and and index.html
    make_index_files(repodir)
    # return
    return( list(source_package=res1, binary_package=res2, git=git) )
  }

#' the ultimative shortcut all-default function to check_build_publish()
#' @inheritParams devtools::build
#' @inheritParams drat::insertPackage
#' @export
drat <-
  function(pkg=".", repodir=getOption("dratRepo", "~/git/drat")){
    check_build_publish(pkg = pkg, repodir = repodir)
  }




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
