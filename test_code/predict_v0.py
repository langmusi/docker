import pandas as pd
import numpy as np
import statsmodels.api as sm
from numpy import NaN
import seaborn as sns
#from sklearn.linear_model import LinearRegression


df = pd.read_csv("C:/Users/LIUM3478/OneDrive Corp/OneDrive - Atkins Ltd/Work_Atkins/Docker/hjulanalys/wheel_prediction_data.csv", encoding = 'ISO 8859-1', sep = ";", decimal=",")
df.head()

# let's use the lmplot function within seaborn
grid = sns.lmplot(x = "LeftWheelDiameter", 
                  y = "km_till_OMS", 
                  row = "Littera", col = "VehicleOperatorName", 
                  data = df, height = 5)

def model(df):
    y = df[['km_till_OMS']].values
    X = df[["LeftWheelDiameter"]].values
    # With Statsmodels, we need to add our intercept term, B0, manually
    X = sm.add_constant(X)
    ols_model = sm.OLS(y, X, missing='drop')
    #fitted_ols_model = ols_model.fit()
    #print(fitted_ols_model.summary())
            
    return pd.Series(ols_model.fit().predict(X))


def group_predictions(df):
    predict_df = pd.DataFrame()
    predict_df = df.groupby(["Littera", "VehicleOperatorName"]).apply(model)
    #df.merge(predict_df, how="left", on=["Littera", "VehicleOperatorName"])
    return predict_df


model(df)
pred = group_predictions(df)
pred = pred.to_frame()


# mixed effects model
# https://www.kaggle.com/ojwatson/mixed-models
pred.head()
pred.shape
pred.to_csv("./output/pred_output.csv")
print(pred.head())




