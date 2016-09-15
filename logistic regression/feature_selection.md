# Feature Selection

This step is actually pretty easy: its goal is to identify those variables and those season, where the concentration of NOT NULL values is highest. This will be the subset of data that I will use for the features engineering phase and that will be fed as input to the model.

For this phase I switch tools: I'll use R for the calculations and Tableau to display the results.

A word of advice here: I could have done this entire phase only in R. The reason I build a Data Viz nonetheless is that, if in another project I'm faced with the problem to identify the data concentration among thousands of variables or tens of thosands of those, then the **summary** function of R would not be a choice.

I'm thinking Data Science applied to Big Data here, and I want to experiment a way to visualize my Data Concentration.

I also talk about Data Concentration and I intentionally avoid the word Information Concentration. All these variables right now are just raw data. I still don't know if any one of them conveys significant Information for the problem that I'm trying to solve. I'll get to these point over the next steps of this project. For nowI'm ok with the premise that most likely the Information will be there where the Data are. And I go after the Data.

For the transformations I'll use the **dplyr** library.



I then read in the data


```r
statistics <- read.csv("./data/Statistics.csv", na.strings = "")
statistics <- mutate(statistics, gam = as.factor(gam))
head(statistics, 3)
```

```
##       sea gam        tea        opp  ven gs ga yc yc_o ass ass_o rwa rwa_o
## 1 1986-87   1   AVELLINO FIORENTINA home  2  1 NA   NA  NA    NA  NA    NA
## 2 1986-87   1 FIORENTINA   AVELLINO away  1  2 NA   NA  NA    NA  NA    NA
## 3 1986-87   1    BRESCIA     NAPOLI home  0  1 NA   NA  NA    NA  NA    NA
##   lwa lwa_o ca ca_o cnt cnt_o cor cor_o cro cro_o dyc dyc_o rc rc_o fou_o
## 1  NA    NA NA   NA  NA    NA  NA    NA  NA    NA  NA    NA  0    1    NA
## 2  NA    NA NA   NA  NA    NA  NA    NA  NA    NA  NA    NA  1    0    NA
## 3  NA    NA NA   NA  NA    NA  NA    NA  NA    NA  NA    NA  0    0    NA
##   fou off off_o lb lb_o gc gc_o ww ww_o bl bl_o br br_o blk blk_o  pos
## 1  NA  NA    NA NA   NA NA   NA NA   NA NA   NA NA   NA  NA    NA <NA>
## 2  NA  NA    NA NA   NA NA   NA NA   NA NA   NA NA   NA  NA    NA <NA>
## 3  NA  NA    NA NA   NA NA   NA NA   NA NA   NA NA   NA  NA    NA <NA>
##   pos_o pen pen_o ts ts_o shoff shoff_o shofffk shoffk_o shoffss shoffss_o
## 1  <NA>  NA    NA NA   NA    NA      NA      NA       NA      NA        NA
## 2  <NA>  NA    NA NA   NA    NA      NA      NA       NA      NA        NA
## 3  <NA>  NA    NA NA   NA    NA      NA      NA       NA      NA        NA
##   shon shon_o shoonb shoonb_o shonfk shonfk_o shonss shonss_o
## 1   NA     NA     NA       NA     NA       NA     NA       NA
## 2   NA     NA     NA       NA     NA       NA     NA       NA
## 3   NA     NA     NA       NA     NA       NA     NA       NA
```
For each indicator I now want to calculate the percentage of NULL values at the season level.
The code is shown here, for reproducibility's sake. I'll comment on it very quickly:

1. First I calculate the number of NAs for each statistic (variables 6 through 63) and aggregate over the season.
2. Then in a separate data frame I calculate the number of rows for each season.
3. I then join the two data frame and divide the number of NAs by the total number of rows for a particulare season.

The other points are just syntactical sugars in order to have meaningfull labels for the seasons factor variable.


```r
vars = names(statistics)[6:length(statistics)]
statistics.nas <- statistics %>%
                          mutate_each_(funs(is.na), vars = vars) %>%
                          group_by(sea) %>%
                          summarise_each_(funs(sum), vars = vars)

statistics.nrows <- statistics %>% group_by(sea) %>% summarise(nrows = n())
statistics.merge <- merge(statistics.nas, statistics.nrows)
sea.levels <- levels(statistics.merge$sea)
df1 <- sapply(statistics.merge, function(c) {if (is.factor(c)) {c} else {c/statistics.merge$nrows}})
df2 <- as.data.frame(df1)
statistics.heatmap <- mutate(df2, sea = factor(sea, labels = sea.levels))
```

Once again I dump the results as a csv to be used by Tableau now.


```r
write.csv(x = statistics.heatmap, file = "./data/statistics.heatmap.csv", na = "", row.names = FALSE)
```

### Interpreting the Results
The Tableau Dashboard can be found [here].(https://public.tableau.com/profile/stefano.brunelli#!/vizhome/EDA_6/DataStory).

It's pretty clear that there are 2 big Cluster of Data. Prior to the 2003-04 season only a few variables were tracked. From 2003-04 we have a lot more data at disposition.

We'll decide to only use those seasons.

Even then, some variables are still pretty much useless and we'll discard them too.

In the Story Point "What if we would like to only keep the mostly concentrated variables?" we basically select the statistics that will be passed to the **features engineering** phase.

