# Project Steps

## Introduction
In this projet I'll try to take a more comprehensive tour on the typical steps of a data science project. Once again I'll use and example from the sport world.In subsequent articles I'll try to concentrate my attention and apply other techniques to other fields as well.

What I want to accomplish here is to develop a predictive model for soccer results using **logistic regression**. 

As always I'll need to make some assumptions and some semplifications, because a production ready system would be impossible to develop in a few days. 

Logistic regression allows us to **estimate the probability of a dicothomic event**, that is an event that can have 2 possible outcomes: success / failure, won / loss, 1 / 0 and so on.  Soccer has 3 outcomes, because we europeans love our scoreless hard fought games :-).... I'll get around it considering losses and draws as "not won" outcomes when fitting the model.

## Project Steps
I have divided the article into different sections, one for each major project steps, in order to make some order in the presentation:

* **Getting the data**: the very first thing that I have to do is get the data that would allow me to build the model. What I want are match statistics data, like:
  - shots on goal
  - shots wide
  - number of yellow cards
  - corners
  - offsides
  - ...

I've searched the web for quite some time and my first hope was to find a web site with a database of these statistics, but it hasn't been the case, at least no one was satisfactory enough for me. until I bumped into this:


<br/>
<center>
<a href="http://www.legaseriea.it/it/serie-a-tim/archivio">
  <img src="./figure/lega_seriea.png" alt="Drawing" style="width: 300px; height: 400px"/>
</a>
</center>
<br/>


And then this:


<br/>
<center>
<a href="http://www.legaseriea.it/it/serie-a-tim/match-report/2015-16/UNICO/UNI/38/JUVSAM">
  <img src="./figure/match_report.png" alt="Drawing" style="width: 300px; height: 400px"/>
</a>
</center>
<br/>


and I was like...that is perfect!!! All that I have to do now is write a web scraper to extract that information from this web site and I'm good to go. For that I used **python** and [here you can see the notebook](./Crawler.ipynb) with all the code and some additional comments.

* **Integrating the data**: at this stage I want to integrate the data scraped for the diffent season into a single consistent view and prepare the final csv file that will be the input for the subsequent phases. For that there's another [notebook here](./Data Preparation.ipynb) with code and comments.

* **Exploratory Data Analysis**:

* **Features Enrichment**:

* **Fitting the Model**:

* **Model in Action**:
