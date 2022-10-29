// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FEVMId is Ownable {
    mapping(string => address) private _strings;
    mapping(string => address) private _links;
    mapping(address => mapping(uint256 => string)) private _owned;
    mapping(address => uint256) private _counters;
    uint256 public _registered = 0;

    function setIdentity(string memory _name) public {
        require(_strings[_name] == address(0), "Identity exists");
        _strings[_name] = msg.sender;
        _links[_name] = msg.sender;
        _owned[msg.sender][_counters[msg.sender]] = _name;
        _counters[msg.sender]++;
        _registered++;
    }

    function changeLink(string memory _name, address _address) public {
        require(_strings[_name] == msg.sender, "Can't manage this name");
        _links[_name] = _address;
    }

    function transferName(string memory _name, address _to) public {
        require(_strings[_name] == msg.sender, "Can't manage this name");
        for (uint256 i = 0; i < _counters[msg.sender]; i++) {
            if (
                keccak256(abi.encodePacked(_owned[msg.sender][i])) ==
                keccak256(abi.encodePacked(_name))
            ) {
                _owned[msg.sender][i] = "";
            }
        }
        _links[_name] = _to;
        _strings[_name] = _to;
        _owned[_to][_counters[_to]] = _name;
        _counters[_to] += 1;
    }

    function returnAddressByName(string memory _name) public view returns (address) {
        return _links[_name];
    }

    function returnOwnedByAddress(address _address) public view returns (uint256) {
        return _counters[_address];
    }

    function returnNameByAddress(address _address, uint256 _index)
        public
        view
        returns (string memory)
    {
        return _owned[_address][_index];
    }
}
