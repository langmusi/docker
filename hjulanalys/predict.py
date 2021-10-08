import pandas as pd
import numpy as np
import statsmodels.api as sm
from numpy import NaN
import xgboot

# evaluate xgboost random forest ensemble for regression
from numpy import mean
from numpy import std
from sklearn.datasets import make_regression
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedKFold
from xgboost import XGBRFRegressor

#from sklearn.linear_model import LinearRegression

df = pd.read_csv("wheel_prediction_data.csv", encoding = 'ISO 8859-1', sep = ";", decimal=",")
df.head()

# evaluate xgboost random forest ensemble for regression

y = df[['km_till_OMS']].values
X = df[["LeftWheelDiameter", "Littera", "VehicleOperatorname"]]
# define the model
model = XGBRFRegressor(n_estimators=100, subsample=0.9, colsample_bynode=0.2)
# define the model evaluation procedure
cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=1)
# evaluate the model and collect the scores
n_scores = cross_val_score(model, X, y, scoring='neg_mean_absolute_error', cv=cv, n_jobs=-1)
# report performance
print('MAE: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

# def model(df):
#    
#     # With Statsmodels, we need to add our intercept term, B0, manually
#     X = sm.add_constant(X)
#     model = sm.OLS(y, X, missing='drop')
        
#     return np.squeeze(model.fit().predict(X))

# def group_predictions(df):
#     predict_df = pd.DataFrame()
#     predict_df = df.groupby(["Littera", "VehicleOperatorName"]).apply(model)
#     return predict_df

# model(df)
# pred = group_predictions(df)
# pred = pred.to_frame()
# pred.to_csv("./output/pred_output.csv")
# print(pred.head())




