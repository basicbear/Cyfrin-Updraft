// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { SimpleStorage } from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public listSimpStorage;

    function createSimpleStorageContract() public {
        listSimpStorage.push(new SimpleStorage());
        // return address(new SimpleStorage());
    }

    function sfStore( uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        SimpleStorage mySimpStore = SimpleStorage(listSimpStorage[_simpleStorageIndex]);
        mySimpStore.store(_newSimpleStorageNumber);
    }

    function sfGet( uint256 _simpleStorageIndex ) public view returns(uint256) {
        SimpleStorage mySimpStore = SimpleStorage(listSimpStorage[_simpleStorageIndex]);
        return mySimpStore.retrieve();
    }
}