library(readr)
library(moments)
Corolla<-read.csv(file.choose())

Corolla<-Corolla[c("Price","Age_08_04","KM","HP","cc","Doors","Gears","Quarterly_Tax","Weight")]
########univariet analysis-price############
hist(Corolla$Price,col="blue")
boxplot(Corolla$Price,col="blue",horizontal = T)
shapiro.test(Corolla$Price,col="blue")
qqnorm(log(Corolla$Price),col="blue",pch=20)
qqline(log(Corolla$Price),col="blue")
skewness(Corolla$Price)
kurtosis(Corolla$Price)

#######Age_08_04######
hist(Corolla$Age_08_04)
boxplot(Corolla$Age_08_04)
shapiro.test(Corolla$Age_08_04)
#######KM##########
hist(Corolla$KM)
boxplot(Corolla$KM)
shapiro.test(Corolla$KM)
#######HP########
hist(Corolla$HP,col="blue")
boxplot(Corolla$HP,col="blue",horizontal = T)
qqnorm(Corolla$HP,col='blue')
qqline(Corolla$HP,col='blue')
skewness(Corolla$HP)
kurtosis(Corolla$HP)
shapiro.test(Corolla$HP)
######cc#########
hist(Corolla$cc)
boxplot(Corolla$cc)
shapiro.test(Corolla$cc)
#######doors######
hist(Corolla$Doors)
boxplot(Corolla$Doors)
shapiro.test(Corolla$Doors)
#######gears##########
hist(Corolla$Gears)
boxplot(Corolla$Gears)
shapiro.test(Corolla$Gears)
######quartly tax#########
hist(Corolla$Quarterly_Tax)
boxplot(Corolla$Quarterly_Tax)
shapiro.test(Corolla$Quarterly_Tax)
#########multi-variet analysis########
pairs(Corolla,col='blue')
cor(Corolla)
library(corpcor)
cor2pcor(cor(Corolla))
vif(model)
########model##########
model<-lm(Price~.,data =Corolla )
vif(model)
summary(model)
########plots after model##
library(car)

avPlots(model,id.n=2,id.cex=0.8,col="red")
infIndexPlot(model, vars=c("Cook", "Studentized", "Bonf", "hat"),
             id=TRUE, grid=TRUE, main="Diagnostic Plots")
plot(model)
########model1##############
model1<-lm(log(Price)~.,data =Corolla[-c(81,961,222),] )
summary(model1)
plot(model1)
#######transformation#############
model2<-lm(Price~Age_08_04+I(Age_08_04^2)+KM+I(KM^2)+HP+I(HP*HP)+cc+I(cc^2)+Doors+I(Doors^2)+Gears+I(Gears*Gears)+Quarterly_Tax+I(Quarterly_Tax^2)+Weight+I(Weight^2),data =Corolla[-c(81,961,222),] )
summary(model2)
plot(model2,col="blue",pch=20)
#####best fit model######
Corolla_1<-Corolla[-c(81,961,22),]
n<-nrow(Corolla_1)
n1<-n*0.7
n2<-n-n1
train<-sample(1:n,n1)

c_train<-Corolla_1[train,]
c_test<-Corolla_1[-train,]
##################model2 _train_test
model2<-lm(Price~Age_08_04+I(Age_08_04^2)+KM+I(KM^2)+HP+I(HP*HP)+cc+I(cc^2)+Doors+I(Doors^2)+Gears+I(Gears*Gears)+Quarterly_Tax+I(Quarterly_Tax^2)+Weight+I(Weight^2),data =Corolla[-c(81,961,222),] )

pred<-predict(model2,newdata = c_train,interval ="confidence" )
pred<-as.data.frame(pred)
err=pred$fit-c_train$Price
err_sq<-err*err
rms<-sqrt(mean(err_sq))


pred1<-predict(model2,newdata =c_test,interval = "confidence" )
pred1<-as.data.frame(pred1)
errr=pred1$fit-c_test$Price
rm<-sqrt(mean(err*err))
##################model-train_test
model<-lm(Price~.,data =Corolla )

n<-nrow(Corolla)
n1<-n*0.7
n2<-n-n1
train<-sample(1:n,n1)

c_train<-Corolla[train,]
c_test<-Corolla[-train,]

pred<-predict(model,newdata = c_train,interval ="confidence" )
pred<-as.data.frame(pred)
err=pred$fit-c_train$Price
err_sq<-err*err
rms<-sqrt(mean(err_sq))


pred1<-predict(model,newdata =c_test,interval = "confidence" )
pred1<-as.data.frame(pred1)
errr=pred1$fit-c_test$Price
rm<-sqrt(mean(err*err))
