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

# https://www.kaggle.com/shreyagopal/suicide-rate-prediction-with-machine-learning
#from sklearn.linear_model import LinearRegression
dat = "C:/Users/LIUM3478/OneDrive Corp/OneDrive - Atkins Ltd/Work_Atkins/Docker/hjulanalys/wheel_prediction_data.csv"
df = pd.read_csv(dat, encoding = 'ISO 8859-1', sep = ";", decimal=",")
df.head()

df.groupby(['Littera','VehicleOperatorName']).size().reset_index().rename(columns={0:'count'})

y = df[['km_till_OMS']].values
X = df[["LeftWheelDiameter", "Littera", "VehicleOperatorName",
        "TotalPerformanceSnapshot", "maxTotalPerformanceSnapshot"]]
# X["Littera_Operator"] = X.Littera + " " + X.VehicleOperatorName
# X.drop(["Littera", "VehicleOperatorName"], axis = 1, inplace=True)

# converting object type to category for gradient boosting algorithms
def obj_to_cat(data):
    obj_feat = list(data.loc[:, data.dtypes == 'object'].columns.values)

    for feature in obj_feat:
        data[feature] = pd.Series(data[feature], dtype="category")

    return data

X = obj_to_cat(X)
    


# Training and Testing Sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)

# calling lightgbm method directly
# converting the specific Dataset data format
lgb_train = lgb.Dataset(X_train, y_train)
lgb_eval = lgb.Dataset(X_test, y_test, reference=lgb_train)

hyper_params = {
    'task': 'train',
    'boosting_type': 'gbdt',   # set promotion type
    'objective': 'regression',
    'metric': {'l2', 'auc'},  # evaluation function: rmse, l2 loss function
    'learning_rate': 0.5,
    'feature_fraction': 1, # The proportion of feature selection for tree building 
    "num_leaves": 20,  # number of leaf nodes
}


gbm = lgb.train(params=hyper_params, 
                train_set=lgb_train, valid_sets=lgb_eval, 
                num_boost_round=20, verbose_eval=False, early_stopping_rounds=5)

y_pred = gbm.predict(X_test)
y_pred = pd.DataFrame(y_pred)

# eval
(np.nanmean((y_pred - y_test) ** 2))**0.5


## sklearn
from lightgbm import LGBMRegressor # What was the problem at the beginning 
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import GridSearchCV

# model training （ Just as an ordinary model API To use , Set the parameters inside ）
gbm = LGBMRegressor(objective='regression', num_leaves=31, learning_rate=0.5, n_estimators=20)
gbm.fit(X_train, y_train, eval_set=[(X_test, y_test)], eval_metric='rmse', early_stopping_rounds=5)

gbm.best_iteration_
gbm.best_score_

y_pred = gbm.predict(X_test, num_iteration=gbm.best_iteration_)
y_pred = pd.DataFrame(y_pred)
# eval
(np.nanmean((y_pred - y_test) ** 2))**0.5


##############
y = df[['km_till_OMS']].values
X = df[["LeftWheelDiameter", "TotalPerformanceSnapshot", "maxTotalPerformanceSnapshot",
        "Littera", "VehicleOperatorName"]] 

## creating a function for modeling
def feature_generator (data, cat_convert = False):
    
    features_data = data
    
    # Create dummy variables with prefix 'Littera'
    features_data = pd.concat([features_data,
                               pd.get_dummies(features_data['Littera'], prefix = 'L')], 
                               axis=1)
    # VehicleOperatorName dummy
    features_data = pd.concat([features_data, 
                               pd.get_dummies(features_data['VehicleOperatorName'],
                                              prefix = 'V')], axis=1)

    if cat_convert == False:    
        # delete variables we are not going to use anymore
        del features_data['VehicleOperatorName']
        del features_data['Littera']
        
    return features_data     
    
# Generate features from training dataset
X = feature_generator(X)

def lightgbm_func(data, cat_convert=False):

    if cat_convert==True:
        # object is converted to category
        obj_feat = list(X.loc[:, X.dtypes == 'object'].columns.values)
        for feature in obj_feat:
            X[feature] = pd.Series(X[feature], dtype="category")

    
    # Training and Testing Sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)

    # calling lightgbm method directly
    # converting the specific Dataset data format
    lgb_train = lgb.Dataset(X_train, y_train)
    lgb_eval = lgb.Dataset(X_test, y_test, reference=lgb_train)

    hyper_params = {
        'task': 'train',
        'boosting_type': 'gbdt',   # set promotion type
        'objective': 'regression',
        'metric': 'rmse',  # evaluation function: rmse, l2 loss function, {'l2', 'auc'}
        'learning_rate': 0.3,
        'feature_fraction': 1, # The proportion of feature selection for tree building 
        "num_leaves": 31,  # number of leaf nodes
    }


    gbm = lgb.train(params=hyper_params, 
                    train_set=lgb_train, valid_sets=lgb_eval, 
                    num_boost_round=20, verbose_eval=False, early_stopping_rounds=5)

    y_pred = gbm.predict(X_test)
    y_pred = pd.DataFrame(y_pred)

    # eval
    return (np.nanmean((y_pred - y_test) ** 2))**0.5

   

## 
df.groupby(["Littera", "VehicleOperatorName"]).nunique()
df_small = df.loc[(df["Littera"] == "REGINA") & (df["VehicleOperatorName"] == "SJAB TÅG I BERGSLAGEN")]
df_small = df.loc[(df["Littera"] == "REGINA") & (df["VehicleOperatorName"] == "SJAB VÄNERTÅG")]

y = df_small[['km_till_OMS']].values
X = df_small[["LeftWheelDiameter", "TotalPerformanceSnapshot", "maxTotalPerformanceSnapshot"]]
       # "Littera", "VehicleOperatorName"]] 
X = feature_generator(X)
lightgbm_func(df_small)




