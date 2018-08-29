library(arulesSequences)
library(dplyr)


### helper function to that will run the cSPADE algorithm based on
### a vector of support values and return a list of the results 
### at each level of support, along with sequence length and a 
### boolean for whether the sequence is maximal

minSupExp = function(a, b, obs) {
        # requires arguments of a, b, and obs: data in transaction form,
        # a vector of support vals, and the number of unique people 
        # represented by the transaction data
        results = vector("list", length = length(b))
        index = seq_along(b)
        names(results) = as.character(b)
        for (i in index) {
                seqs = cspade(a, parameter = list(support = b[i]))
                df = as(seqs, "data.frame")
                df$max = is.maximal(seqs)
                df$n = df$support * obs
                df$len = size(seqs)
                results[[i]] = df %>% 
                        select(sequence, len, support, n, max) %>%
                        arrange(len, desc(support), max)
        }
        return(results)
}



### full sequence mining function that will call the helper function
### above on a data frame of enrollment history

mineSeqs = function(x, y, dir_path) {
        # function that takes x, y, and dir_path: a data frame of form id, term, 
        # and course_number_full (i.e. course name); a sequence of support values; 
        # and a directory path at which to store a temporary file for creating
        # the data of class transaction
        prep = x %>%
                arrange(id, term, course_number_full) %>%
                rename(sequenceID = id, eventID = term) %>%
                mutate(course_number_full = gsub(" ", "-", course_number_full)) %>%
                arrange(course_number_full) %>%
                unique() %>%
                group_by(sequenceID, eventID) %>%
                summarise(events = paste(course_number_full, collapse = " ")) %>%
                ungroup()
  
        prep$sequenceID = format(prep$sequenceID, scientific = FALSE)
        prep$eventID = format(prep$eventID, scientific = FALSE)
  
        object_name = deparse(substitute(x))
        table_name = paste(object_name, "prepped.txt", sep = ".")
        table_name_w_path = paste(dir_path, table_name, sep = "")
  
        write.table(prep, table_name_w_path, sep = " ", row.names = FALSE, col.names = FALSE, quote = FALSE)
        ready.final = read_baskets(table_name_w_path, info = c("sequenceID", "eventID"))
        num_of_obs = length(unique(x$id))
        final = minSupExp(ready.final, y, num_of_obs)
  
        return(final)
}

