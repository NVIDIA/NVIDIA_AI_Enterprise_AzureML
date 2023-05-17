## Convert Multiple Streams Wider to Kitti: Format Conversion Auxiliary Component

Converts multiple streams from the wider format to the kitti format

### Component Inputs and Outputs

* inputs:
    * source_data_dir
    * image_subdirs
    * label_files
    * output_subdirs
    * image_height
    * image_width
* outputs:
    * converted_data_dir:

### Components Inputs and Outputs Mapping
The Component converts several image sources with the spacified ${image_height} and ${image_width}

Parameters image_subdirs, label_files and output_subdirs are comma separated lists, that should have the same number of items.

For each item <n> on the lists The conversion would be of the following form:

    python3 convert_wider_to_kitti.py --input_image_dir=${source_data_dir}/${image_subdir<n>} \
                                   --input_label_file=${source_data_dir}/${label_file<n>} \
                                   --output_dir=${converted_data_dir}/${output_subdir<n>}/ \
                                   --image_height=${image_height} --image_width=${image_width} --grayscale


 
