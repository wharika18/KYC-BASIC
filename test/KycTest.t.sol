//SPDX License Identifier:MIT
pragma solidity ^0.8.24;
import {Test} from "forge-std/Test.sol";
import {DeployKyc} from "../script/DeployKyc.s.sol";
import {Kyc} from "../src/Kyc.sol";

contract KycTest is Test {
    Kyc public kyc;
    DeployKyc public deployer;
    address admin = msg.sender;
    address bank = makeAddr("bank");
    string boi;
    string aaa;
    string John;

    function setUp() public {
        deployer = new DeployKyc();
        kyc = deployer.run();
    }

    function testAddBank() public {
        vm.prank(admin);

        kyc.addBank(boi, bank, 1);
        assertEq(kyc.getBankName(bank), boi);
        assertEq(kyc.getBankReg(bank), 1);
    }

    function testAddCustomer() public {
        vm.prank(admin);

        kyc.addBank(boi, bank, 1);
        vm.stopPrank();
        vm.prank(bank);
        kyc.addCustomer(John, aaa);
        assertEq(kyc.getCustData(John), aaa);
    }
function testKycFalse() public {
        vm.prank(admin); 

        kyc.addBank(boi, bank, 1);
        vm.prank(admin);
        kyc.addBank(boc, bank1, 2);
        vm.prank(admin);
        kyc.addBank(bob, bank2, 3);
        vm.prank(bank);
        kyc.addCustomer(John, aaa);
        vm.prank(bank);
        kyc.upVote(John);
        vm.stopPrank();
        vm.prank(bank1);
        kyc.downVote(John);
        vm.stopPrank();
        vm.prank(bank2);
        kyc.downVote(John);
        kyc.kycStatus(John);
        assertEq(kyc.getKycStatus(John), false);
    }
}
