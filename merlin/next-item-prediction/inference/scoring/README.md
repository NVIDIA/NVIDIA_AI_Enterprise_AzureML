# scoring script 
List of dependencies: 
* datetime 
* numpy
* nvtabular
* gevent
* tritonclient[http]
* click 

To run the scoring script & send a reqeust to triton on AzureML, run the following command: 
```
python score.py --base_url <endpoint_url> --token <AML_token>
```