max_dist<- function (add,index,pool) {

  select = as.numeric()
  select[1] = index[1]
  removed = as.numeric()
  left = setdiff(index,select)
  
  while(length(select)<add){
    for (l in left){
      d = 10 # a random large number
      # compute the distance of each left datapoint to all the select 
        # datapoints and store the minimum
      for (s in select) {
      d = min(d,sqrt(sum((pool[l,1:2]-pool[s,1:2])**2)))
      }
      
      left = setdiff(left,l) # no matter selected or not no need to consider it in the 
                             # next iteration of while loop
      if (d > 0.35) {
        select = c(select,l)
        break
      }
    }
  }
  return(select)
}