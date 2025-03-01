//SPDX-License-Identifier:MIT
pragma solidity ^0.8.19;
// import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface AggregatorV3Interface{
    function decimals() external view returns (uint256);
    function description() external view returns (string memory);
    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId) external view returns(
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint256 answerInRound
    );

    function latestRoundData() external view returns(
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint256 answerInRound
    );
 }
library PriceConvertor{
        function getPrice() internal view returns (uint256){
            //address, abi
            AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
           (,int256 price,,,) = pricefeed.latestRoundData();
           // Price of ETH in terms of USD

           return uint(price*1e10);
            
     }
     function getConversionRate(uint256 ethAmount) internal view returns(uint256){
                uint256 ethPrice = getPrice();
                uint256 ethAmountInUsd = (ethPrice * ethAmount)/1e18;
                return ethAmountInUsd;// returning eth value in dollars
     }

     function getVersion() internal view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();

     } 
}
