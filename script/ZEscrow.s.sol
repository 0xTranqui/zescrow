// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "forge-std/Script.sol";
import {ZEscrow} from "../src/ZEscrow.sol";

contract DeployCore is Script {

    function setUp() public {}

    address public owner = 0x806164c929Ad3A6f4bd70c2370b3Ef36c64dEaa8;
    address public claimer1 = 0xE7746f79bF98e685e6a1ac80D74d2935431041d5;
    address public claimer2 = 0x004991c3bbcF3dd0596292C80351798965070D75;
    address public claimer3 = 0x33F59bfD58c16dEfB93612De65A5123F982F58bA;

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        new ZEscrow(
            owner,
            claimer1,
            claimer2,
            claimer3
        );        

        vm.stopBroadcast();
    }
}

// ======= DEPLOY SCRIPTS =====

// source .env
// forge script script/ZEscrow.s.sol:DeployCore --rpc-url $GOERLI_RPC_URL --broadcast --verify  -vvvv
// forge script script/ZEscrow.s.sol:DeployCore --rpc-url $MAINNET_RPC_URL --broadcast --verify  -vvvv
