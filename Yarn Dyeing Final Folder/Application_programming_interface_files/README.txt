# Esquel Dyeing Time Prediction（Shiny Web Application）

# Table of Contents
   * [Introduction](#introduction)
   * [Requirements](#requirements)
   * [Documentation](#documentation)
   * [User Interaction](#user interaction)
      * [Open the url directly in the browser](#open-the-url-directly-in-the-browser)
      * [Open the function through R studio](#open-the-function-through-R-studio)
   * [Time Prediction Function](#time-prediction-function)
      * [Function to deal with user input](#function-to-deal-with-user-input)
      * [Function to calculate the targeted time](#function-to-calculate-the-targeted-time)
      * [UI Object](#ui-object)
      * [Server Function](#server-function)
   * [Deployment](#deployment)
   * [Contribution](#contribution)
   * [Contact](#contact)
   * [Authors](#authors)



## Introduction

This is a R code collection and deployment introduction of Shiny Web Application of Esquel Dyeing Time Prediction.

content:

1. The way to provide interaction for users to predict total dyeing time.

2. The current way to deploy our interaction into a web application.



## Requirements

If you only want to use the exist web application, then only need to get connect to the website and open the url:

No need to intall and packages or environment.

If you want to modify the current codes and appliction, please follow the below steps.

Language:

- R version 4.0.3

IDE:

- R Studio (https://www.rstudio.com/products/rstudio/download/preview/)

Packages:

- shiny

- xgboost

- readxl

- ggplot2

Please don't forget to install the above packages before running the code.


## Documentation

This README only shows some the interaction part of this project. 

If you are interested in the project backgrounds of the project or detailed information of each model, 

You can check other documentations in the file.


## User Interaction

###  Open the url directly in the browser:

- [Here is the available URL](https://irisnan.shinyapps.io/Esquel_DyeingTime/)

Chrome browser is recommended.


###  Open the function through R studio:

- [Shiny Package](https://shiny.rstudio.com/tutorial/)

1. Prepare for R environment and use IDE to open file `shiny.R` 
 
2. Install the required libraries.
 
 Here is the code recommended:
 
> install.packages("shiny")


3. Execute R script with `run app` bottom.

4. Modify the interaction as you like: 

Building Web Applications with Shiny is comprised of four modules, will take you through the basics of Shiny, reactive programming, and building a user interface.


## Time Prediction Function

### Function to deal with user input

Because the models need dummy variables as input, this function is used to deal with data format for models to recognize.

### Function to calculate the targeted time

In this version, we use `Random Forest` as our final algorithm to create two models for predicting total time and total time without sample time.

We use saved models and residual data set to predict and show our results.

The codes for those models and data could be found in the file as well, named as `mymodel`.


### UI Object

For the UI object, we describe how panel looks like by defining frame and attributes. In the same time, we decribe the data formats of input and output.

By inputting various variables related to dyeing process, such as fabric type, colorist name, machine name etc. and targeted time range on the left side of the panel, it could automatically update and show the predicted total time and possibility of respectively time range with the plot of probability distribution on the right side.

### Server Function

We use server function to call the first two function, and define the relationship between our inputs and outputs.


## Deployment

- [Shinyapps.io](https://www.shinyapps.io/) 

Shinyapps.io is a self-service platform that makes it easy for you to share your shiny applications on the web in just a few minutes. Created by Rstudio.

It is free for now.


## Contribution

Any contribution is welcome!!


## Contact

* Suggestions and requests are welcome. 
* If you have any new requirements, please feel free to contact us and we will try our best to meet your needs.
* If you would like to support us in some other way, please contact with the following address.
* Please read the interface documentation carefully before using the new version. Most of your questions will be answered in the documentation.

## Authors

* HBS Sharks from Hongkong Business School
* Date:2021-06-20
- [Author address](https://github.com/irisblue/irisblue)


