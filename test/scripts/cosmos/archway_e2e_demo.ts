import dotenv from "dotenv";
import { fromTendermintEvent } from "@cosmjs/stargate";
import Long from "long";
import {
  CreateSigningClient,
  getBalance,
  getHeight,
  getStake,
  getTestAccountWithStake,
} from "./helper";

// configure dotenv
dotenv.config();

async function main() {
  // Chain Constants, modify as required
  const chain1 = {
    chainId: "archway-node-0",
    endpoint: "http://localhost:4564",
    prefix: "archway",
  };

  const chain2 = {
    chainId: "archway-node-1",
    endpoint: "http://localhost:4566",
    prefix: "archway",
  };

  console.log("*".repeat(63));
  console.log(
    "Demo on Sending token transfer over IBC from archway to archway"
  );
  console.log("*".repeat(63));

  // *****************************************************************
  // Setting up account on chain 1 by getting mnemonics from env file
  const mnemonic1 = process.env.MNEMONIC1 as string;
  console.log("");
  console.log("Chain 1: " + chain1.chainId);
  const [signingClient, accountAddress] = await CreateSigningClient(
    mnemonic1,
    chain1.prefix,
    chain1.endpoint
  );

  // To Check if the client is connected to local chain
  getHeight(signingClient, chain1.chainId);

  // Get Test Account with stake
  const testAccount = await getTestAccountWithStake();
  const testAddress = testAccount.substring(8, testAccount.length).trim();

  // To Get balance of given account address and transfer balance if 0
  const bal = await signingClient.getBalance(accountAddress, "stake");
  if (bal.amount == "0") {
    console.log(
      "No Balance in Signer account, Transferring balance to Signer account"
    );
    await getStake(testAddress!, accountAddress);
  }
  await new Promise((f) => setTimeout(f, 5000));
  await getBalance(signingClient, accountAddress);


  // *****************************************************************
  // Setting up account on chain 1 by getting mnemonics from env file
  console.log("Chain 2: " + chain2.chainId);
  const mnemonic2 = process.env.MNEMONIC2 as string;
  const [signingClient1, accountAddress1] = await CreateSigningClient(
    mnemonic2,
    chain2.prefix,
    chain2.endpoint
  );

  // To Check if the client is connected to local chain
  await getHeight(signingClient1, chain2.chainId);

  // To Get Balance from account on chain 2
  await getBalance(signingClient1, accountAddress1);

  // IBC transfer starts from here
  console.log("*".repeat(80));
  console.log(
    "Initiating IBC Token Transfer of 100 stake from " +
      chain1.chainId +
      " to " +
      chain2.chainId
  );
  console.log("*".repeat(80) + "\n");

  const msgIBCTransfer = {
    typeUrl: "/ibc.applications.transfer.v1.MsgTransfer",
    value: {
      sourcePort: "transfer",
      sourceChannel: "channel-0", // channel of the bridge
      token: {
        denom: "stake",
        amount: "100",
      },
      sender: accountAddress,
      receiver: accountAddress1,
      // Timeout is in nanoseconds, you can also just send Long.UZERO for default timeout
      timeoutTimestamp: Long.fromNumber(Date.now() + 600_000).multiply(
        1_000_000
      ),
    },
  };
  const broadcastResult = await signingClient.signAndBroadcast(
    accountAddress,
    [msgIBCTransfer],
    "auto",
    "IBC Transfer" // optional memo
  );

  if (broadcastResult.code !== undefined && broadcastResult.code !== 0) {
    console.log("Transaction failed:", broadcastResult.rawLog);
  } else {
    console.log("Transaction successful:", broadcastResult.transactionHash);
  }

  // To decode event logs from transaction
  const txResult = await signingClient.getTx(broadcastResult.transactionHash);
  const events = txResult?.events;
  console.log(events);
  for (const event of events!) {
    const decodedEvent = fromTendermintEvent(event);
    console.log(decodedEvent);
  }
}

main();
