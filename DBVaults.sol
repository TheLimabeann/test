// SPDX-License-Identifier: AGPL-3.0
pragma solidity =0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
library Address {

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function mint(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function decimals() external view returns (uint8);
}
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
contract ERC721Holder is IERC721Receiver {
 
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
interface IERC165 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
interface IERC721 is IERC165 {  
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}
interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(uint256 value) internal pure returns (string memory) {
        
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;
    string private _name;
    string private _symbol;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
  
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}
interface Router {
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}
interface RewardsPool {
    function mint(uint256 amount, IERC20 token, address recipient) external;
}
interface Farms {
    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
        uint256 totalIn;
        uint256 totalOut;
        uint256 totalRewards;
    }
    struct PoolInfo {
        string name;
        IERC20 lpToken;
        bool isLp;
        uint256 allocPoint;
        uint256 lastTimestamp;
        uint256 accPerShare;
        ERC721[] boosters;
        string[] boostersMetaData;
        uint256[] boostersPerc;
    }

    //read
    function getUser(uint _pid, address _account) external view returns(UserInfo memory);
    function getPool(uint _pid) external view returns(PoolInfo memory);
    function getTotalPools() external view returns (uint);
    function pendingRewards(uint256 _pid, address _account) external view returns (uint256);
    function getLogicContract() external view returns(address);
    function getRewardPerSecond() external view returns(uint256);
    function getMultiplier() external view returns(uint256);
    function getTotalAllocPoint() external view returns(uint256);
    function getTvl(uint _pid) external view returns(uint256);

    //write
    function deposit(uint256 _pid, uint256 _amount) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
}

// change to dbvaults after testing
contract DBCompounder is Ownable {
    using SafeMath for uint256;

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
        uint256 lastStaked;
    }
    
    uint256 internal lastCompounded = 0;
    IERC20 internal DBX = IERC20(0x0b257fe969d8782fAcb4ec790682C1d4d3dF1551);
    IERC20 internal vDBX = IERC20(0xc71E4a725c10B38Ddb35BE8aB3d1D77fEd89093F);
    IERC20 internal DBC = IERC20(0x912CE59144191C1204E64559FE8253a0e49E6548); //currently set to arb for testing change after
    IERC20 internal WETH = IERC20(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
    Router internal router = Router(0x565C093907E5D8148e5964A6cae76780140c3004);
    Farms internal farms = Farms(0xf2f1565a3801742C42286E2C6717460dFB9aE9CD);
    RewardsPool internal rewardsPool = RewardsPool(0xb6B72F2a5FF537C0F0B21580B2BD644325411094);
    address internal teamWallet = 0xdCB8AEb8634D38fEF75BD4D5C542C62069e01a1f; //change to multisig for deployment after testing
    address internal rewardWallet = 0xb6B72F2a5FF537C0F0B21580B2BD644325411094;

    event Deposit(address indexed account, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed account, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event Harvest(address indexed user);
    event AddAdmin(address indexed user);
    event RemoveAdmin(address indexed user);

    mapping(address => uint256) internal periodLastReset;
    mapping(address => uint256) internal allTimeTracking;
    mapping(address => uint256) internal periodTracking;

    mapping(uint => uint256) internal rewardsPerShare;
    mapping(uint => mapping(address => UserInfo)) internal userInfo;
    mapping (address => bool) internal Admins;
    address[] internal AdminList;

    modifier isAdmin() {
        bool isAnAdmin = false;
        if (owner() == msg.sender) { isAnAdmin = true; }
        if (Admins[msg.sender]) { isAnAdmin = true; }
        require(isAnAdmin == true, "caller is not an admin");
        _;
    }

    /* ---------- AdminFunctions ---------- */
    function addAdmin(address _account) isAdmin public {
        Admins[_account] = true;
        AdminList.push(_account);
        emit AddAdmin(_account);
    }
    function removeAdmin(address _account) isAdmin public {
        Admins[_account] = false;
        for (uint256 i = 0; i < AdminList.length; i++) {
            if (AdminList[i] == _account) {
                AdminList[i] = AdminList[AdminList.length - 1];
                AdminList.pop();
                break;
            }
        }
        emit RemoveAdmin(_account);
    }

    /* ---------- ReadFunctions ---------- */
    function getTotalPools() public view returns(uint) {
        return farms.getTotalPools();
    }
    function getPool(uint _pid) public view returns(Farms.PoolInfo memory) {
        return farms.getPool(_pid);
    }
    function getLogicContract() public view returns(address) {
        return farms.getLogicContract();
    }
    function getVaultsRewards() public view returns (uint256) {
        uint256 rewards = 0;
        for (uint256 pid = 0; pid < getTotalPools(); pid++) {
            rewards = rewards.add(farms.pendingRewards(pid, address(this)));
        }
        rewards = rewards.add(getTvl(0));
        return rewards;
    }
    function getTvl(uint _pid) public view returns (uint256) {
        Farms.UserInfo memory user = farms.getUser(_pid, address(this));
        return user.amount;
    }
    function getRewardsPerSecond(uint _pid) public view returns (uint256) {
        return rewardsPerShare[_pid];
    }
    function getLastCompounded() public view returns (uint256) {
        return lastCompounded;
    }
    function getUser(uint _pid, address _account) public view returns(UserInfo memory) {
        return userInfo[_pid][_account];
    }
    function getDBX() public view returns (IERC20) {
        return DBX;
    }
    function getWETH() public view returns (IERC20) {
        return WETH;
    }
    function getDBC() public view returns (IERC20) {
        return DBC;
    }
    function getVDBX() public view returns (IERC20) {
        return vDBX;
    }
    function getRouter() public view returns (Router) {
        return router;
    }
    function getFarms() public view returns (Farms) {
        return farms;
    }
    function getRewardsPool() public view returns (RewardsPool) {
        return rewardsPool;
    }
    function getTeamWallet() public view returns (address) {
        return teamWallet;
    }
    function getRewardWallet() public view returns (address) {
        return rewardWallet;
    }
    function getPeriodLastReset(address _token) public view returns (uint256) {
        return periodLastReset[_token];
    }
    function getPeriodTracking(address _token) public view returns (uint256) {
        return periodTracking[_token];
    }
    function getAllTimeTracking(address _token) public view returns (uint256) {
        return allTimeTracking[_token];
    }
    function admin(address _account) public view returns (bool) {
        return Admins[_account];
    }
    function admins() public view returns (address[] memory) {
        return AdminList;
    }

    /* ---------- WriteFunctions ---------- */
    function updateRouter(Router _newRouter) isAdmin public {
        router = _newRouter;
    }
    function updateFarms(Farms _newFarms) isAdmin public {
        farms = _newFarms;
    }
    function updateRewardsPool(RewardsPool _newRewardsPool) isAdmin public {
        rewardsPool = _newRewardsPool;
    }
    function updateTeamWallet(address _newTeamWallet) isAdmin public {
        teamWallet = _newTeamWallet;
    }
    function updateRewardWallet(address _newRewardWallet) isAdmin public {
        rewardWallet = _newRewardWallet;
    }
    function skim() isAdmin public {
        uint256 balance = DBX.balanceOf(address(this));
        DBX.transfer(address(rewardsPool), balance);
        periodTracking[address(DBX)] = periodTracking[address(DBX)].add(balance);
        allTimeTracking[address(DBX)] = allTimeTracking[address(DBX)].add(balance);
    }
    function resetPeriodTracking(address _token) isAdmin public {
        periodLastReset[_token] = block.timestamp;
        periodTracking[_token] = 0;
    }

    /* ---------- StakingManagement ---------- */
    function deposit(uint256 _pid, uint256 _amount) public {
        _deposit(_pid, _amount, msg.sender, msg.sender);
    }
    function withdraw(uint256 _pid, uint256 _amount) public {
        _withdraw(_pid, _amount, msg.sender);
    }
    function emergencyWithdraw(uint256 _pid) public {
        _emergencyWithdraw(_pid, msg.sender);
    }
    function harvest() public {
        _harvest(msg.sender);
        emit Harvest(msg.sender);
    }
    function autoCompound() public {
        uint256 rewards = 0;
        uint256 preBalance = DBX.balanceOf(address(this));

        for (uint256 pid = 0; pid < getTotalPools(); pid++) {
            farms.withdraw(pid, 0);
            uint256 pending = DBX.balanceOf(address(this)).sub(preBalance);
            if(pending > 0) {
                rewardsPerShare[pid] = rewardsPerShare[pid].add(pending.mul(1e18).div(getTvl(pid)));
            }
            rewards = rewards.add(pending);
            preBalance = DBX.balanceOf(address(this));
        }

        IERC20 lpToken = IERC20(farms.getPool(0).lpToken);
        lpToken.approve(getLogicContract(), rewards);
        farms.deposit(0, rewards);
        lastCompounded = block.timestamp;
        DBX.transfer(address(rewardsPool), DBX.balanceOf(address(this)));
    }
    function pendingRewards(address _account) public view returns (uint256, uint256, uint256) {
        uint256 rewards = 0;
        uint256 perSecond = farms.getRewardPerSecond();
        uint256 multiplier = farms.getMultiplier();
        uint256 totalPoints = farms.getTotalAllocPoint();

        for (uint256 pid = 1; pid < getTotalPools(); pid++) {
            UserInfo memory user = userInfo[pid][_account];
            Farms.PoolInfo memory pool = getPool(pid);
            if (user.amount > 0) {
                uint256 accRate = rewardsPerShare[pid];
                uint256 secs = block.timestamp.sub(pool.lastTimestamp);
                uint256 rate = perSecond.mul(multiplier).div(1000);
                uint256 reward = secs.mul(rate).mul(pool.allocPoint).div(totalPoints);
                uint256 lpSupply = farms.getTvl(pid);
                accRate = accRate.add(reward.mul(1e18).div(lpSupply));
                rewards = rewards.add(user.amount.mul(accRate).div(1e18).sub(user.rewardDebt));
            }
        }

        if (rewards == 0) {
            return (0, 0, 0);
        } else {
            uint256 accPerShare = farms.pendingRewards(0, address(this)).mul(1e18).div(getTvl(0));
            if (accPerShare > 0) {
                uint256 pending = rewards.mul(accPerShare).div(1e18).sub(userInfo[0][_account].rewardDebt);
                rewards = rewards.add(pending);
            }

            address[] memory path;
            path = new address[](3);
            path[0] = address(DBX);
            path[1] = address(WETH);
            path[2] = address(DBC);
            uint256[] memory amountOut = router.getAmountsOut(rewards.mul(30).div(100), path);
            uint256 pendingDbc = amountOut[2];
            
            return (rewards.mul(50).div(100), pendingDbc, rewards.mul(20).div(100));
        }
    }
    function depositOnBehalf(uint256 _pid, uint256 _amount, address _account) isAdmin public {
        _deposit(_pid, _amount, _account, msg.sender);
    }
    function withdrawOnBehalf(uint256 _pid, uint256 _amount, address _account) isAdmin public {
        _withdraw(_pid, _amount, _account);
    }
    function emergencyWithdrawOnBehalf(uint256 _pid, address _account) isAdmin public {
        _emergencyWithdraw(_pid, _account);
    }
    function harvestOnBehalf(address _account) isAdmin public {
        _harvest(_account);
        emit Harvest(_account);
    }
    function _deposit(uint256 _pid, uint256 _amount, address _account, address _payee) internal {
        require(_pid != 0, "pool id not allowed");
        require(_pid < getTotalPools(), "pool does not exist");
        require(_amount > 0, "deposit must be larger than 0");
        autoCompound();
        UserInfo storage user = userInfo[_pid][_account];
        uint256 userAmount = _amount.mul(99).div(100);
        uint256 teamAmount = _amount.sub(userAmount);
        IERC20 lpToken = IERC20(farms.getPool(_pid).lpToken);
        require(lpToken.balanceOf(_payee) >= _amount, "balance to low");
        require(lpToken.allowance(_payee, address(this)) >= _amount, "amount not approved");
        lpToken.approve(getLogicContract(), userAmount);
        lpToken.transferFrom(_payee, address(this), _amount);        
        lpToken.transfer(teamWallet, teamAmount);
        periodTracking[address(lpToken)] = periodTracking[address(lpToken)].add(teamAmount);
        allTimeTracking[address(lpToken)] = allTimeTracking[address(lpToken)].add(teamAmount);
        farms.deposit(_pid, userAmount);
        user.amount = user.amount.add(userAmount);
        user.lastStaked = block.timestamp;
        emit Deposit(_account, _pid, _amount);
    }    
    function _withdraw(uint256 _pid, uint256 _amount, address _account) internal {
        require(_pid != 0, "pool id not allowed");
        require(_pid < getTotalPools(), "pool does not exist");
        require(_amount > 0, "withdrawal must be larger than 0");
        UserInfo storage user = userInfo[_pid][_account];
        require(user.amount >= _amount, "_amount greater than staked amount");        
        _harvest(_account);
        farms.withdraw(_pid, _amount);
        IERC20 lpToken = IERC20(farms.getPool(_pid).lpToken);
        uint256 userAmount = _amount;
        if (user.lastStaked.add(259200) > block.timestamp) {
            userAmount = _amount.mul(99).div(100);
            uint256 teamAmount = _amount.sub(userAmount);
            lpToken.transfer(teamWallet, teamAmount);
            periodTracking[address(lpToken)] = periodTracking[address(lpToken)].add(teamAmount);
            allTimeTracking[address(lpToken)] = allTimeTracking[address(lpToken)].add(teamAmount);
        }
        lpToken.transfer(_account, userAmount);
        user.amount = user.amount.sub(_amount);
        emit Withdraw(_account, _pid, _amount);
    }
    function _emergencyWithdraw(uint256 _pid, address _account) internal {
        require(_pid != 0, "pool id not allowed");
        require(_pid < getTotalPools(), "pool does not exist");
        UserInfo storage user = userInfo[_pid][_account];
        farms.withdraw(_pid, user.amount);
        IERC20 lpToken = IERC20(farms.getPool(_pid).lpToken);
        uint256 userAmount = user.amount;
        if (user.lastStaked.add(259200) > block.timestamp) {
            userAmount = user.amount.mul(99).div(100);
            uint256 teamAmount = user.amount.sub(userAmount);
            lpToken.transfer(teamWallet, teamAmount);
            periodTracking[address(lpToken)] = periodTracking[address(lpToken)].add(teamAmount);
            allTimeTracking[address(lpToken)] = allTimeTracking[address(lpToken)].add(teamAmount);
        }
        lpToken.transfer(_account, userAmount);
        user.amount = 0;
        user.rewardDebt = 0;
        emit EmergencyWithdraw(_account, _pid, userAmount);
    }
    function _harvest(address _account) internal {
        autoCompound();
        uint256 rewards = 0;

        for (uint256 pid = 1; pid < getTotalPools(); pid++) {
            if (userInfo[pid][_account].amount > 0) {
                rewards = rewards.add(userInfo[pid][_account].amount.mul(rewardsPerShare[pid]).div(1e18).sub(userInfo[pid][_account].rewardDebt));
                userInfo[pid][_account].rewardDebt = userInfo[pid][_account].amount.mul(rewardsPerShare[pid]).div(1e18);
            }
        }

        if (rewards > 0) {
            uint256 accPerShare = farms.pendingRewards(0, address(this)).mul(1e18).div(getTvl(0));
            if (accPerShare > 0) {
                uint256 pending = rewards.mul(accPerShare).div(1e18).sub(userInfo[0][_account].rewardDebt);
                userInfo[0][_account].rewardDebt = rewards.mul(accPerShare).div(1e18);
                rewards = rewards.add(pending);
            }

            address[] memory path;
            path = new address[](3);
            path[0] = address(DBX);
            path[1] = address(WETH);
            path[2] = address(DBC);
            uint256[] memory amountOut = router.getAmountsOut(rewards.mul(30).div(100), path);      
        
            farms.withdraw(0, rewards);
            rewardsPool.mint(rewards.mul(50).div(100), DBX, _account);
            rewardsPool.mint(amountOut[2], DBC, _account);
            rewardsPool.mint(rewards.mul(20).div(100), vDBX, _account);
            uint256 fee = rewards.mul(50).div(100);
            DBX.transfer(rewardWallet, fee);
            periodTracking[address(DBX)] = periodTracking[address(DBX)].add(fee);
            allTimeTracking[address(DBX)] = allTimeTracking[address(DBX)].add(fee);
        }
    }

    //REMOVE BEFORE DEPLOYMENT TESTING ONLY
    function rescueFunds(IERC20 _token) public isAdmin {
        _token.transfer(msg.sender, _token.balanceOf(address(this)));
    }
    function clearDBXPool() public isAdmin {
        farms.withdraw(0, getTvl(0));
        skim();
    }
}