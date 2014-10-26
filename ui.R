library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("SVM classification example on random data"),
  sidebarPanel(
    h2("The data"),
    p("The first static graph on the right shows randomly generated data, see the presentation for details on how this data is generated"), 
    a("presentation",href="http://cancandan.github.io/dev_data_products_presentation"),
    h2("Parameters"),
    p("There are two parameters the svm algorithm expects, cost and gamma."),
    p("The dynamic graph below the first shows the classification plot for the training data."), 
    p("The dynamic graph at the bottom shows the ROC curve for the test data."),
    p("The 10-fold cross-validation on the training data reported best performance for cost=1 and gamma=2 and shown below for the test data as an unchanging red line. One can verify this by changing the parameters and checking when the curve hugs the top left corner. This corresponds to the max true positive and minimum false positive rates."),
    sliderInput('cost', 'Cost (in powers of ten)',value = 1, min = -1, max = 5, step = 1,),
    sliderInput('gamma', 'Gamma',value = 1, min = 0.1, max = 10, step = 0.1,)
  ),
  mainPanel(    
    plotOutput('dataPlot'),
    plotOutput('newHist'),
    plotOutput('roc')
  )
))