import datetime
import numpy as np
import nvtabular.inference.triton as nvt_triton
import pandas as pd
import gevent.ssl
import tritonclient.http as httpclient
import click

from defaults import _T4R_MODEL_NAME

# This function formats dataframe into aa HTTP payload
def convert_df_to_triton_input(column_names, batch, input_class=httpclient.InferInput):
    columns = [(col, batch[col]) for col in column_names]
    inputs = []
    for i, (name, col) in enumerate(columns):
        if True or nvt_triton.is_list_dtype(col):
            inputs.append(
                nvt_triton._convert_column_to_triton_input(
                    get_offset(col).astype("int64"),
                    name + "__nnzs",
                    input_class,
                )
            )
            col_numeric = pd.to_numeric(col, errors='coerce')
            inputs.append(
                nvt_triton._convert_column_to_triton_input(
                    col_numeric.to_numpy().flatten().astype("int64"),
                    name + "__values",
                    input_class,
                )
            )
        else:
            values = col.to_numpy() if isinstance(col, pd.Series) else col.tolist()
            inputs.append(
                nvt_triton._convert_column_to_triton_input(values, name, input_class)
            )
    return inputs

def get_offset(col): 
    # Convert to numpy arr
    list_array = col.to_numpy()

    # Calc cumulative sum of lengths of lists with np.cumsum()
    lengths = np.array([len(list) for list in list_array])
    cumsum = np.cumsum(lengths)
    
    # Calc start indicies. 
    start_indices = np.hstack(([0], cumsum[:-1]))

    # Calc end indicies
    end_indices = cumsum

    # Reformat and flatten using stack() and ravel()
    offset_indices = np.stack((start_indices, end_indices)).ravel()

    return offset_indices

@click.command()
@click.option("--base_url", help="scoring url")
@click.option("--token", help="token for authorization")
def main(base_url, token): 
    # Generates timestamps  
    now = datetime.datetime.now()
    timestamps = np.array(
        [np.floor((now + datetime.timedelta(minutes=i)).timestamp()) for i in range(5)],
        dtype=np.int64,
    )

    # Dataframe with appropiate names, data. 
    df = pd.DataFrame(
        {
            # "session_id": [1, 1, 1, 1, 1],
            "item_id": [[42, 17, 34, 67, 123]],
            "category": [[0, 0, 0, 0, 0]],
            "timestamp": [timestamps[:5]],
        }
    )

    # Branches to convert_df_to_triton_input() function. 
    # Reformatted data is assigned to inputs variable
    inputs = convert_df_to_triton_input(df.columns, df, httpclient.InferInput)

    output_names = ["output"]

    #Infer is done in the helper send__triton_request function 
    outputs_list = [httpclient.InferRequestedOutput(col) for col in output_names]

    N_REQ = 100
    N_THREAD = 1

    scoring_uri = base_url[8:]
    print("the scoring_uri is: " + scoring_uri + "\n")

    with httpclient.InferenceServerClient(
        url=scoring_uri,
        ssl=True, 
        ssl_context_factory=gevent.ssl._create_default_https_context,
    ) as client: 
        headers = {}
        headers["Authorization"] = f"Bearer {token}"
        health_ctx = client.is_server_ready(headers=headers)
        aliveness = client.is_server_live(headers=headers)
        print("Is server live - {}".format(aliveness))
        print("Is server ready -{}".format(health_ctx))
        
        for N_REQ in [1, 10, 100]:
            print(
                f"TIME FOR {N_REQ} REQUESTS OVER {N_THREAD} THREADS (stats exclude the first request):"
            )
            for _ in [1]:

                def make_request():
                    tic = datetime.datetime.now()
                    resp = client.infer(_T4R_MODEL_NAME, inputs, headers=headers)
                    resp = resp.as_numpy("output")
                    toc = datetime.datetime.now()
                    return (toc - tic).total_seconds()
                
                total_tic = datetime.datetime.now()
                times = list([make_request() for _ in range(N_REQ)])
                total_toc = datetime.datetime.now()
                print(f"mean: {np.mean(times[1:])}, std: {np.std(times[1:])}")
                print(times)

                print(f"total time: {total_toc - total_tic}")
            print("")

if __name__ == "__main__":
    main()
    print("finished running")
