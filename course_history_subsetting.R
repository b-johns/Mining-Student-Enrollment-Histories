library(dplyr)


### function to subset course enrollment history to classes taken
### prior to course of interest, for those who ever took that course

beforeClass = function(x, y) {
  # where x is a data frame of form: id, term, course_number_full (i.e. course name)
  # and y a length-one character vector specifying a particular course
  results = x %>%
    arrange(id, term, course_number_full) %>%
    unique() %>%
    mutate(class_ind = if_else(course_number_full == y, 1, 0)) %>%
    group_by(id) %>%
    filter(any(class_ind > 0)) %>%
    select(id, term, course_number_full) %>%
    mutate(class_term = if_else(course_number_full == y, term, as.double(NA))) %>%
    mutate(class_term_all = min(class_term, na.rm = TRUE)) %>%
    filter(term <= class_term_all) %>%
    ungroup() %>%
    select(id, term, course_number_full)
  
  return(results)
  
}






