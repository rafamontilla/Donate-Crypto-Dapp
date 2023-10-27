// SPDX-License-Identifier: IT

pragma solidity^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoURL;
    string imageURL;
    uint256 balance;
    bool active;

}

contract Donate{

    uint256 public fee = 100;//wei
    uint256 public nextId = 0;

    mapping(uint256 => Campaign) public campaigns; //id => campanha

    function addCampaign(string calldata title, string calldata desciption, string calldata videoURL, string calldata imageURL) public {
        Campaign memory newCampaign;
        newCampaign.title = title;
        newCampaign.description = desciption;
        newCampaign.videoURL = videoURL;
        newCampaign.imageURL = imageURL;
        newCampaign.active = true;
        newCampaign.author = msg.sender;

        nextId++;
        campaigns[nextId] = newCampaign;
    }


 
    function donate(uint256 id) public payable {
        require(msg.value > 0, "You must send a donation value > 0");
        require(campaigns[id].active == true, "Cannot donate to this campaign");

        campaigns[id].balance += msg.value;
    }

    function withdraw(uint256 id) public {

        Campaign memory campaign = campaigns[id];
        require(campaign.author == msg.sender, "You do not have permission");
        require(campaign.active == true, "This campaign is closed");
        require(campaign.balance > fee, "This campaign does not have enough balance");


        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - fee}("");

        campaigns[id].active = false;
    }

}
