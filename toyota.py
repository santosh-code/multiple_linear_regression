import pandas as pd
cor=pd.read_csv("C:/Users/USER/Desktop/ToyotaCorolla.csv",encoding= 'unicode_escape')
dataset=cor[['Price','Age_08_04','KM','HP','Doors','cc','Gears','Quarterly_Tax','Weight']]
dataset=pd.DataFrame(dataset)
import numpy as np
import scipy
from scipy import stats
import statsmodels.formula.api as smf
import matplotlib.pylab as plt
import seaborn as sns
import statsmodels.api as sm
########univariet analysis
plt.hist(dataset.Price)
plt.boxplot(dataset.Price)



#######multi variet analysis########
cor_cof=np.corrcoef(dataset)
sns.pairplot(dataset)
#######model
model=smf.ols('Price~Age_08_04+KM+HP+Doors+cc+Gears+Quarterly_Tax+Weight',data=dataset).fit()
model.summary()
##multiple r2 =0.86 and adjusted r2=0.86


fig = sm.graphics.influence_plot(model)


model=smf.ols('Price~Age_08_04+I(Age_08_04^2)+KM+(KM^2)+HP+(HP^2)+Doors+(Doors^2)+cc+I(cc^2)+Gears+I(Gears^2)+Quarterly_Tax+I(Quarterly_Tax^2)+Weight+I(Weight^2)',data=dataset1).fit()
model.summary()


##########train and test##########
from sklearn.model_selection import train_test_split
dataset1_train,dataset1_test=train_test_split(dataset1,test_size=0.2)

model=smf.ols('Price~Age_08_04+I(Age_08_04^2)+KM+(KM^2)+HP+(HP^2)+Doors+(Doors^2)+cc+I(cc^2)+Gears+I(Gears^2)+Quarterly_Tax+I(Quarterly_Tax^2)+Weight+I(Weight^2)',data=dataset1_train).fit()
pred=model.predict(dataset1_test)
#######multuple r2 0.89   and adjustedr2=0.89

err=pred-dataset1_test.Price
err_sqr=err*err
err_mean=np.mean(err_sqr)
err_sqrt=np.sqrt(err_mean)
err_sqrt
pred=model.predict(dataset1_train)
err=pred-dataset1_train.Price
err_sqr=err*err
err_mean=np.mean(err_sqr)
err_sqrt=np.sqrt(err_mean)
err_sqrt
##########train error=1179.6681 and test error=1126.40
###right fit model
