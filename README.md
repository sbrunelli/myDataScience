# myDataScience

What can Data Science do for us? What techniques are there and how can we use them to solve real problems. This repo contains my experiments, exercises and studies in the field of Data Science with a double focus:

1. From one side I want to try the algorithms and techniques that I study along the way.
2. From the other side I don't want to stop there and I want to take it step further, something that as a Data Scientist should alway be done in order to be successfull: I want to ask myself how can I use this algorithm in real case scenarios? What real problems can I solve with it? I am the Business talking now and all that I care is: how can this thing make my Organization better and help it be more successfull, no matter the field?


## Site Structure
The site will be divided in two different sections:

1. **examples**: it's intentionally going to be a section where the focus is on the application of the various techniques, not on the business relevance of the problems I'll try to solve.
	
2. **business**: here I will try to address more meaningfull business problems and the techniques that I apply will be just a tool to the reach a certain goal, but the focus will be on the actual scientific approach as to how to solve a problem, not on the tools used to do it.
	
## The Tools
I will try to diversify from time to time which tool I use. That is because I think each tool should be secondary to the problem we're faced with.
That said the main tools will be, even if I'll try not to limit myself to if:

* **R**: main statistical software
* **Python**: as an alternative to R
* **Excel**: just to prove that fancy statistical software may not be always absolutely necessary
* **Tableau**: when it comes to data visualizations I'll post links to Tableau Public
	
#Section 1: Examples
Here's the list of currently available examples:

* [Hypothesis Testing](./hypothesis testing): an example of the application of hypothesis testing to establish if the difference in two groups is statistically significant. **Business Question** : "Using the data from the Major League Basebell are the teams making the postseason spending more money for players salaries than those who don't?" (Follow the link and click on the .pdf file) 
[**TAGS**: Statistics, R, Hypothesis Testing]

* [Logistic Regresssion](./logistic regression/project_steps.md): in this example I use logistic regression to build a predictive model for soccer results. This	a little more involved example because it starts from the collection of data from the web by means of a simple web scraper, to their preparation, to a step of feature enrichement and only then are the data used to fit a statistical model. As a last step the model is used against real data.[**TAGS**: Logistic Regression, Web Crawler, Python, R, Tableau]

* Bayes Theorem: in this example I use an already existing predictive model (ref. Logistic Regression), and I show how to use bayesian inference to incorporate events and increase the power of the model's predictions.
	
#Section 2: Business
Here's the list of currently available real life applications of the techniques:

* [Is IBM's Dynamic Cubes faster than Oracle's Query Rewrite?](./performance evaluation): a customer has performances issues with its reports and dashboards and has to decide which technology to adopt. In a case where there's no clear winner, can we still make a scientific statement? (Follow the link and click on the .md file or the .pdf file) [**TAGS**: Oracle, IBM Dynamic Cubes, Dashboard Performances, Statistics, Hypothesis Testing, R]