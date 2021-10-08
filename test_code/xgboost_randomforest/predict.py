import pandas as pd

import numpy as np
from numpy import mean
from numpy import std
from numpy import NaN

from sklearn.datasets import make_regression
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedKFold
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

#from xgboost import XGBRFRegressor
import lightgbm as lgb
from lightgbm import LGBMRegressor

#from sklearn.linear_model import LinearRegression
dat = "C:/Users/LIUM3478/OneDrive Corp\OneDrive - Atkins Ltd/Work_Atkins/Docker/hjulanalys/wheel_prediction_data.csv"
df = pd.read_csv(dat, encoding = 'ISO 8859-1', sep = ";", decimal=",")
df.head()

df["Littera"] = df["Littera"].astype("category")
df["VehicleOperatorName"] = df["VehicleOperatorName"].astype("category")
y = df[['km_till_OMS']].values
X = df[["LeftWheelDiameter", "Littera", "VehicleOperatorName"]]
# one-hot encoding categorical variables
X = pd.get_dummies(X)

# Training and Testing Sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)

# create dataset for lightgbm
lgb_train = lgb.Dataset(X_train, y_train)
lgb_eval = lgb.Dataset(X_test, y_test, reference=lgb_train)

# specify your configurations as a dict
fit_params={"early_stopping_rounds":10, 
            "eval_metric" : 'rmse', 
            "eval_set" : [(X_test, y_test)],
            'eval_names': ['valid'],
            'verbose': 100,
            'feature_name': 'auto', # that's actually the default
            'categorical_feature': 'auto' # that's actually the default
           }


#n_estimators is set to a "large value". The actual number of trees build will depend on early stopping and 1000 define only the absolute maximum
clf = lgb.LGBMRegressor(num_leaves= 64, max_depth=-1, 
                         random_state=1234, 
                         silent=True, 
                         metric='None', 
                         n_jobs=4, 
                         n_estimators=1000,
                         colsample_bytree=0.9,
                         subsample=0.9,
                         learning_rate=0.2)


clf.fit(X_train, y_train, **fit_params)

# predict
y_pred = clf.predict(X_test, num_iteration=clf.best_iteration_, use_missing=False)
# eval
(np.nanmean((y_pred - y_test) ** 2))**0.5


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




