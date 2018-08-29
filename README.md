# Mining Student Enrollment Histories

Basic tabulation of unique course enrollment histories can potentially obscure similar sub-structure in those histories. 
Sequence mining can help find frequent enrollment patterns and sub-patterns that might otherwise be missed.

Subsetting enrollment histories to the enrollment records that preceded a specific course event is a useful way to focus the 
search for these frequent patterns (e.g. focusing on the STEM coursework that preceded a particular STEM milestone). In 
course_history_subsetting.R, I create a short function to speed this subsetting on data frames formatted with an id column, a
numeric term value column, and a character column of course name. In this form, a student taking multiple classes in a given 
term will have multiple rows in the data frame for that term.

Then in course_sequence_mining.R, I create my sequencing code, based on the arulesSequences package. I structure my functions
to run and report patterns at many levels of support, as well to report additional characteristics of patterns like length, and
whether the pattern is maximal.
