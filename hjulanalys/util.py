import pandas as pd


class ReadPrep():
    def __init__(self) -> None:
        pass        

    def read_colname_prep(self, data_path):

        df = pd.read_csv(data_path, encoding = 'utf-8', sep = ";", decimal=",")
        # when saving .csv in R, adding ' symbol in order to keep ComponentUniqueID as character
        # now need to remove this symbol when reading in 
        df["ComponentUniqueID"] = df["ComponentUniqueID"].str.replace("'", "")

        if "VehicleOperatorName" not in df.columns.values.tolist() and "VehicleOperatorname" in df.columns.values.tolist():
            df = df.rename(columns={"VehicleOperatorname": "VehicleOperatorName"})
        
        print(df.head())

        return df


    def obj_to_cat(self, my_data):
        obj_feat = list(my_data.loc[:, my_data.dtypes == 'object'].columns.values)

        for feature in obj_feat:
            my_data[feature] = pd.Series(my_data[feature], dtype="category")

        print("Changed dataset:" + "\n", my_data.head())

        return my_data



class TrainTestCheck():
    
    def __init__(self) -> None:
           pass        

    def train_test_distribution_check(self, whole_data, train_data, test_data, cols):
        train_dis = train_data.groupby(cols).size().reset_index().rename(columns={0:'count'})
        test_dis = test_data.groupby(cols).size().reset_index().rename(columns={0:'count'})

        train_dis['count_percent'] = (train_dis['count'] / (len(whole_data)*0.8))*100
        test_dis['count_percent'] = (test_dis['count'] / (len(whole_data)*0.2))*100
        print("If train dataset == test dataset:" + "\n", (train_dis[cols] == test_dis[cols]).value_counts())
        print("Train dataset distribution percentage:" + "\n", train_dis[train_dis['count_percent'] != 0], "\n")
        print("Test dataset distribution percentage:" + "\n", test_dis[test_dis['count_percent'] != 0])


class NewData():

    def __init__(self, mydata):
        self.data = mydata
        
    def make_new_data(self):
        null_data = self.data[self.data['km_till_OMS'].isnull()]
        new_x = null_data[["LeftWheelDiameter", "Littera", "VehicleOperatorName"]]
        new_x = ReadPrep.obj_to_cat(self, new_x)

        return new_x