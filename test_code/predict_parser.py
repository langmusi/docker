import pandas as pd
import numpy as np
import statsmodels.api as sm
from numpy import NaN
#from sklearn.linear_model import LinearRegression
import argparse  # command line for input

df = pd.read_csv("C:/Users/LIUM3478/OneDrive Corp/OneDrive - Atkins Ltd/Work_Atkins/Docker/hjulanalys/wheel_prediction_data.csv", encoding = 'ISO 8859-1', sep = ";", decimal=",")
df.head()

new_data = pd.DataFrame({'Littera': [], 'VehicleOperatorName':[],
                        'LeftWheelDiameter': []})
def model(df):
    y = df[['km_till_OMS']].values
    X = df[["LeftWheelDiameter"]].values
    # With Statsmodels, we need to add our intercept term, B0, manually
    X = sm.add_constant(X)
    ols_model = sm.OLS(y, X, missing='drop')
    fitted_ols_model = ols_model.fit()
    print(fitted_ols_model.summary())
            
    return pd.Series(ols_model.fit().predict(X))

def group_predictions(df):
    predict_df = pd.DataFrame()
    predict_df = df.groupby(["Littera", "VehicleOperatorName"]).apply(model)
    return predict_df


pred = group_predictions(df)
pred = pred.to_frame()
pred.head()
pred.shape
pred.to_csv("./output/pred_output.csv")
print(pred.head())




