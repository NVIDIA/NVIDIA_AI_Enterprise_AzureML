## BodyPose Data Assets

Data for this sample is downloaded, but these specificiation (spec) files are provided for various components. They
provide configuration parameters to TAO commands.
* data_pose_config
    * `coco_spec.json`: Spec file to convert a COCO-trained dataset to TFRecords. Used in dataset convert.
* model_pose_config
    * `bpnet_18joints.json`: Spec file used by the dataloader that defines the target pose configuration file to use.
* `bpnet_train_m1_coco.yaml`: Train spec file.
* `infer_spec.yaml`: Inference spec file.
