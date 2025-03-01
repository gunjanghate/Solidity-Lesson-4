//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


// interface AggregatorTorV3Interface{
//     function decimals() external view returns (uint256);
//     function description() external view returns (string memory);
//     function version() external view returns (uint256);

//     function getRoundData(uint80 _roundId) external view returns(
//         uint80 roundId,
//         int256 answer,
//         uint256 startedAt,
//         uint256 updatedAt,
//         uint256 answerInRound
//     );

//     function latestRoundData() external view returns(
//         uint80 roundId,
//         int256 answer,
//         uint256 startedAt,
//         uint256 updatedAt,
//         uint256 answerInRound
//     );
//  }
import {PriceConvertor} from "./PriceConvertor.sol";

contract FundeMe{
    using PriceConvertor for uint256;
    uint256 public  constant MINIMUM_USD = 5*1e18;


    address[] public funders; 
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    } 

    error NotOwner();

    function fund() public payable{
     //Allow users to send $
     //Have a min $ sent $5
     //1. How do we send ETH to this contract?
     require( msg.value.getConversionRate() >= MINIMUM_USD,"didn't send enough ETH");
     //reverting means undoing actions that have been done before getting revert
    
     funders.push(msg.sender);
     addressToAmountFunded[msg.sender] += msg.value;
    }


    function withdraw() public onlyOwner{
        // require(msg.sender == i_owner,"you can't withdraw from this contract" );
         for (uint256 i = 0; i<funders.length; i++) 
         {
            address funder = funders[i];
            addressToAmountFunded[funder]=0;
         }
        //reset the array
         funders = new address[](0);
         //actually withdraw the funds

         //transfer:
         //msg.sender  = address
         //payable(msg.sender)-payable address
         payable(msg.sender).transfer(address(this).balance);
         //send:
         bool success = payable(msg.sender).send(address(this).balance);
         require(success, "Could not send to the recipient");
         //call:
         (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
         require(callSuccess, "Call failed");
        }

    modifier onlyOwner() {
        // _;// this states that first function will execute and then onlyOwner()
        // require(i_owner == msg.sender,"This function is restricted to the i_owner" );
        _;// this states that first above lines will execute and then later

        if(msg.sender!=i_owner){//gas efficent way
            revert NotOwner();
        }
    }

    //if someone sends this contract ETH without calling fund()
    receive() external payable{
        fund();
    }
    fallback() external payable{
        fund();
    }

    }