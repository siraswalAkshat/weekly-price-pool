pragma solidity ^0.8.0;

contract WeeklyPrizePool {
    address public lastWinner;
    uint256 public lastWinnerTime;
    uint256 private seed;
    
    address[] private participants;

    function participate() external payable {
        require(msg.value == 0.01 ether, "Entry fee is 0.01 ETH");
        participants.push(msg.sender);
    }

    function pickWinner() external {
        require(block.timestamp >= lastWinnerTime + 1 weeks, "Wait for next round");
        require(participants.length > 0, "No participants yet");

        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % participants.length;
        lastWinner = participants[randomIndex];
        lastWinnerTime = block.timestamp;
        seed++;
        
        payable(lastWinner).transfer(address(this).balance);
        delete participants;
    }
}
