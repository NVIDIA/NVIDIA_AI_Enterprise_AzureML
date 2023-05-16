import argparse
import logging
import sys
import os
import shutil
import tarfile


def run(args) -> str:    

    # extract 
    with tarfile.open(args.blob_file_location, "r") as tar:
        tar.extractall(path=args.image_data_folder)
   
def get_arg_parser(parser=None):
    """Parse the command line arguments for merge using argparse.
    Args:
               inputs:
                    blob_file_location:
                        type: uri_folder
                        description: the input blob .tar file location
                        mode: "ro_mount"
                    overwrite:
                        type: boolean
                        description: overwrire local data
                        default: true
                        optional: true       

               outputs:    
                    image_data_folder:
                        type: uri_folder
                        description: the output folder where the uncompressed data will be written
                        mode: "rw_mount"    
                        mode: "upload"    

    """
    # add arguments that are specific to the component
    if parser is None:
        parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument(
        "--blob_file_location",
        type=str,
        required=True,
        help="Azure blob name",
    )

    parser.add_argument(
        "--overwrite",
        type=bool,
        required=False,
        help="Overwrite files",
    )
    parser.add_argument(
        "--image_data_folder",
        type=str,
        required=True,
        help="Location of results",
    )

    return parser


def main(cli_args=None):
    """Component main function.
    It parses arguments and executes run() with the right arguments.
    Args:
        cli_args (List[str], optional): list of args to feed script, useful for debugging. Defaults to None.
    """

    # build an arg parser
    parser = get_arg_parser()

    # run the parser on cli args
    args = parser.parse_args(cli_args)

    logging.info(f"Running script with arguments: {args}")
    # args.image_data_folder = run(args)
    run(args)


if __name__ == "__main__":
    # Set logging to sys.out
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)
    log_format = logging.Formatter("[%(asctime)s] [%(levelname)s] - %(message)s")
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    handler.setFormatter(log_format)
    logger.addHandler(handler)

    main()