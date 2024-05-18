// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Script} from "forge-std/Script.sol";
import {Kyc} from "../src/Kyc.sol";

contract DeployKyc is Script {
    function run() external returns (Kyc) {
        vm.startBroadcast();
        Kyc kyc = new Kyc();
        vm.stopBroadcast();
        return kyc;
    }
}
