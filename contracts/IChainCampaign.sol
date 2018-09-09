pragma solidity ^0.4.24;

interface IChainCampaign {

    event LogCampaignStarted(address indexed campaignAddr, uint256 startTimestamp, uint256 endTimestamp);
    event LogCampaignEnded(address indexed campaignAddr, bool succeeded, uint256 amountRaised);
    event LogProjectBacked(address indexed backerAddr, uint256 backedAmount);

    function startCampaign() external returns (bool);
    function endCampaign() external returns (bool);
    function backTheProject() external payable;
    function collectFunds() external;

}