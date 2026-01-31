// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AbhiCoin {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    address private owner;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        _name = "AbhiCoin";
        _symbol = "ABC";
        _decimals = 18;
        uint256 initialSupply =1000 * (10**uint256(_decimals));
        balances[msg.sender] = initialSupply;
        _totalSupply = initialSupply;

        emit Transfer(address(0), msg.sender, 1000);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0), "Invalid spender");

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256)
    {
        return allowed[_owner][_spender];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_from != address(0), "Invalid sender");
        require(_to != address(0), "Invalid receiver");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(uint256 amount) public onlyOwner {
        balances[owner] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), owner, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(balances[owner] >= amount, "Insufficient balance to burn");
        balances[owner] -= amount;
        _totalSupply -= amount;
        emit Transfer(owner, address(0), amount);
    }
}
