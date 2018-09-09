pragma solidity ^0.4.24;

import "./ICampaignManager.sol";
import "./ChainCampaign.sol";

contract CampaignManager is ICampaignManager {

    uint256 public totalCampaigns;
    mapping (uint256 => address) private campaigns;

    function addNew(bytes32 _name, bytes32 _description, uint256 _weeksDuration, uint256 _goal) external {
        address newCampaign = new ChainCampaign(_name, _description, _weeksDuration, _goal);
        campaigns[totalCampaigns] = newCampaign;
        emit LogCampaignCreated(totalCampaigns, newCampaign);
        totalCampaigns++;
    }
    
    function getCampaignAddress(uint256 _campaignId) external view returns (address) {
        return campaigns[_campaignId];
    }
}