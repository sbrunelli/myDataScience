## Hypothesis Testing
##
## As MLB Analysts we're interested in testing the hypothesis
## that teams who make it to the postseason spend more money
## on salaries for their rosters
##

##################################################
##
##
##  DATA PREPARATION
##
##
##################################################
rm(list = ls())
library(dplyr)
source("dt_set_operations.R")

## Load the data
teams <- tbl_df(read.csv("./data/team.csv")) %>% filter(year >= 1985)
postseasons <- tbl_df(read.csv("./data/postseason.csv")) %>% filter(year >= 1985)
salaries <- tbl_df(read.csv("./data/salary.csv")) %>% filter(year >= 1985)

## Build a list of all teams that made to the postseason for each year
## I need all teams that won at least one round in the playoffs
## plus all those that lost at least one round in the playoffs
## and then I need to take the distinct of this result
tmp_winners <- postseasons %>% select(year, team_id_winner) %>% rename(team_id = team_id_winner)
tmp_losers <- postseasons %>% select(year, team_id_loser) %>% rename(team_id = team_id_loser)
postseason_teams <- unique(rbind(tmp_winners, tmp_losers))
tmp_all_teams <- teams %>% select(year, team_id)
regular_season_teams <- dt_setdiff(tmp_all_teams, postseason_teams)
rm(list = c("tmp_winners", "tmp_losers","tmp_all_teams"))
postseason_teams <- tbl_df(merge(postseason_teams, teams) %>% select(year, team_id, name, g, w) %>% mutate(PCT = round(w/g, digits = 3)) %>% select(year, team_id, name, PCT))
regular_season_teams <- tbl_df(merge(regular_season_teams, teams) %>% select(year, team_id, name, g, w) %>% mutate(PCT = round(w/g, digits = 3)) %>% select(year, team_id, name, PCT))
salaries <- salaries %>% group_by(year, team_id) %>% summarize(salary = sum(salary))

library(xlsx)
cpi <- read.xlsx("./data/cpiursai1977-2015.xlsx", sheetIndex = 1, rowIndex = 1:40, header = TRUE)
colnames(cpi) <- c("year", "cpi")
salaries <- merge(salaries, cpi, by = "year")
cpi2015 <- unique(salaries[salaries$year==2015,]$cpi)
salaries <- mutate(salaries, adj_salary = ((cpi2015 * salary) / cpi)/1E6)
salaries <- mutate(salaries, adj_salary = round(adj_salary, digits = 1))

postseason_teams <- merge(postseason_teams, salaries)
regular_season_teams <- merge(regular_season_teams, salaries)


###################################################
##
##  HYPOTHESIS FORMULATION
##
##  Null Hypothesis: mu_ps - mu_rs = 0
##  Alternative Hypothesis: mu_ps - mu_rs > 0
##
##  Confidence Level: 0.05
##
###################################################

## Before we do anything we need to check whether 
## the conditions for applying the methods are met
##
##  Are the two samples normaly distributed
hist(postseason_teams$salary)
hist(regular_season_teams$salary)
hist(postseason_teams$adj_salary)
hist(regular_season_teams$adj_salary)
## We might need to adjust for the price index

alpha <- 0.05

## First we need to calculate the 2 means
mu_ps <- mean(postseason_teams$adj_salary)
mu_rs <- mean(regular_season_teams$adj_salary)

## Test Characteristics
##
##  We're comparing 2 groups on a quantitative variable
##  therefore we'll perform a T-test
##
##  We'll consider the 2 groups as independent
##
##  1st of all calculate the difference between the 2 means
difference <- mu_ps - mu_rs

##  Than calculate the standard deviation of the difference
##  between the 2 means, using the formula
##
##  se = (mu_ps - mu_rs) / sqrt ((mu_ps^2/n_ps) + (mu_rs^2/n_rs)) 
n_ps <- nrow(postseason_teams)
n_rs <- nrow(regular_season_teams)
sd_ps <- sd(postseason_teams$adj_salary)
sd_rs <- sd(regular_season_teams$adj_salary)
se <- sqrt(((sd_ps^2)/n_ps) +((sd_rs^2)/n_rs))
t <- round(difference / se, digits = 2)

##  Given the Test Statistics, we can now
##   - calculate the p-value and compare it to alpha
##   - calculate the rejection region and see if
##      t falls within it or not
var_ps <- sd_ps^2
var_rs <- sd_rs^2
df <- ((var_ps/n_ps) + (var_rs/n_rs)) / ((1/(n_ps-1))*(var_ps/n_ps)+(1/(n_rs-1))*(var_rs/n_rs))
p_value <- pt(q = t, df = df, lower.tail = FALSE)
if (p_value < alpha) { print("p-value: Reject HO") } else { print("p-value: Do not reject H0") }

cutoff <- qt(p = (1-alpha), df = df)
if(t > cutoff) { print("rejection region: Reject HO") } else { print("rejection region: Do not reject H0") }

## As another alternative we can calculate the confidence interval for the
## mean difference
## CI = difference +/- t(alpha/2) * se
t_demi_alpha <- qt(p = (1 - alpha/2), df = df)
lower_bound <- difference - t_demi_alpha * se
upper_bound <- difference + t_demi_alpha * se
confint <- round(c(lower_bound, upper_bound), digits = 3)
if ( (lower_bound <= 0) & (0 <= upper_bound) ) { print("Confidence interval: Do not reject HO") } else { print("Confidence interval: Reject H0") } 


## Is there a correlation between salary and PCT?
all_teams <- dt_union(postseason_teams, regular_season_teams)
plot(all_teams$PCT~all_teams$adj_salary)
cor(x = all_teams$salary, y = all_teams$PCT, method="pearson")
## The plot and the Pearson's correlation coefficient
## suggest a very low correlation between the 2 variables


## Graphs generation
png("./images/histograms.png", width = 800)
par(mfrow = c(1,2), mar = c(5,5,3,3))
hist(postseason_teams$adj_salary, main = "Postseason Teams Salary", xlab = "salary", col ="wheat", breaks = 15)
hist(regular_season_teams$adj_salary, main = "Regular Season Teams Salary", xlab = "salary", col = "wheat", breaks = 15)
dev.off()

png("./images/rejection_region.png", width = 600)
par(bty = "n")
x <- seq(-10, 10, by = 0.001)
y = dt(x = x, df = df)
ndist <- data.frame(x = x, y = y)
cutoff <- qt(p = (1-alpha), df = df)
x1 <- min(which(ndist$x >= cutoff))  
x2 <- length(x)
plot(x, y, type = "l", main = "Rejection Region", xlab = "t", ylab = "probability")
with(ndist, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col="gray"))
abline(v = x[x1], lwd = 1, col = "gray", lty = 2)
text(x[x1+500], 0.125, "rejection region")
abline(v = t, lwd = 1, col = "gray", lty = 2)
text(x[x1+4800], 0.125, paste("t =",round(t, digits = 3)))
dev.off()

png("./images/confidence_interval.png")
par(bty = "n")
dotchart(difference, xlim = c(-max(confint), max(confint)), main = "Confidence Interval for Means Difference", xlab = "Salary Difference")
lines(x=confint, y=c(1,1))
dev.off()

png("./images/scatterplot_all_teams.png")
par(bty = "n")
with(all_teams, plot(adj_salary, PCT, xlab = "salary", main = "All Teams"))
dev.off()

png("./images/scatterplot_regular_season.png")
par(bty = "n")
with(regular_season_teams, plot(adj_salary, PCT, xlab = "salary", main = "Regular Season Teams"))
dev.off()

png("./images/scatterplot_postseason.png")
par(bty = "n")
with(postseason_teams, plot(adj_salary, PCT, xlab = "salary", main = "Postseason Teams"))
dev.off()