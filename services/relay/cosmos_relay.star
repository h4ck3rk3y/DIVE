

ARCHWAY = "github.com/hugobyte/dive/services/cosmvm/static_files/config/"
RELAY_SERVICE_NAME = "cosmos-relay"
RELAY_SERVICE_IMAGE = "relay6"
RELAY_CONFIG_FILES_PATH = "/home/.relay/"

def start_cosmos_relay(plan, args , src, dst):
# def run(plan,args):

    plan.print("starting cosmos relay")

    plan.upload_files(src=ARCHWAY, name="archway_config")

    # src_config = args["chains"][src_chain]
    # src_service_name = src_config["service_name"]
    # src_endpoint = src_config["endpoint"]
    # src_keystore = src_config["keystore_path"]
    # src_keypassword =src_config["keypassword"]

    # dst_config = args["chains"][dst_chain]
    # dst_service_name = dst_config["service_name"]
    # dst_endpoint = dst_config["endpoint"]
    # dst_keystore = dst_config["keystore_path"]
    # dst_keypassword =dst_config["keypassword"]

    relay_service = ServiceConfig(
        image=RELAY_SERVICE_IMAGE,
        files={
            RELAY_CONFIG_FILES_PATH: "archway_config"
        },
    
        entrypoint=["/bin/sh"]

    )

    plan.add_service(name=RELAY_SERVICE_NAME,config=relay_service)

    # cosmvm_rely_setup.start_relay(plan,args)

