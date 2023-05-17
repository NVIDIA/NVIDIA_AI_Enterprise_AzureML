## Download Multiple Streams

Auxiliary Component to download data streams from multiple source urls into the same output folder.

### Component Inputs and Outputs

* inputs:
    * urls:
    * file_types
    * checksums
* outputs:
    * data_dir

Parameters ${urls}, ${file_types} and ${checksums} are comman separated lists that contain information about the sources to download. The lists are expected to have the sme number of items

For each group of <n> items the following actions are performed:

* wget url<num> into ${data_dir}/file_name<n>.zip  (file_name is inferred from the url)
* Use checksum<n> (if provided) to verify the size of the file is as expected
* unzip file_name<n>.zip into ${data_dir}
* log information ${file_type<n>} into log files


 
