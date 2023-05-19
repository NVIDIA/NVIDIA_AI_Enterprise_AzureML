#!/bin/sh

# bodypose2d
cp models/bodypose2d/model.etlt bodypose2d/data/models/bodypose2d/bpnet_model.deploy.etlt

# deepstream-app
cp models/tao_pretrained_models/dashcamnet/resnet18_dashcamnet_pruned.etlt deepstream-app/data/models/tao_pretrained_models/dashcamnet/resnet18_dashcamnet_pruned.etlt
cp models/tao_pretrained_models/peopleNet/V2.6/resnet34_peoplenet_int8.etlt deepstream-app/data/models/tao_pretrained_models/peopleNet/V2.6/resnet34_peoplenet_int8.etlt
cp models/tao_pretrained_models/trafficcamnet/resnet18_trafficcamnet_pruned.etlt deepstream-app/data/models/tao_pretrained_models/trafficcamnet/resnet18_trafficcamnet_pruned.etlt
cp models/tao_pretrained_models/vehiclemakenet/resnet18_vehiclemakenet_pruned.etlt deepstream-app/data/models/tao_pretrained_models/vehiclemakenet/resnet18_vehiclemakenet_pruned.etlt
cp models/tao_pretrained_models/vehicletypenet/resnet18_vehicletypenet_pruned.etlt deepstream-app/data/models/tao_pretrained_models/vehicletypenet/resnet18_vehicletypenet_pruned.etlt

#ds-tao-detection
cp models/peoplenet_transformer_vdeployable_v1.0/resnet50_peoplenet_transformer.etlt ds-tao-detection/data/models/peoplenet_transformer_vdeployable_v1.0/resnet50_peoplenet_transformer.etlt
cp models/retail_object_detection_vdeployable_100_v1.0/retail_detector_100.etlt ds-tao-detection/data/models/retail_object_detection_vdeployable_100_v1.0/retail_detector_100.etlt
cp models/retail_object_detection_vdeployable_binary_v1.0/retail_detector_binary.etlt ds-tao-detection/data/models/retail_object_detection_vdeployable_binary_v1.0/retail_detector_binary.etlt

#de-tao-segmentation
cp models/citysemsegformer_vdeployable_v1.0/citysemsegformer.etlt ds-tao-segmentation/data/models/citysemsegformer_vdeployable_v1.0/citysemsegformer.etlt
cp models/peopleSemSegNet/shuffle/peoplesemsegnet_shuffleseg_etlt.etlt ds-tao-segmentation/data/models/peopleSemSegNet/shuffle/peoplesemsegnet_shuffleseg_etlt.etlt
cp models/peopleSemSegNet/vanilla/peoplesemsegnet_vanilla_unet_dynamic_etlt_int8_fp16.etlt ds-tao-segmentation/data/models/peopleSemSegNet/vanilla/peoplesemsegnet_vanilla_unet_dynamic_etlt_int8_fp16.etlt

#emotion
mkdir -p emotion/data/models/emotion
cp models/emotion/emotion.etlt emotion/data/models/emotion/emotion.etlt
cp models/faciallandmark/faciallandmarks.etlt emotion/data/models/faciallandmark/faciallandmarks.etlt

#faciallandmark
cp models/faciallandmark/faciallandmarks.etlt faciallandmark/data/models/faciallandmark/faciallandmarks.etlt

#gaze
mkdir -p gaze/data/models/gazenet
cp models/faciallandmark/faciallandmarks.etlt gaze/data/models/faciallandmark/faciallandmarks.etlt
cp models/gazenet/gazenet_facegrid.etlt gaze/data/models/gazenet/gazenet_facegrid.etlt 

#gesture
cp models/bodypose2d/model.etlt gesture/data/models/bodypose2d/model.etlt
cp models/gesture/gesture.etlt gesture/data/models/gesture/gesture.etlt

#lpr
cp models/LP/LPD/usa_pruned.etlt lpr/data/models/LP/LPD/usa_pruned.etlt
cp models/LP/LPR/us_lprnet_baseline18_deployable.etlt lpr/data/models/LP/LPR/us_lprnet_baseline18_deployable.etlt
cp models/tao_pretrained_models/trafficcamnet/resnet18_trafficcamnet_pruned.etlt lpr/data/models/tao_pretrained_models/trafficcamnet/resnet18_trafficcamnet_pruned.etlt
cp models/tao_pretrained_models/yolov4-tiny/yolov4_tiny_usa_deployable.etlt lpr/data/models/tao_pretrained_models/yolov4-tiny/yolov4_tiny_usa_deployable.etlt

#mdx-preception
mkdir -p mdx-perception/data/models/retail_object_recognition_vdeployable_v1.0
mkdir -p mdx-perception/data/models/reidentificationnet_vdeployable_v1.0
cp models/peoplenet_transformer_vdeployable_v1.0/resnet50_peoplenet_transformer.etlt mdx-perception/data/models/peoplenet_transformer_vdeployable_v1.0/resnet50_peoplenet_transformer.etlt
cp models/reidentificationnet_vdeployable_v1.0/resnet50_market1501.etlt mdx-perception/data/models/reidentificationnet_vdeployable_v1.0/resnet50_market1501.etlt
cp models/retail_object_detection_vdeployable_binary_v1.0/retail_detector_binary.etlt mdx-perception/data/models/retail_object_detection_vdeployable_binary_v1.0/retail_detector_binary.etlt
cp models/retail_object_recognition_vdeployable_v1.0/retail_object_recognition.etlt mdx-perception/data/models/retail_object_recognition_vdeployable_v1.0/retail_object_recognition.etlt
