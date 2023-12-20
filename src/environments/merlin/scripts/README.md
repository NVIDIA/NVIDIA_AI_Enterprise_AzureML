### Auxiliary Scripts use to publish AzureMl Resources into a Registry

The scripts use variables defined in the config_files/config.sh file

Variables are used to define user credentials and the Registry that Resources are published to 

If publishing the Resources for the first time to a given Registry the scripts should be ran in the follwing order

* set_environment.sh
* set_components.sh
* run_pipeline.sh

If the Resources are already published into the given Registry, only the last script should be run

Other scripts help the user to install libraries or to create a Compute Cluster but those are unrelated to Registry Publishing