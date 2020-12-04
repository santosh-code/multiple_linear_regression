library(readr)
library(plyr)
library(moments)
comp_sales<-read.csv(file.choose())
summary(comp_sales)
comp_sales$cd<- as.numeric(revalue(comp_sales$cd,c("yes"=1, "no"=0)))
comp_sales$premium<- as.numeric(revalue(comp_sales$premium,c("yes"=1, "no"=0)))
comp_sales$multi<- as.numeric(revalue(comp_sales$multi,c("yes"=1, "no"=0)))
str(comp_sales)
######univariet analysis
######price
hist(comp_sales$price,col="pink")
boxplot(comp_sales$price,col="pink",horizontal =T )
qqnorm(log(comp_sales$price),col="pink",pch=20)
qqline(log(comp_sales$price),col="pink")
skewness(comp_sales$price)
kurtosis(comp_sales$price)
########speed
hist(comp_sales$speed,col="pink")
boxplot(comp_sales$speed,col="pink",horizontal =T )
qqnorm(comp_sales$speed,col="pink",pch=20)
qqline(comp_sales$speed,col="pink")
skewness(comp_sales$speed)
kurtosis(comp_sales$speed)
########ram
hist(comp_sales$ram,col="pink")
boxplot(comp_sales$ram,col="pink",horizontal =T )
qqnorm(comp_sales$ram,col="pink",pch=20)
qqnorm(log(comp_sales$ram),col="pink",pch=20)
qqline(log(comp_sales$ram),col="pink")
skewness(comp_sales$ram)
kurtosis(comp_sales$ram)
pairs(comp_sales)
#########hd
hist(comp_sales$hd,col="pink")
boxplot(comp_sales$hd,col="pink",horizontal =T )
qqnorm(log(comp_sales$hd),col="pink",pch=20)
qqline(log(comp_sales$hd),col="pink")
skewness(comp_sales$hd)
kurtosis(comp_sales$hd)
###multi variet analysis
pairs(comp_sales,col="pink",pch=20)

library(corpcor)

cor2pcor(cor(comp_sales))
cor(comp_sales)
comp_sales1<-comp_sales[,-1]
model<-lm(price~.,data=comp_sales1)
summary(model)
plot(model)
library(car)
infIndexPlot(model, vars=c("Cook", "Studentized", "Bonf", "hat"),
             id=TRUE, grid=TRUE, main="Diagnostic Plots")
vif(model)
avPlots(model,id.n=2,id.cex=0.8,col="red")
##########1441,1701#####
model1<-lm(log(price)~.,data=comp_sales[-c(1441,1701),])

summary(model1)
plot(model1)
##########transformations##############
colnames(comp_sales)
model1<-lm(log(price)~speed+I(speed*speed)+hd+I(hd*hd)+ram+I(ram*ram)+screen+cd+multi+
             premium+ads+trend,data=comp_sales[-c(1441,1701),])
infIndexPlot(model1, vars=c("Cook", "Studentized", "Bonf", "hat"),
             id=TRUE, grid=TRUE, main="Diagnostic Plots")
summary(model1)
plot(model1,col="pink",pch=20)
vif(model1)
############train test###############
comp_sales1<-comp_sales[-c(1441,1701),-1]
n<-nrow(comp_sales)
n1<-n*0.8
n2<-n-n1
train<-sample(1:n,n1)
comp_train<-comp_sales[train,]
comp_test<-comp_sales[-train,]

model1<-lm(log(price)~speed+I(speed*speed)+hd+I(hd*hd)+ram+screen+I(screen*screen)+cd+multi+
             premium+ads+trend,data=comp_train)
pred<-predict(model1,newdata =comp_test,interval = "confidence")
pred_exp<-exp(pred)
pred_exp<-as.data.frame(pred_exp)
err<-pred_exp$fit-comp_test$price

rmse<-sqrt(mean(err*err))

pred<-predict(model1,newdata =comp_train,interval = "confidence")
pred_exp<-exp(pred)
pred_exp<-as.data.frame(pred_exp)
err<-pred_exp$fit-comp_train$price
rmse1<-sqrt(mean(err*err))
rmse1
############model1 train test################


###########model###########
comp_sales1<-comp_sales[-c(1441,1701),-1]
n<-nrow(comp_sales1)
n1<-n*0.8
n2<-n-n1
train<-sample(1:n,n1)
comp_train<-comp_sales1[train,]
comp_test<-comp_sales1[-train,]
model<-lm(log(price)~.,data=comp_sales1)
pred<-predict(model,newdata =comp_test,interval = "confidence")
pred_exp<-exp(pred)
pred_exp<-as.data.frame(pred_exp)
err<-pred_exp$fit-comp_test$price
rmse<-sqrt(mean(err*err))
rmse

pred<-predict(model,newdata =comp_train,interval = "confidence")
pred_exp<-exp(pred)
pred_exp<-as.data.frame(pred_exp)
err<-pred_exp$fit-comp_train$price

rmse1<-sqrt(mean(err*err))
rmse1
