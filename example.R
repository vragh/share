#For https://stackoverflow.com/q/65813740/9494044

#Let's assume the data is stored in the Excel file mydata.xlsx.
#Let's import it with the read_xlsx function from the readxl package.
#If you DON'T have the package installed, remove the # in the line below and run it.
#install.packages("readxl")
library(readxl)


#Reading the file into the R environment now.
#col_names is set to FALSE because the Excel file does not have named columns.
df <- readxl::read_xlsx("mydata.xlsx", col_names = FALSE)
df <- data.frame(df, stringsAsFactors = FALSE)


#Cleaning up the names a bit.
names(df) <- c("A", "B", "C", "D", "E")


#Let's take a peek at df.
head(df)
# A    B         C      D  E
# 1  1 <NA>    lawyer 120000 37
# 2 NA <NA>     clerk  60000 26
# 3 NA <NA>    doctor 250000 40
# 4 NA <NA> professor 110000 45
# 5 NA <NA>   dentist 198000 39
# 6 NA    X      <NA>     NA NA


#Let's first remove all extraneous rows: these are the ones where ALL columns are empty.
#For the sake of illustration, let's perform this with an inane for loop.
for(i in 1:nrow(df)){
  
  #Take just the current row.
  #That is, df[i, ].
  
  #If every column in the row is NOT empty,
  if(!all(is.na(df[i, ]))){
    
    #And if this is the first row,
    if(i == 1){
      
      #Throw it into a new data.frame newdf.
      newdf <- df[i, , drop = FALSE]
      
    } else{ #Otherwise,
      
      #If it's not the first row, then simply attach it to the end of newdf.
      newdf <- do.call("rbind", list(newdf, df[i, , drop = FALSE]))
      
    }
    
  }
  
}
rm(i) #Remove the indexing variable that the for loop was using.


#Just to torture ourselves, let's copy newdf back into df and remove it from the environment.
df <- newdf
rm(newdf)


#Now I suppose the objective is to get one data.frame for each number-to-alphabet subset (city?)?
#For the sake of elucidation, let's do this with a for loop once again.
#So the basic idea is that df is composed of many "mini" data.frames, each of whose "tails" are demarcated
#by a character in the column B. Column B is empty otherwise.
#We can use this fact to our advantage to split df into the constituent data.frames.
#For this, we need an additional indexing variable (j) which will be used to annotate the "head" of
#each "mini" data.frame in df.

#Our extra indexing variable will start at 1 (since we initally want it to mark the first row of df).
j <- 1

#So, looping through each row in df,
for(i in 1:nrow(df)){
  
  #If the current row's column B is NOT empty,
  if(!is.na(df$B[i])){
    
    #Then, take all rows from j to the (i-1)th position,
    #and put them in a data.frame called city_<whatever is the character
    #in column B>_df.
    assign(paste0("city_", df$B[i], "_df"), df[j:(i-1), ])
    
    #Now update j to mark the "head" of the next "mini" data.frame in df.
    #(This happens to be the (i+1)th position.)
    j <- i + 1
    
  }

}
rm(i, j) #Finally remove the indexing variables.


#Let's finally take a peek at the new data.frames we have created.
city_G_df
# A    B          C      D  E
# 18  1 <NA> copywriter 110000 35
# 19 NA <NA>   designer 123000 34
# 20 NA <NA>     singer 120000 31
# 21 NA <NA>  carpenter  90000 27
# 22 NA <NA>     waiter  65000 22

city_K_df
# A    B         C      D  E
# 10  1 <NA>    driver  70000 29
# 11 NA <NA> scientist 101000 39
# 12 NA <NA>   plumber  68000 30
# 13 NA <NA>      chef  85000 35
# 14 NA <NA>   manager 120000 41

city_X_df
# A    B         C      D  E
# 1  1 <NA>    lawyer 120000 37
# 2 NA <NA>     clerk  60000 26
# 3 NA <NA>    doctor 250000 40
# 4 NA <NA> professor 110000 45
# 5 NA <NA>   dentist 198000 39
