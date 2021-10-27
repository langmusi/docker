import pandas as pd
import numpy as np

from util import ReadPrep, TrainTestCheck, NewData
from sklearn.model_selection import train_test_split

# Export model
import pickle

# Light gradient bossting machine regression
# lightgbm.LGBMRegressor
from lightgbm import LGBMRegressor

read_prep = ReadPrep()
df = read_prep.read_colname_prep(data_path="./data/wheel_prediction_data.csv")

# model training
y = df[['km_till_OMS']].values
X = df[["LeftWheelDiameter", "Littera", "VehicleOperatorName"]]

# converting object type to category for gradient boosting algorithms
X = read_prep.obj_to_cat(X)

# 
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)
train_test = TrainTestCheck()
train_test.train_test_distribution_check(whole_data=df,
                                         train_data=X_train,
                                         test_data=X_test, 
                                         cols=['Littera','VehicleOperatorName'])


# define the model
# model training （ Just as an ordinary model API To use , Set the parameters inside ）
gbm = LGBMRegressor(objective='regression', num_leaves=31, learning_rate=0.5, n_estimators=20)
gbm.fit(X_train, y_train, eval_set=[(X_test, y_test)], eval_metric='rmse', early_stopping_rounds=5)

y_pred = gbm.predict(X_test, num_iteration=gbm.best_iteration_)
y_pred = pd.DataFrame(y_pred)

# eval
print("gbm model best score during the training: {0}".format(gbm.best_score_))
rmse_val = (np.nanmean((y_pred - y_test) ** 2))**0.5
print("gbm model prediction performance RMSE values is {}".format(rmse_val))

# Export model
model_pickle_out = open("./model/light_gbm.pkl", "wb")
pickle.dump(gbm, model_pickle_out)
model_pickle_out.close()

model_pickle_in = open("./model/light_gbm.pkl","rb")
model=pickle.load(model_pickle_in)
model

null_data = df[df['km_till_OMS'].isnull()]
new_x = null_data[["LeftWheelDiameter", "Littera", "VehicleOperatorName"]]
new_x = read_prep.obj_to_cat(new_x)

make_new_data_loader = NewData(df)
new_x = make_new_data_loader.make_new_data()
new_data_y = model.predict(new_x)
prediction_new_data = pd.DataFrame(data=new_data_y, columns=["prediction_kmtillOMS"])
print("prediction:", prediction_new_data)




