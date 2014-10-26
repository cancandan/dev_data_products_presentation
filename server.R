library(shiny)
library(e1071)
library(ROCR)

rocplot=function(pred, truth, ...){
  predob = prediction (pred, truth)
  perf = performance (predob , "tpr", "fpr") 
  plot(perf ,...)
}


set.seed (1)
x=matrix(rnorm(200*2), ncol=2)
x[1:100,]=x[1:100,]+2
x[101:150,]=x[101:150,]-2
y=c(rep(1,150),rep(2,50))
dat=data.frame(x=x,y=as.factor(y))
train=sample(200,100)

bestfit=svm(y~., data=dat[train,], kernel="radial", gamma=2,cost=1,decision.values=T)
bestfitted=attributes(predict(bestfit,dat[train,],decision.values=T))$decision.values


shinyServer(
  function(input, output) {
    
    
    currentFit<- reactive({ 
      svm(y~., data=dat[train,], kernel="radial", gamma=input$gamma,cost=10^input$cost)
    })
        
    
    output$dataPlot<-renderPlot({
      plot(x[,2],x[,1],col=y)
    })
    
    
      output$newHist<-renderPlot({
        svmfit<-currentFit()        
        plot(svmfit , dat[train ,])
      })
      output$roc<-renderPlot({
        
        if (input$cost|| input$gamma) {    
          svmfit<-currentFit()          
          fitted=attributes(predict(svmfit,dat[-train,],decision.values=T))$decision.values          
          rocplot(fitted,dat[-train,"y"],main="ROC Curve for test data")
          rocplot(bestfitted ,dat[train ,"y"],add=T,col="red")
        } else {
          NULL
        }}
      )
    
  }
)