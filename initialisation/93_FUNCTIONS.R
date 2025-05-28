# Wrappers for decade extraction
floor_decade    = function(value){ return(value - value %% 10) }
ceiling_decade  = function(value){ return(floor_decade(value)+10) }
round_to_decade = function(value){ return(round(value / 10) * 10) }

# Rounding function
round_bin = function(size, bin_size) { return (floor(size / bin_size) * bin_size + bin_size/2) }

#prettyNum with default ',' as big mark
pn = function(number, big.mark = ",") {
  return(prettyNum(number, big.mark = big.mark))
}

#prettyNum with no big mark
pnn = function(number) {
  return(pn(number, ""))
}

#Round to hundreds
rh = function(number) {
  return(r_to(number, 100))
}

#Round to thousands
rt = function(number) {
  return(r_to(number, 1000))
}

#Round to tens of thousands
rtt = function(number) {
  return(r_to(number, 10000))
}

#Round to hundreds of thousands
rht = function(number) {
  return(r_to(number, 100000))
}

#Rounds to a base (a multiple of 10)
r_to = function(number, base) {
  return(round(number / base) * base) 
}