import numpy as np
import pandas as pd
import matplotlib.pylab as plt
from scipy import stats
import pylab
import seaborn as sns
import statsmodels.formula.api as smf
import statsmodels.api as sm
comp_sales=pd.read_csv("C:/Users/USER/Desktop/Computer_Data.csv")
comp_sales.columns
dum1=pd.get_dummies(comp_sales.cd)
dum1.columns="cd_no","cd_yes"
dum2=pd.get_dummies(comp_sales.multi)
dum2.columns="multi_no","multi_yes"
dum3=pd.get_dummies(comp_sales.premium)
dum3.columns="premium_no","premium_yes"
merged_comp=pd.concat([comp_sales,dum1,dum2,dum3],axis="columns")
merged_comp.columns
final=merged_comp.drop(['Unnamed: 0','cd','multi','premium'],axis="columns")

########univariet analysis#######
####price
plt.hist(final.price)
plt.boxplot(final.price)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.price, dist="norm", plot=pylab)
pylab.show()
####speed
plt.hist(final.speed)
plt.boxplot(final.speed)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.speed, dist="norm", plot=pylab)
pylab.show()
####ram
plt.hist(final.ram)
plt.boxplot(final.ram)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.ram, dist="norm", plot=pylab)
pylab.show()
####hd
plt.hist(final.hd)
plt.boxplot(final.hd)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.hd, dist="norm", plot=pylab)
pylab.show()

#########multi-variet analysis########
sns.pairplot(final)
np.corrcoef(final)
corr = final.dropna().corr()
corr
final.columns
#########
model=smf.ols('price~speed+hd+ram+screen+ads+trend+cd_no+multi_no+premium_no',data=final).fit()
model.summary()
sm.graphics.influence_plot(model)
plt.show()

#########
final1=final.drop(final.index[1440])
final2=final1.drop(final1.index[1700])
model1=smf.ols('price~speed+I(speed^2)+hd+I(hd^2)+ram+I(ram^2)+screen+I(screen^2)+ads+trend+cd_no+multi_no+premium_no',data=final2).fit()
model1.summary()

######train test error of model
model=smf.ols('price~speed+hd+ram+screen+ads+trend+cd_no+multi_no+premium_no',data=final).fit()
from sklearn.model_selection import train_test_split
final1_train,final1_test=train_test_split(final,test_size=0.2)

pred=model.predict(final1_train)
err=pred-final1_train.price
merr=np.mean(err*err)
rmse=np.sqrt(merr)
rmse

pred=model.predict(final1_test)
err=pred-final1_test.price
merr=np.mean(err*err)
rmse=np.sqrt(merr)
rmse
####train error=283 and test=271 and r2 value =77.4
######train test error of model1
model1=smf.ols('price~speed+I(speed^2)+hd+I(hd^2)+ram+I(ram^2)+screen+I(screen^2)+ads+trend+cd_no+multi_no+premium_no',data=final).fit()
from sklearn.model_selection import train_test_split
final1_train,final1_test=train_test_split(final,test_size=0.2)

pred=model1.predict(final1_train)
err=pred-final1_train.price
merr=np.mean(err*err)
rmse=np.sqrt(merr)
rmse

pred=model1.predict(final1_test)
err=pred-final1_test.price
merr=np.mean(err*err)
rmse=np.sqrt(merr)
rmse

######train-error=266.77 and test error=274.5###r2=78.6


