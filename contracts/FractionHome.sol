// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Token.sol";

/// @title FractionHome - fractional ownership of one property. Buy shares with a stablecoin;
/// the owner deposits rent which is shared pro rata between current shareholders.
contract FractionHome {
    IERC20 public immutable payToken;
    address public owner;
    string public propertyName;
    uint256 public totalShares;
    uint256 public pricePerShare;
    uint256 public sold;
    uint256 public proceeds;
    uint256 public accRentPerShare; // 1e18 scale

    mapping(address => uint256) public shares;
    mapping(address => uint256) public checkpoint;
    mapping(address => uint256) public owed;

    event SharesBought(address indexed user, uint256 count, uint256 cost);
    event SharesTransferred(address indexed from, address indexed to, uint256 count);
    event RentDeposited(uint256 amount);
    event RentClaimed(address indexed user, uint256 amount);

    modifier onlyOwner() { require(msg.sender == owner, "owner only"); _; }

    constructor(address _payToken, string memory _name, uint256 _totalShares, uint256 _pricePerShare) {
        require(_totalShares > 0 && _pricePerShare > 0, "bad params");
        payToken = IERC20(_payToken);
        owner = msg.sender;
        propertyName = _name;
        totalShares = _totalShares;
        pricePerShare = _pricePerShare;
    }

    function _settle(address u) internal {
        owed[u] += (shares[u] * (accRentPerShare - checkpoint[u])) / 1e18;
        checkpoint[u] = accRentPerShare;
    }
    function pendingRent(address u) public view returns (uint256) {
        return owed[u] + (shares[u] * (accRentPerShare - checkpoint[u])) / 1e18;
    }

    function buyShares(uint256 count) external {
        require(count > 0 && sold + count <= totalShares, "not enough shares left");
        uint256 cost = count * pricePerShare;
        _settle(msg.sender);
        shares[msg.sender] += count;
        sold += count;
        proceeds += cost;
        require(payToken.transferFrom(msg.sender, address(this), cost), "transfer");
        emit SharesBought(msg.sender, count, cost);
    }

    function transferShares(address to, uint256 count) external {
        require(to != address(0) && count > 0 && shares[msg.sender] >= count, "bad transfer");
        _settle(msg.sender);
        _settle(to);
        shares[msg.sender] -= count;
        shares[to] += count;
        emit SharesTransferred(msg.sender, to, count);
    }

    function depositRent(uint256 amount) external onlyOwner {
        require(sold > 0 && amount > 0, "no shareholders");
        accRentPerShare += (amount * 1e18) / sold;
        require(payToken.transferFrom(msg.sender, address(this), amount), "transfer");
        emit RentDeposited(amount);
    }

    function claimRent() external {
        _settle(msg.sender);
        uint256 amount = owed[msg.sender];
        require(amount > 0, "nothing to claim");
        owed[msg.sender] = 0;
        require(payToken.transfer(msg.sender, amount), "transfer");
        emit RentClaimed(msg.sender, amount);
    }

    function withdrawProceeds() external onlyOwner {
        uint256 amount = proceeds;
        require(amount > 0, "nothing to withdraw");
        proceeds = 0;
        require(payToken.transfer(owner, amount), "transfer");
    }
}
