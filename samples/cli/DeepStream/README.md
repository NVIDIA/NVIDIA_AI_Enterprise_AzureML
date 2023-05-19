## Running DeepStream pipeline

This steps in the README should be run only after you have registered all the components needed to run this pipeline

* [bodypose 2d](./bodypose2d/README.md)
![](https://developer.nvidia.com/sites/default/files/akamai/TLT/bodyposenet/nv_pose2d_1.png)

```
$ cd samples/cli/Deepstream
# update config.sh
$ bash run_pipeline.sh
```
You can now navigate to the the AzureML studio and should be able to see the following pipeline 

[More details ...](../../../src/components/DeepStream/README.md)

