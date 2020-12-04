library(readr)
start_up1<-read.csv(file.choose())
library(moments)

library(plyr)
library(fastDummies)
start_up_dum<-dummy_cols(start_up1$State)
merged_startup1<-cbind(start_up1,start_up_dum)
start_up<-merged_startup1[,-c(4,6,9)]



####univariet analysis-R & D###
hist(start_up$R.D.Spend,col="green")
boxplot(start_up$R.D.Spend,col="green",horizontal = T)
shapiro.test(start_up$R.D.Spend)
qqnorm(start_up$R.D.Spend,col='green',pch=20)
qqline(start_up$R.D.Spend,col='green')
skewness(start_up$R.D.Spend)
kurtosis(start_up$R.D.Spend)

##########adminstration#####
hist(start_up$Administration,col="green")
boxplot(start_up$Administration,col="green",horizontal = T)
shapiro.test(start_up$Administration)
qqnorm(start_up$Administration,col="green",pch=20)
qqline(start_up$Administration)
skewness(start_up$Administration)
kurtosis(start_up$Administration)

########marketing_spend###
hist(start_up$Marketing.Spend,col="green")
boxplot(start_up$Marketing.Spend,col="green",horizontal = T)
qqnorm(start_up$Marketing.Spend,col="green",pch=20)
qqline(start_up$Marketing.Spend,col="green")
shapiro.test(start_up$Marketing.Spend)
skewness(start_up$Administration)
kurtosis(start_up$Administration)
########profits#########.
hist(start_up$Profit,col="green")
boxplot(start_up$Profit,col="green",horizontal = T)
shapiro.test(start_up$Profit)
qqnorm(start_up$Profit,col="green",pch=20)
qqline(start_up$Profit,col="green")
shapiro.test(start_up$Profit)
skewness(start_up$Profit)
kurtosis(start_up$Profit)


####multi-variet analysis##
summary(start_up)
library(corpcor)
pairs(start_up,col="green",pch=20)
cor(start_up)
cor2pcor(cor(start_up))


###model

model<-lm(Profit~.,data = start_up)
summary(model)
###plot after model building
library(car)
plot(model)
infIndexPlot(model, vars=c("Cook", "Studentized", "Bonf", "hat"),
             id=TRUE, grid=TRUE, main="Diagnostic Plots")
infIndexPlot(model,id=3)
influencePlot(model,id=3)
avplot(model)
vif(model)
help(avPlots)
avPlots(model)
####removing influencing factor
model1<-lm(Profit~.,data = start_up[-c(50,15),])
summary(model1)
plot(pred$fit,start_up$Profit)
pred<-predict(model1,interval = "confidence")
pred<-as.data.frame(pred)
plot(model1,col="green",pch=20)#residuals are linear
vif(model1)

avPlots(model1,id.n=2,id.cex=0.8,col="red")
plot()
##r2=0.96,residual are linear hence it is the best model
####splitting train and test#####
startups<-start_up[-c(50,15),]
n<-nrow(startups)
n1<-n*0.7
n2<-n-n1
train<-sample(1:n,n1)
startups_train<-startups[train,]
startups_test<-startups[-train,]
####building model#####
model3<-lm(Profit~.,data =startups_train )
summary(model3)
###predict on test data##############
pred<-predict(model3,newdata =startups_test,interval = "confidence" )
pred<-as.data.frame(pred)
err<-pred$fit-startups_test$Profit
err_sqr<-err*err
err_mean<-mean(err_sqr)
err_sqrt<-sqrt(err_mean)
########predict on train data###########
pred<-predict(model3,newdata =startups_train,interval = "confidence" )
pred<-as.data.frame(pred)
err<-pred$fit-startups_train$Profit
err_sqr<-err*err
err_mean<-mean(err_sqr)
err_sqrt<-sqrt(err_mean)

##test_error=7984.531 and train_error=6838.876
