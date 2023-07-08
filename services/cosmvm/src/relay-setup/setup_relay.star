
cosmvm_contract = import_module("github.com/hugobyte/dive/services/cosmvm/src/relay-setup/contract-configuration.star")

def setup_relay(plan,args, src_ibc_handler, dst_ibc_core):

   INIT =  plan.exec(service_name="cosmos-relay", recipe=ExecRecipe(command=["/bin/sh", "-c", "rly config init"]) )

   pp = ExecRecipe(command=["/bin/sh", "-c", "echo '{\"type\":\"archway\", \"value\":{\"key-directory\": \"$HOME/.relayer\",  \"key\": \"default\", \"chain-id\": \"my-chain\", \"rpc-addr\": \"tcp://127.0.0.1:4564\",\"account-prefix\": \"archway\",\"keyring-backend\": \"test\",\"gas-adjustment\": \"1.5\", \"gas-prices\": \"0.02stake\", \"min-gas-amount\": \"1_000_000\", \"debug\": \"true\", \"timeout\": \"20s\", \"block-timeout\": \"\", \"output-format\": \"json\", \"sign-mode\": \"direct\", \"extra-codecs\": \"[]\", \"coin-type\": \"0\", \"broadcast-mode\": \"batch\", \"ibc-handler-address\":%s }}' >> /home/.relay/chains/arch.json" % (src_ibc_handler) ])
   plan.exec(service_name="cosmos-relay", recipe=pp)
   
   icon = ExecRecipe(command=["/bin/sh", "-c", "echo '{\"type\":\"icon\",\"value\":{\"key\": \"\",\"chain-id\": \"ibc-icon\",  \"rpc-addr\": \"http://localhost:9082/api/v3/\",\"timeout\": \"30s\", \"keystore\": \"$HOME/keystore/godWallet.json\",\"password\": \"gochain\", \"icon-network-id\": \"3\",\"btp-network-id\": \"1\", \"btp-network-type-id\": \"1\", \"start-btp-height\": \"0\", \"ibc-handler-address\": %s, \"archway-handler-address\":%s}}' >> /home/.relay/chains/ico.json" % (src_ibc_handler, dst_ibc_core)])
   plan.exec(service_name="cosmos-relay", recipe=icon)

   plan.exec(service_name="cosmos-relay", recipe= ExecRecipe(command=["bin/sh", "-c", "rly add-dir "/home/.relay/chains"]))

  
   plan.exec(service_name="cosmos-relay", recipe= ExecRecipe(command=["bin/sh", "-c", "rly q balance archway && rly q balance icon"]))

   plan.exec(service_name="cosmos-relay", recipe=ExecRecipe(command=["/bin/sh", "-c", "rly paths fetch"]))

   plan.exec(service_name="cosmos-relay", recipe=ExecRecipe(command=["/bin/sh", "-c", "rly paths list"]))

   plan.exec(service_name="cosmos-relay", recipe=ExecRecipe(command=["/bin/sh", "-c", "rly start"]))

