// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24; 

contract SimpleStorage {
    uint256 internal favNum = 777;
    uint256[] favNumList;

    struct Person {
        string name;
        uint256 favoriteNumber;
    }

    Person[] public people;
    mapping(string => uint256) public name2favNum;

    // Person public pat = Person({name: "LEO", favoriteNumber: 123});
    
    function store(uint256 _favNum) public virtual {
        favNum = _favNum + retrieve();   
    }

    function retrieve( ) public view returns(uint256){
        return favNum;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(Person(_name, _favoriteNumber));
        name2favNum[_name] = _favoriteNumber;
    }

}

