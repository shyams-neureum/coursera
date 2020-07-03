## Put comments here that give an overall description of what your
## functions do

##
## Function: makeCacheMatrix
##
## Description: makeCacheMatrix creates a special vector, which is a list 
## containing 4 functions - get value of the vector, set value of the vector,
## get value of the matrix inverse and set value of the matrix inverse.
##
makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    set <- function(y){
        x <<- y
        m <<- NULL
    }
    
    get <- function() x
    setinverse <- function(invrs) m <<- invrs
    getinverse <- function() m
    
    list(set = set, 
         get = get, 
         setinverse = setinverse, 
         getinverse = getinverse)
}


##
## Function: cacheSolve
##
## Description: This function calculates the inverse of the special vector 
## created with the makeCacheMatrix function. It first checks if the inverse
## has already been calculated. If so, it gets the inverse from the cache and 
## skips the computation. Otherwise, it calculates the inverse of the matrix 
## and sets the value of the inverse in the cache via the setinverse function.
##
cacheSolve <- function(x, ...) {
        m <- x$getinverse()
        if(!is.null(m)){
            message("getting cached data")
            return(m)
        }
        data <- x$get()
        m <- solve(data, ...)
        x$setinverse(m)
        m
}
