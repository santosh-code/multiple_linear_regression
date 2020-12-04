import pandas as pd
import numpy as np
import statsmodels.formula.api as smf
import statsmodels.api as sm
import statsmodels as sm
import seaborn as sns
import matplotlib.pylab as plt
import pylab 
import scipy.stats as stats
dataset=pd.read_csv("C:/Users/USER/Desktop/50_Startups.csv")
dataset.columns="R_D_SPEND","ADMINISTRATION","MARKETING_SPEND","STATE","PROFIT"
dummies=pd.get_dummies(dataset.STATE)
merge=pd.concat([dummies,dataset],axis='columns')
final=merge.drop(['STATE','Florida'],axis='columns')
final.columns="CALIFORNIA","NEWYORK","R_D_SPEND","ADMINISTRATION","MARKETING_SPEND","PROFIT"
######univarient analysis#########
#####r&d
plt.hist(final.R_D_SPEND)
plt.boxplot(final.R_D_SPEND)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.R_D_SPEND, dist="norm", plot=pylab)
pylab.show()
######administration######
plt.hist(final.ADMINISTRATION)
plt.boxplot(final.ADMINISTRATION)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.ADMINISTRATION, dist="norm", plot=pylab)
pylab.show()
#######marketing spent#######
plt.hist(final.MARKETING_SPEND)
plt.boxplot(final.MARKETING_SPEND)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.MARKETING_SPEND, dist="norm", plot=pylab)
pylab.show()
########profits#############
plt.hist(final.PROFIT)
plt.boxplot(final.PROFIT)
measurements = np.random.normal(loc = 20, scale = 5, size=100)   
stats.probplot(final.PROFIT, dist="norm", plot=pylab)
pylab.show()
########multi-variet analysis########
sns.pairplot(final)
np.corrcoef(final)
corr = final.dropna().corr()

#######model1########
#multi-collinearity check########
model1=smf.ols('PROFIT~CALIFORNIA+NEWYORK+R_D_SPEND+ADMINISTRATION+MARKETING_SPEND',data=final).fit()
model1.summary()
#####vif model#######
vif_model=smf.ols('MARKETING_SPEND~CALIFORNIA+NEWYORK+R_D_SPEND+ADMINISTRATION',data=final).fit()
vif_model.summary()
vif_MARKETING_SPEND=1/(1-(0.59*0.59))##vif=1.53

vif_model=smf.ols('R_D_SPEND~CALIFORNIA+NEWYORK+MARKETING_SPEND+ADMINISTRATION',data=final).fit()
vif_model.summary()
vif_R_D_SPEND=1/(1-(0.59*0.59))###1.53

vif_model=smf.ols('ADMINISTRATION~CALIFORNIA+NEWYORK+MARKETING_SPEND+R_D_SPEND',data=final).fit()
vif_model.summary()
vif_ADMINISTRATION=1/(1-(0.15*0.15))###1.02

############influentail factor check
sm.graphics.influence_plot(model1)
plt.show()

#######model2###########
final1=final.drop(final.index[49])###record-49 is more influential
model2=smf.ols('PROFIT~CALIFORNIA+NEWYORK+R_D_SPEND+ADMINISTRATION+MARKETING_SPEND',data=final1).fit()
model2.summary()

#######checking for train test error

from sklearn.model_selection import train_test_split
final1_train,final1_test=train_test_split(final1,test_size=0.2)

pred=model2.predict(final1_test)
err=pred-final1_test.PROFIT
mse=np.mean(err*err)
rmse=np.sqrt(mse)
rmse

pred=model2.predict(final1_train)
err=pred-final1_train.PROFIT
mse=np.mean(err*err)
rmse=np.sqrt(mse)
rmse
##train error=7279.08 and test error=7775.5
