pragma solidity ^0.4.24;

import "./IChainCampaign.sol";

contract ChainCampaign is IChainCampaign {

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    bytes32 public name;
    bytes32 public description;
    uint256 public goal;
    uint256 public totalBackers;
    uint256 public startTs;
    uint256 public endTs;
    uint256 public totalRaised;
    uint256 public durationInWeeks;
    bool public campaignStarted;
    bool public campaignEnded;
    bool public campaignSuccessful;
    bool public campaignClosed;

    address private owner;
    mapping (address => uint256) private backers;

    constructor(bytes32 _name, bytes32 _description, uint256 _goal, uint256 _durationInWeeks) public {
        name = _name;
        description = _description;
        goal = _goal;
        durationInWeeks = _durationInWeeks;

        campaignStarted = false;
        campaignEnded = false;
        campaignSuccessful = false;
        campaignClosed = false;

        owner = tx.origin;
    }

    function startCampaign() external onlyOwner returns (bool) {
        if (!campaignStarted) {
            startTs = block.timestamp;
            endTs = startTs + durationInWeeks * 1 weeks;
            campaignStarted = true;
            emit LogCampaignStarted(this, startTs, endTs);
            return true;
        } 
        return false;
    }

    function endCampaign() external returns (bool) {
        require (endTs < block.timestamp && !campaignEnded);
        campaignEnded = true;
        campaignSuccessful = totalRaised >= goal;
        emit LogCampaignEnded(this, campaignSuccessful, totalRaised);
    }

    function backTheProject() external payable {
        require (!campaignEnded && campaignStarted);
        if (backers[msg.sender] == 0) {
            totalBackers++;
        }
        backers[msg.sender] += msg.value;
        totalRaised += msg.value;
        emit LogProjectBacked(msg.sender, msg.value);
    }

    function collectFunds() external {
        require (campaignEnded && campaignSuccessful && !campaignClosed);
        owner.transfer(totalRaised);
        campaignClosed = true;
    }
}