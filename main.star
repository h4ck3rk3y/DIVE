icon_setup_node = import_module("github.com/hugobyte/dive/services/jvm/icon/src/node-setup/setup_icon_node.star")
eth_contract_service = import_module("github.com/hugobyte/dive/services/evm/eth/src/node-setup/contract-service.star")
eth_relay_setup = import_module("github.com/hugobyte/dive/services/evm/eth/src/relay-setup/contract_configuration.star")
eth_node = import_module("github.com/hugobyte/dive/services/evm/eth/eth.star")
icon_relay_setup = import_module("github.com/hugobyte/dive/services/jvm/icon/src/relay-setup/contract_configuration.star")
icon_service = import_module("github.com/hugobyte/dive/services/jvm/icon/icon.star")
btp_relay = import_module("github.com/hugobyte/dive/services/relay/btp_relay.star")
cosmvm_node = import_module("github.com/hugobyte/dive/services/cosmvm/src/node-setup/start_node.star")
cosmvm_deploy = import_module("github.com/hugobyte/dive/services/cosmvm/src/node-setup/deploy.star")
cosmvm_contract = import_module("github.com/hugobyte/dive/services/cosmvm/src/relay-setup/contract-configuration.star")
cosmvm_service = import_module("github.com/hugobyte/dive/services/cosmvm/cosmos.star")
icon_node_launcher = import_module("github.com/hugobyte/dive/services/jvm/icon/src/node-setup/start_icon_node.star")
cosmvm_relay = import_module("github.com/hugobyte/dive/services/relay/cosmos_relay.star")
cosmvm_rely_setup = import_module("github.com/hugobyte/dive/services/cosmvm/src/relay-setup/setup_relay.star")


def run(plan,args):

    plan.print("Starting")

    return parse_input_and_start(plan,args)

# Parse Input based on actions
def parse_input_and_start(plan,args):

    # Run a Single Node 

    if args["action"] == "start_node":

        node_name = args["node_name"]

        return run_node(plan,node_name,args)

    # Run two different Node

    if args["action"] == "start_nodes":

        nodes = args["nodes"]

        if len(nodes) == 1:

            if  nodes[0] == "icon":

                data = icon_service.start_node_service_icon_to_icon(plan)

                return data
            else:
                plan.print("For now only Icon Node support for multi run")
                return

        if len(nodes) > 2:
            plan.print("Maximum allowed node count is two")
            return
        
        if nodes[0] == "icon" and nodes[1] == "icon":
            data = icon_service.start_node_service_icon_to_icon(plan)
            return data
        
        else:
            node_0 = run_node(plan,nodes[0],args)
            node_1 = run_node(plan,nodes[1],args)

            return node_0,node_1


    # Run nodes and setup relay

    if args["action"] == "setup_relay":

        if args["relay"]["name"] == "btp":
            data = run_btp_setup(plan,args["relay"])
            
            return data

        elif args["relay"]["name"] == "cosmos":
            data = run_cosmos_setup(plan,args["relay"])

            return data

        else:

            plan.print("More Relay Support will be added soon")
            return

# Runs node based on node type
def run_node(plan,node_name,args):

    if node_name == "icon":

        return icon_service.start_node_service(plan)
        
    elif node_name == "eth":

        return eth_node.start_eth_node_serivce(plan,args)

    elif node_name == "cosmwasm":

        return cosmvm_contract.cosmwasm(plan,args)

    else :
        plan.print("Unknown Chain Type. Expected ['icon','eth','cosmwasm']")
        return

# Starts btp relay setup
def run_btp_setup(plan,args):

    links = args["links"]
    source_chain = links["src"]
    destination_chain = links["dst"]

    if destination_chain == "icon":
        destination_chain = "icon-1"

    bridge = args["bridge"]


    config_data = {
        "links": links,
        "chains" : {
            "%s" % source_chain : {},
            "%s" % destination_chain : {}
        },
        "contracts" : {
            "%s" % source_chain : {},
            "%s" % destination_chain : {}
        },
        "bridge" : bridge
    }

    

    if destination_chain == "icon-1":
        data = icon_service.start_node_service_icon_to_icon(plan)

        config_data["chains"][source_chain] = data.src_config
        config_data["chains"][destination_chain] = data.dst_config

        icon_service.configure_icon_to_icon_node(plan,config_data["chains"][source_chain],config_data["chains"][destination_chain])

        src_bmc_address , dst_bmc_address = icon_service.deploy_bmc_icon(plan,source_chain,destination_chain,config_data)

        response = icon_service.deploy_bmv_icon_to_icon(plan,source_chain,destination_chain,src_bmc_address,dst_bmc_address,config_data)

        src_xcall_address , dst_xcall_address = icon_service.deploy_xcall_icon(plan,source_chain,destination_chain,src_bmc_address,dst_bmc_address,config_data)

        src_dapp_address , dst_dapp_address = icon_service.deploy_dapp_icon(plan,source_chain,destination_chain,src_xcall_address,dst_xcall_address,config_data)


        src_block_height = icon_setup_node.hex_to_int(plan,data.src_config["service_name"],response.src_block_height)
        dst_block_height = icon_setup_node.hex_to_int(plan,data.src_config["service_name"],response.dst_block_height)

        src_contract_addresses = {
            "bmc": response.src_bmc,
            "bmv": response.src_bmv,
            "xcall": src_xcall_address,
            "dapp": src_dapp_address,
            "block_number" : src_block_height
        }

        dst_contract_addresses = {
            "bmc": response.dst_bmc,
            "bmv": response.dst_bmv,
            "xcall": dst_xcall_address,
            "dapp": dst_dapp_address,
            "block_number" : dst_block_height
        }

        config_data["chains"][source_chain]["networkTypeId"] = response.src_network_type_id
        config_data["chains"][source_chain]["networkId"] = response.src_network_id
        config_data["chains"][destination_chain]["networkTypeId"] = response.dst_network_type_id
        config_data["chains"][destination_chain]["networkId"] = response.dst_network_id

        config_data["contracts"][source_chain] = src_contract_addresses
        config_data["contracts"][destination_chain] = dst_contract_addresses




        
    if destination_chain == "eth":

        src_chain_config = icon_service.start_node_service(plan)

        dst_chain_config = eth_node.start_eth_node_serivce(plan,args)

        config_data["chains"][source_chain] = src_chain_config
        config_data["chains"][destination_chain] = dst_chain_config

        icon_service.configure_icon_node(plan,src_chain_config)

        eth_contract_service.start_deploy_service(plan,dst_chain_config)

        src_bmc_address , empty = icon_service.deploy_bmc_icon(plan,source_chain,destination_chain,config_data)

        dst_bmc_deploy_response = eth_relay_setup.deploy_bmc(plan,config_data)

        dst_bmc_address = dst_bmc_deploy_response.bmc


        dst_last_block_height_number = eth_contract_service.get_latest_block(plan,destination_chain,"localnet")

        dst_last_block_height_hex = icon_setup_node.int_to_hex(plan,src_chain_config["service_name"],dst_last_block_height_number)


        src_response = icon_service.deploy_bmv_icon(plan,source_chain,destination_chain,src_bmc_address ,dst_bmc_address,dst_last_block_height_hex,config_data)

        dst_bmv_address = eth_node.deploy_bmv_eth(plan,bridge,src_response,config_data)


        src_xcall_address , nil = icon_service.deploy_xcall_icon(plan,source_chain,destination_chain,src_bmc_address,dst_bmc_address,config_data)

        dst_xcall_address = eth_relay_setup.deploy_xcall(plan,config_data)

        src_dapp_address , nil = icon_service.deploy_dapp_icon(plan,source_chain,destination_chain,src_xcall_address,dst_xcall_address,config_data)

        dst_dapp_address = eth_relay_setup.deploy_dapp(plan,config_data)

        src_block_height = icon_setup_node.hex_to_int(plan,src_chain_config["service_name"],src_response.block_height)

        src_contract_addresses = {
            "bmc": src_response.bmc,
            "bmv": src_response.bmvbridge,
            "xcall": src_xcall_address,
            "dapp": src_dapp_address,
            "block_number" : src_block_height
        }

        dst_contract_addresses = {
            "bmc": dst_bmc_address,
            "bmcm" : dst_bmc_deploy_response.bmcm,
            "bmcs" : dst_bmc_deploy_response.bmcs,
            "bmv": dst_bmv_address,
            "xcall": dst_xcall_address,
            "dapp": dst_dapp_address,
            "block_number" : dst_last_block_height_number
        }


        config_data["contracts"][source_chain] = src_contract_addresses
        config_data["contracts"][destination_chain] = dst_contract_addresses
        config_data["chains"][source_chain]["networkTypeId"] = src_response.network_type_id
        config_data["chains"][source_chain]["networkId"] = src_response.network_id


    src_network = config_data["chains"][source_chain]["network"]
    src_bmc = config_data["contracts"][source_chain]["bmc"]

    dst_network = config_data["chains"][destination_chain]["network"]
    dst_bmc = config_data["contracts"][destination_chain]["bmc"]

    src_btp_address = 'btp://{0}/{1}'.format(src_network,src_bmc)
    dst_btp_address = 'btp://{0}/{1}'.format(dst_network,dst_bmc)


    btp_relay.start_relayer(plan,source_chain,destination_chain,config_data,src_btp_address,dst_btp_address,bridge)


    return config_data
    
def generate_config_data(args):

    data = get_args_data(args)
    config_data = {
        "links": data.links,
        "chains" : {
            "%s" % data.src : {},
            "%s" % data.dst : {}
        },
        "contracts" : {
            "%s" % data.src : {},
            "%s" % data.dst : {}
        },
        "bridge" : data.bridge
    }

    return config_data

def get_args_data(args):

    links = args["links"]
    source_chain = links["src"]
    destination_chain = links["dst"]

    if destination_chain == "cosmwasm" and source_chain == "cosmwasm":
        destination_chain = "cosmwasm"

    bridge = args["bridge"]

    return struct(
        links = links,
        src = source_chain,
        dst = destination_chain,
        bridge = bridge
    )

# starts cosmos relay setup

def run_cosmos_setup(plan,args):

    args_data = get_args_data(args)

    config_data = generate_config_data(args)

    if args_data.dst == "cosmwasm":
        # data = cosmvm_node.start_cosmos_node(plan, args)
        # start_icon = icon_node_launcher.start_icon_node(plan,service_config,id,start_file_name)
        start_icon = icon_service.start_node_service(plan)

        start_cosmos = cosmvm_node.start_cosmos_node(plan,args)

        config_data["chains"][args_data.src] = start_icon
        config_data["chains"][args_data.dst] = start_cosmos

        src_light_client = cosmvm_contract.light_client_for_icon(plan,start_icon)

        src_bmc = cosmvm_contract.deploy_bmc(plan,start_icon)

        # src_xcall = cosmvm_contract.deploy_mock_app(plan, src_bmc, start_icon)

        src_ibc_handler = cosmvm_contract.ibc_handler(plan,start_icon)

        
        dst_ibc_core = cosmvm_contract.deploy_core(plan,args)

        dst_xcall = cosmvm_contract.deploy_xcall(plan,args, dst_ibc_core)

        dst_light_client = cosmvm_contract.deploy_light_client(plan,args)

        src_contract_address = {
            # "xcall" : src_xcall,
            "ibc_handler" : src_ibc_handler,
            "light_client_address" : src_light_client
        }

        dst_contract_address = {
            "ibc_core" : dst_ibc_core,
            "xcall" : dst_xcall,
            "light_client" : dst_light_client
        }

        config_data["contracts"][args_data.src] = src_contract_address
        config_data["contracts"][args_data.dst] = dst_contract_address

       

        cosmvm_relay.start_cosmos_relay(plan, args, args_data.src, args_data.dst)

        cosmvm_rely_setup.setup_relay(plan,args,src_ibc_handler, dst_ibc_core )

        
        





        # config_data["chains"][args_data.src] = data.src_config
        # config_data["chains"][args_data.dst] = data.dst_config

        # cosmvm_service.configure_cosmvm_to_cosmvm_node(plan, config_data["chains"][args_data.src], config_data["chains"][args_data.dst])

        # src_ibc_handler_address, dst_ibc_handler_address = cosmvm_contract.ibc_handler(plan,args)

        # src_light_client_address, dst_light_client_address = cosmvm_contract.light_client(plan,args)

        # src_xcall_address, dst_xcall_address = cosmvm_contract.deploy_mock_app(plan, ibc_handler,args)

        # src_contract_address ={
        #     "xcall": src_xcall_address,
        #     "ibc_handler" : src_ibc_handler_address,
        #     "light_client_address": src_light_client_address
        # }

        # dst_contract_address = {
        #     "xcall": dst_xcall_address,
        #     "ibc_handler" : dst_ibc_handler_address,
        #     "light_client_address": dst_light_client_address
        # }

        # config_data["contracts"][args_data.src] = src_contract_addresses
        # config_data["contracts"][args_data.dst] = dst_contract_addresses
        # config_data["chains"][args_data.src]["block_number"] = src_block_height
        # config_data["chains"][args_data.dst]["block_number"] =  dst_block_height







       



