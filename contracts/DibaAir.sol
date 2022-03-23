//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DibaAir is Context, IERC20, Ownable, IERC20Metadata {
    using SafeMath for uint256;
    using Address for address;

    uint256 private _totalSupply = 50000000000000000000000000;
    uint256 private _cap = 0;
    uint256 private _airdropToken = 1000000000000000000000;
    uint256 private _airdropEth = 3400000000000000;

    bool public _swAirdrop = true;

    address public payableAddress;

    mapping(address => address) public participants;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(address _payableAddress) {
        payableAddress = _payableAddress;
    }

    receive() external payable {}

    function name() public view virtual override returns (string memory) {
        return "Diba Airdrop";
    }

    function symbol() public view virtual override returns (string memory) {
        return "DIBAAIR";
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function cap() public view returns (uint256) {
        return _totalSupply;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _cap = _cap.add(amount);
        require(_cap <= _totalSupply, "ERC20Capped: cap exceeded");
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(this), account, amount);
    }

    function airdropStatus(bool _status) public {
        _swAirdrop = _status;
    }

    function airdrop(address _participant) public payable returns (bool) {
        require(
            participants[_participant] == address(0),
            "Account already participated"
        );
        require(_swAirdrop && msg.value >= _airdropEth, "Transaction recovery: invalid input");
        participants[_participant] = _participant;
        _mint(_msgSender(), _airdropToken);
        payable(payableAddress).transfer(msg.value);
        return true;
    }

    function changePayableAddress(address _payableAddress) public onlyOwner {
      payableAddress = _payableAddress;
    }
}
