import torch
from azure.core.exceptions import ResourceNotFoundError
from azure.ai.ml.entities import AmlCompute
from monai.transforms import MapTransform

class ConvertToMultiChannelBasedOnBratsClassesd(MapTransform):
    """
    Convert labels to multi channels based on brats 2021 classes:
    label 1 necrotic tumor core (NCR)
    label 2 peritumoral edematous/invaded tissue 
    label 3 is not used in the new dataset version
    label 4 GD-enhancing tumor 
    The possible classes are:
      TC (Tumor core): merge labels 1 and 4
      WT (Whole tumor): merge labels 1,2 and 4
      ET (Enhancing tumor): label 4

    """

    def __call__(self, data):
        d = dict(data)
        for key in self.keys:
            result = []
            # merge label 1 and label 4 to construct TC
            result.append(torch.logical_or(d[key] == 1, d[key] == 4))
            # merge labels 1, 2 and 4 to construct WT
            result.append(
                torch.logical_or(
                    torch.logical_or(d[key] == 1, d[key] == 2), d[key] == 4
                )
            )
            # label 4 is ET
            result.append(d[key] == 4)
            d[key] = torch.stack(result, axis=0).float()
        return d


def create_compute_cluster(ml_client, cname, csize):    
    try:
        ml_client.compute.get(name=cname)
        print("Found existing compute target {name}.")
    except ResourceNotFoundError:
        print("Creating a new compute target...")
        cluster_low_pri = AmlCompute(
            name=cname,
            size=csize,
            min_instances=0,
            max_instances=3,
            idle_time_before_scale_down=120,
            tier="low_priority",
        )
        ml_client.begin_create_or_update(cluster_low_pri).result()