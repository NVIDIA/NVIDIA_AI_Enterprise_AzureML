import argparse
import os
from pathlib import Path
import cudf
import pandas as pd
import xgboost
import matplotlib.pyplot as plt
from cuml.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.utils._testing import ignore_warnings
import optuna
import mlflow

mlflow.sklearn.autolog()

parser = argparse.ArgumentParser("train")
parser.add_argument("--training_data", type=str, help="Path to training data")
parser.add_argument("--model_output", type=str, help="Path to output model")
parser.add_argument("--test_split_ratio", type=float, help="ratio of train test split")

args = parser.parse_args()

print("Hello training world...")

df_list = []
with open(os.path.join(args.training_data), "r") as handle:
    input_df = cudf.read_csv((Path(args.training_data)))
    df_list.append(input_df)

print(df_list)
train_data = df_list[0]

#Split the data into input(x) and output(y)
target_column = 'tip_amount'
y = train_data[target_column]
X = train_data.drop(target_column, axis=1)

X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=args.test_split_ratio, random_state=42)

train_DataAndLabelsGPU = xgboost.DMatrix(X_train,label=y_train)
test_DataAndLabelsGPU = xgboost.DMatrix(X_test, label=y_test)

#Train once
gpuMaxDepth = 1
gpuNTrees = 10
paramsGPU = {
    'max_depth': gpuMaxDepth,
    'objective': 'reg:squarederror',  # Change the objective to regression
    'tree_method': 'gpu_hist',
    'random_state': 0,
};
xgBoostModelGPU = xgboost.train(dtrain=train_DataAndLabelsGPU, params=paramsGPU, num_boost_round=gpuNTrees);

nGPUs = 1
gpuMaxDepth = 3
gpuNTrees = 10

for gpuMaxDepth in [1, 3, 4, 5, 10]:
    for gpuNTrees in [1, 10, 25, 50, 100]:
        paramsGPU = {
            'max_depth': gpuMaxDepth,
            'objective': 'reg:squarederror',  # Change the objective to regression
            'tree_method': 'gpu_hist',
            'random_state': 0,
        };

        xgBoostModelGPU = xgboost.train(dtrain=train_DataAndLabelsGPU, params=paramsGPU, num_boost_round=gpuNTrees);

        # evaluate
        yPredTrainGPU = xgBoostModelGPU.predict(train_DataAndLabelsGPU)
        yPredTestGPU = xgBoostModelGPU.predict(test_DataAndLabelsGPU)


        # Assuming you have yPredTestGPU and y_test (Ground truth labels)
        mse = mean_squared_error(y_test.to_numpy(), yPredTestGPU)
        r2 = r2_score(y_test.to_numpy(), yPredTestGPU)

        # Assuming you have yPredTestGPU and y_test (Ground truth labels)
        mse_train = mean_squared_error(y_train.to_numpy(), yPredTrainGPU)
        r2_train = r2_score(y_train.to_numpy(), yPredTrainGPU)

        print(f"{gpuMaxDepth} -- {gpuNTrees} -- Mean Squared Error: {mse} -- {mse_train} -- R-squared: {r2} -- {r2_train}")

# The below section is for optuna HPO
def objective(trial):
    gpuMaxDepth = trial.suggest_int('gpuMaxDepth',1,20)
    gpuNTrees = trial.suggest_int('gpuNTrees',1,300)

    paramsGPU = {
        'max_depth': gpuMaxDepth,
        'objective': 'reg:squarederror',  # Change the objective to regression
        'tree_method': 'gpu_hist',
        'random_state': 0,
    };

    xgBoostModelGPU = xgboost.train(dtrain=train_DataAndLabelsGPU, params=paramsGPU, num_boost_round=gpuNTrees);

    #evaluate
    yPredTrainGPU = xgBoostModelGPU.predict(train_DataAndLabelsGPU)
    yPredTestGPU = xgBoostModelGPU.predict(test_DataAndLabelsGPU)

    # Assuming you have yPredTestGPU and y_test (Ground truth labels)
    mse = mean_squared_error(y_test.to_numpy(), yPredTestGPU)
    
    return mse

study = optuna.create_study(direction='minimize')
study.optimize(objective, n_trials=10)

print("Number of finished trials:", len(study.trials))
print("Best trial:", study.best_trial.params)

best_params = study.best_trial.params
xgBoostModelGPU = xgboost.train(dtrain=train_DataAndLabelsGPU, params=best_params, num_boost_round=best_params['gpuNTrees'])

#evaluate
yPredTrainGPU = xgBoostModelGPU.predict(train_DataAndLabelsGPU)
yPredTestGPU = xgBoostModelGPU.predict(test_DataAndLabelsGPU)

#Assuming you have yPredTestGPU and y_test (Ground truth labels)
mse = mean_squared_error(y_test.to_numpy(), yPredTestGPU)
r2 = r2_score(y_test.to_numpy(), yPredTestGPU)

print(f"Mean Squared Error: {mse} -- R-squared: {r2}")

mlflow.sklearn.save_model(xgBoostModelGPU, args.model_output)

# plot the figure
plt.figure(figsize=(20,10))
n_samples_to_diff = 200
actual = y_train[0:n_samples_to_diff].to_numpy()
predicted = yPredTrainGPU[0:n_samples_to_diff]

plt.subplot(3,1,(1,2))
plt.plot(actual, color=(0,.8,0), linewidth=2)
plt.plot(predicted, linestyle='-', color=(1,.6,1), linewidth=2)
plt.legend(['actual', 'predicted'])
plt.ylabel('tip amount $')
plt.grid('on',alpha=.25)
plt.subplot(3,1,3)
plt.plot(actual-predicted,color=(0,0,0))
plt.legend(['diff in actual v/s predicted'])
plt.ylabel('predicted error $')
plt.xlabel('trip number')
plt.grid('on',alpha=0.25)
plt.savefig("output-1.jpg")
samples = plt.gcf()

try:
    mlflow.log_figure(samples, 'sample-images.png')
except Exception as e:
    print('Exception during mlflow image logging: {e}')