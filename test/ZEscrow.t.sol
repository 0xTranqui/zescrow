// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import {ZEscrow} from "../src/ZEscrow.sol";

contract ZorbRemixEscrowTest is Test {
    ZEscrow public zEscrow;
    address public ownerAddy = address(0x111);
    address public invalidOwner = address(0x222);
    address public claimer1Addy = address(0x333);
    address public claimer2Addy = address(0x444);
    address public claimer3Addy = address(0x555);
    address public invalidClaimer = address(0x666);

    function setUp() public {
        zEscrow = new ZEscrow(
            ownerAddy,
            claimer1Addy,
            claimer2Addy,
            claimer3Addy
        );
        vm.deal(address(zEscrow), zEscrow.distributionBalance());
    }

    function testSetUp() public {
        assertEq(zEscrow.owner(), ownerAddy);
        assertEq(zEscrow.claimer1(), claimer1Addy);
        assertEq(zEscrow.claimer2(), claimer2Addy);
        assertEq(zEscrow.claimer3(), claimer3Addy);
        assertEq(address(zEscrow).balance, zEscrow.distributionBalance());
    }

    function testClaim() public {
        vm.startPrank(claimer1Addy);
        zEscrow.claim(claimer1Addy);
        vm.stopPrank();
        vm.startPrank(claimer2Addy);
        zEscrow.claim(claimer2Addy);
        vm.stopPrank();
        vm.startPrank(claimer3Addy);
        zEscrow.claim(claimer3Addy);
        vm.stopPrank();                
        assertEq(zEscrow.claimer1().balance, (zEscrow.distributionBalance() / 3));
        assertEq(zEscrow.claimer2().balance, (zEscrow.distributionBalance() / 3));
        assertEq(zEscrow.claimer3().balance, (zEscrow.distributionBalance() / 3));
        assertEq(address(zEscrow).balance, 0);
    }

    function testClaimNonClaimerFail() public {
        vm.startPrank(ownerAddy);
        vm.expectRevert();
        zEscrow.claim(ownerAddy);            
        assertEq(zEscrow.owner().balance, 0);
        assertEq(address(zEscrow).balance, zEscrow.distributionBalance());
    }

    function testClaimAlreadyClaimedFail() public {
        vm.startPrank(claimer1Addy);
        zEscrow.claim(claimer1Addy);            
        assertEq(zEscrow.claimer1().balance, (zEscrow.distributionBalance() / 3));
        assertEq(address(zEscrow).balance, zEscrow.distributionBalance() - (zEscrow.distributionBalance() / 3));
        vm.expectRevert();
        zEscrow.claim(claimer1Addy);        
    }    

    function testSetClaimer() public {
        vm.startPrank(ownerAddy);
        address newClaimer1 = address(0x777);
        address newClaimer2 = address(0x888);
        address newClaimer3 = address(0x999);
        zEscrow.setClaimer1(newClaimer1);            
        zEscrow.setClaimer2(newClaimer2);            
        zEscrow.setClaimer3(newClaimer3);            
        assertEq(zEscrow.claimer1(), newClaimer1);
        assertEq(zEscrow.claimer2(), newClaimer2);
        assertEq(zEscrow.claimer3(), newClaimer3);
        vm.stopPrank();

        vm.startPrank(claimer1Addy);
        vm.expectRevert();
        zEscrow.claim(claimer1Addy);    
        vm.stopPrank();   

        vm.startPrank(claimer2Addy);
        vm.expectRevert();
        zEscrow.claim(claimer2Addy);    
        vm.stopPrank();          

        vm.startPrank(claimer3Addy);
        vm.expectRevert();
        zEscrow.claim(claimer3Addy);    
        vm.stopPrank();          

        vm.startPrank(newClaimer1);
        zEscrow.claim(newClaimer1);
        vm.stopPrank();
        vm.startPrank(newClaimer2);
        zEscrow.claim(newClaimer2);
        vm.stopPrank();
        vm.startPrank(newClaimer3);
        zEscrow.claim(newClaimer3);
        vm.stopPrank();               

        assertEq(zEscrow.claimer1().balance, (zEscrow.distributionBalance() / 3));
        assertEq(zEscrow.claimer2().balance, (zEscrow.distributionBalance() / 3));
        assertEq(zEscrow.claimer3().balance, (zEscrow.distributionBalance() / 3));
        assertEq(address(zEscrow).balance, 0);      

        // setClaimer1 should revert since claimer1 has already claimed. claimer1 address is frozen foreer
        vm.startPrank(ownerAddy);
        vm.expectRevert();
        zEscrow.setClaimer1(claimer1Addy);    
        vm.stopPrank();                              
    }       

    // function testIncrement() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
