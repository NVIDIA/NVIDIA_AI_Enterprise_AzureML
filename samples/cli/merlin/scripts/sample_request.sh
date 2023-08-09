
ENDPOINT_NAME=next-item-endpoint
scoring_uri=$(az ml online-endpoint show -n $ENDPOINT_NAME --query scoring_uri -o tsv)
auth_token=$(az ml online-endpoint get-credentials -n $ENDPOINT_NAME --query accessToken -o tsv)
python ./scoring/score.py --base_url $scoring_uri --token $auth_token
