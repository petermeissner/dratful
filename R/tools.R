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


