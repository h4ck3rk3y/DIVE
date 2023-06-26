/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../../common";

export interface IFeeManageInterface extends utils.Interface {
  functions: {
    "getFee(string,bool)": FunctionFragment;
    "getProtocolFee()": FunctionFragment;
    "getProtocolFeeHandler()": FunctionFragment;
    "setProtocolFee(uint256)": FunctionFragment;
    "setProtocolFeeHandler(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "getFee"
      | "getProtocolFee"
      | "getProtocolFeeHandler"
      | "setProtocolFee"
      | "setProtocolFeeHandler"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "getFee",
    values: [PromiseOrValue<string>, PromiseOrValue<boolean>]
  ): string;
  encodeFunctionData(
    functionFragment: "getProtocolFee",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getProtocolFeeHandler",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setProtocolFee",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setProtocolFeeHandler",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(functionFragment: "getFee", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getProtocolFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getProtocolFeeHandler",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setProtocolFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setProtocolFeeHandler",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IFeeManage extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IFeeManageInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    getFee(
      _net: PromiseOrValue<string>,
      _rollback: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getProtocolFee(overrides?: CallOverrides): Promise<[BigNumber]>;

    getProtocolFeeHandler(overrides?: CallOverrides): Promise<[string]>;

    setProtocolFee(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setProtocolFeeHandler(
      _addr: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  getFee(
    _net: PromiseOrValue<string>,
    _rollback: PromiseOrValue<boolean>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getProtocolFee(overrides?: CallOverrides): Promise<BigNumber>;

  getProtocolFeeHandler(overrides?: CallOverrides): Promise<string>;

  setProtocolFee(
    _value: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setProtocolFeeHandler(
    _addr: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    getFee(
      _net: PromiseOrValue<string>,
      _rollback: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolFee(overrides?: CallOverrides): Promise<BigNumber>;

    getProtocolFeeHandler(overrides?: CallOverrides): Promise<string>;

    setProtocolFee(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setProtocolFeeHandler(
      _addr: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    getFee(
      _net: PromiseOrValue<string>,
      _rollback: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolFee(overrides?: CallOverrides): Promise<BigNumber>;

    getProtocolFeeHandler(overrides?: CallOverrides): Promise<BigNumber>;

    setProtocolFee(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setProtocolFeeHandler(
      _addr: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    getFee(
      _net: PromiseOrValue<string>,
      _rollback: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getProtocolFee(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    getProtocolFeeHandler(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    setProtocolFee(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setProtocolFeeHandler(
      _addr: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
