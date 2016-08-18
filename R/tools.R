#' extrac package names and version from PACKAGES file
#' @param p_description content of a PACKAGES file
#' @keywords internal
dsc_content <- function(p_description){
  versions <- grep("^Version: (\\d.*)", p_description, value=TRUE)
  versions <- regmatches(versions, regexpr("\\d\\S*", versions))
  packages <- grep("^Package", p_description, value = TRUE)
  packages <-
    unlist(
      lapply(
        regmatches(packages, regexpr("Package: ", packages), invert = TRUE),
        `[`,
        2)
    )
  paste(packages, versions, sep=" : ")
}

#' make index.html and README.md from PACKAGES files
#' @inheritParams drat
#' @keywords internal
make_index_files <- function(repodir){
  p_files       <- list.files(repodir, "PACKAGES$", recursive=TRUE, full.names = TRUE)
  p_description <- lapply(p_files, readLines)
  p_names <- unlist(regmatches(p_files, regexpr("bin.*|src.*", p_files)))
  residents <- lapply(p_description, dsc_content)
  head <- '<!DOCTYPE html>\n<html>\n<head>\n<meta charset="utf-8">\n<title>drat repo</title>\n</head><body>'
  content <- '
<h1>R package repository (drat)</h1>
<p>Visit https://github.com/eddelbuettel/drat and https://github.com/petermeissner/dratful to learn more.</p>
<p>Use the following to install packages from the repository:</p>

<pre>
install.packages(
  pkgs  = "package_name",
  repos =
    c(
      options("repos")$repos,
      "path_to_repository"
    )
)
</pre>


<p>the following packages reside within the repository:<p>
<pre>
'
  foot <- '</pre></body></html>'
  content2 <- character()
    for(i in seq_along(p_names)){
      content2 <-
        c(
          content2,
          paste(
            p_names[i],
            paste0(
              residents[[i]],
              collapse = "\n"
            ),
            sep="\n\n")
        )
    }
  content2 <- paste(content2, collapse = "\n\n\n")

  if(grepl("/$",repodir)){
    index_fname <- paste(repodir, "index.html", sep="")
  }else{
    index_fname <- paste(repodir, "index.html", sep="/")
  }

  writeLines(
    c(head, content, content2, foot),
    index_fname
  )

  head <- "
# R package repository (drat)

Visit https://github.com/eddelbuettel/drat and https://github.com/petermeissner/dratful to learn more

Use the following to install packages from the repository:

```r
install.packages(
  pkgs  = 'package_name',
  repos = c( options('repos')$repos, 'path_to_repository' )
)
```
the following packages reside within the repository:

"

  if(grepl("/$",repodir)){
    readme_fname <- paste(repodir, "README.md", sep="")
  }else{
    readme_fname <- paste(repodir, "README.md", sep="/")
  }

  writeLines(
    c(head, "```", content2, "```"),
    readme_fname
  )
}



#' installing from a github hosted drat and CRAN
#' @param pkg name of the package to be installed
#' @param username github username
#' @export
install_drat <- function(pkg, username="ghrr"){
  repos <- options("repos")$repos
  repos <- c(repos, drat=paste0("https://",username,".github.io/drat"))
  utils::install.packages(pkg, repos = repos)
}


#' git_pull
#' @param repo a git2r::repository() object
#' @keywords internal
git_pull <-  function(repo){
  git = FALSE
  if( class(repo) %in% "git_repository" ){
    git <- FALSE
    if( !passphrase()$iffer ){
      git <-
        tryCatch(
          { git2r::pull(repo); TRUE },
          error = function(e){FALSE}
        )
    }else{
      git <-
        tryCatch({git2r::pull(repo, credentials = pp_cred() ); TRUE}, error=function(e){FALSE})
    }
  }
  return(git)
}

#' git_add
#' @inheritParams git_pull
#' @keywords internal
git_add <-  function(repo){
  git = FALSE
  if( class(repo) %in% "git_repository" ){
    git <-
      tryCatch(
        { git2r::add(repo, "."); TRUE },
        error = function(e){FALSE}
      )
  }
  return(git)
}


#' git_commit
#' @param message git commit message
#' @inheritParams git_pull
#' @keywords internal
git_commit <-  function(repo, message = "-" ){
  git = FALSE
  if( class(repo) %in% "git_repository" ){
    git <-
      tryCatch(
        { git2r::commit(repo, message = message); TRUE },
        error = function(e){FALSE}
      )
  }
  return(git)
}

#' git_pull
#' @inheritParams git_pull
#' @keywords internal
git_push <-  function(repo){
  git = FALSE
  if( class(repo) %in% "git_repository" ){
    git <- FALSE
    if( !passphrase()$iffer ){
      git <-
        tryCatch(
          { git2r::push(repo); TRUE },
          error = function(e){FALSE}
        )
    }else{
      git <-
        tryCatch({git2r::push(repo, credentials = pp_cred() ); TRUE}, error=function(e){FALSE})
    }
  }
  return(git)
}


#' passphrase cred
#' @keywords internal
pp_cred <- function(){
  git2r::cred_ssh_key(passphrase = passphrase()$pp)
}


#' passphrase
#' @keywords internal
passphrase <- function(){
  res <- list()
  res$iffer <- FALSE
  res$pp    <- character(0)
  sys_pp <- Sys.getenv("dratful_ssh_passphrase")
  if( sys_pp == "" ){
    res$iffer <- FALSE
  }else{
    res$iffer <- TRUE
    if( sys_pp == "true" ){
      if( !("passphrase" %in% ls(storage)) ){
        res$pp <- rstudioapi::askForPassword("SSH Passphrase ? :")
      }else{
        res$pp <- storage$passphrase
      }
    }else{
      res$pp <- sys_pp
    }
    storage$passphrase <- res$pp
  }
  return(res)
}


#' storage
#' @keywords internal
storage <- new.env()

#' parsing DESCRIPTION files to lists
#' @param path path to package DESCRIPTION
#' @keywords internal
read_dcf <- function(path="."){
  if(file.info(path)$isdir){
    if(grepl("/$",path)){
      path <- paste0(path, "DESCRIPTION")
    }else{
      path <- paste0(path, "/DESCRIPTION")
    }
  }
  # parse
  tmp <- read.dcf(path)
  # transform
  names_dcf <- colnames(tmp)
  tmp <- as.list(tmp)
  names(tmp) <- names_dcf
  # return
  return(tmp)
}


