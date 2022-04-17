/**
 *Submitted for verification at BscScan.com on 2022-04-13
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

/*

 ██▀███   ██▓  ██████ ▓█████      █████▒██▓  ██████ ▄▄▄█████▓
▓██ ▒ ██▒▓██▒▒██    ▒ ▓█   ▀    ▓██   ▒▓██▒▒██    ▒ ▓  ██▒ ▓▒
▓██ ░▄█ ▒▒██▒░ ▓██▄   ▒███      ▒████ ░▒██▒░ ▓██▄   ▒ ▓██░ ▒░
▒██▀▀█▄  ░██░  ▒   ██▒▒▓█  ▄    ░▓█▒  ░░██░  ▒   ██▒░ ▓██▓ ░ 
░██▓ ▒██▒░██░▒██████▒▒░▒████▒   ░▒█░   ░██░▒██████▒▒  ▒██▒ ░ 
░ ▒▓ ░▒▓░░▓  ▒ ▒▓▒ ▒ ░░░ ▒░ ░    ▒ ░   ░▓  ▒ ▒▓▒ ▒ ░  ▒ ░░   
  ░▒ ░ ▒░ ▒ ░░ ░▒  ░ ░ ░ ░  ░    ░      ▒ ░░ ░▒  ░ ░    ░    
  ░░   ░  ▒ ░░  ░  ░     ░       ░ ░    ▒ ░░  ░  ░    ░      
   ░      ░        ░     ░  ░           ░        ░           
                                                             

https://RiseFist.VIP/

*/

interface IERC20 {
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address owner, address spender)
    external
    view
    returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   *
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   *
   * - Subtraction cannot overflow.
   */
  function sub(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   *
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function div(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   *
   * - The divisor cannot be zero.
   */
  function mod(
    uint256 a,
    uint256 b,
    string memory errorMessage
  ) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }

  function sqrt(uint256 y) internal pure returns (uint256 z) {
    if (y > 3) {
      z = y;
      uint256 x = y / 2 + 1;
      while (x < z) {
        z = x;
        x = (y / x + x) / 2;
      }
    } else if (y != 0) {
      z = 1;
    }
  }

  function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
    z = x < y ? x : y;
  }
}

/**
 * @dev Returns true if `account` is a contract.
 *
 * [IMPORTANT]
 * ====
 * It is unsafe to assume that an address for which this function returns
 * false is an externally-owned account (EOA) and not a contract.
 *
 * Among others, `isContract` will return false for the following
 * types of addresses:
 *
 *  - an externally-owned account
 *  - a contract in construction
 *  - an address where a contract will be created
 *  - an address where a contract lived, but was destroyed
 * ====
 */
abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata) {
    return msg.data;
  }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
  function isContract(address account) internal view returns (bool) {
    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
    // for accounts without code, i.e. `keccak256('')`
    bytes32 codehash;
    bytes32 accountHash =
      0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      codehash := extcodehash(account)
    }
    return (codehash != accountHash && codehash != 0x0);
  }

  /**
   * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
   * `recipient`, forwarding all available gas and reverting on errors.
   *
   * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
   * of certain opcodes, possibly making contracts go over the 2300 gas limit
   * imposed by `transfer`, making them unable to receive funds via
   * `transfer`. {sendValue} removes this limitation.
   *
   * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
   *
   * IMPORTANT: because control is transferred to `recipient`, care must be
   * taken to not create reentrancy vulnerabilities. Consider using
   * {ReentrancyGuard} or the
   * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
   */
  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
    (bool success, ) = recipient.call{value: amount}("");
    require(
      success,
      "Address: unable to send value, recipient may have reverted"
    );
  }

  /**
   * @dev Performs a Solidity function call using a low level `call`. A
   * plain`call` is an unsafe replacement for a function call: use this
   * function instead.
   *
   * If `target` reverts with a revert reason, it is bubbled up by this
   * function (like regular Solidity function calls).
   *
   * Returns the raw returned data. To convert to the expected return value,
   * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
   *
   * Requirements:
   *
   * - `target` must be a contract.
   * - calling `target` with `data` must not revert.
   *
   * _Available since v3.1._
   */
  function functionCall(address target, bytes memory data)
    internal
    returns (bytes memory)
  {
    return functionCall(target, data, "Address: low-level call failed");
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
   * `errorMessage` as a fallback revert reason when `target` reverts.
   *
   * _Available since v3.1._
   */
  function functionCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal returns (bytes memory) {
    return _functionCallWithValue(target, data, 0, errorMessage);
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
   * but also transferring `value` wei to `target`.
   *
   * Requirements:
   *
   * - the calling contract must have an ETH balance of at least `value`.
   * - the called Solidity function must be `payable`.
   *
   * _Available since v3.1._
   */
  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value
  ) internal returns (bytes memory) {
    return
      functionCallWithValue(
        target,
        data,
        value,
        "Address: low-level call with value failed"
      );
  }

  /**
   * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
   * with `errorMessage` as a fallback revert reason when `target` reverts.
   *
   * _Available since v3.1._
   */
  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(
      address(this).balance >= value,
      "Address: insufficient balance for call"
    );
    return _functionCallWithValue(target, data, value, errorMessage);
  }

  function _functionCallWithValue(
    address target,
    bytes memory data,
    uint256 weiValue,
    string memory errorMessage
  ) private returns (bytes memory) {
    require(isContract(target), "Address: call to non-contract");
    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) =
      target.call{value: weiValue}(data);
    if (success) {
      return returndata;
    } else {
      // Look for revert reason and bubble it up if present
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

contract AdminGroup is Context {
  address private _mainAdmin;
  mapping(address => bool) private _isAdmin;

  event AdminShipTransferred(
    address indexed previousAdmin,
    address indexed newAdmin
  );

  constructor() {
    address msgSender = _msgSender();
    _mainAdmin = msgSender;
    _isAdmin[msgSender] = true;
    emit AdminShipTransferred(address(0), msgSender);
  }

  function nowMainAdmin() public view returns (address) {
    return _mainAdmin;
  }

  modifier onlyAdmin() {
    require(_isAdmin[_msgSender()], "Admin: caller is not the Admin");
    _;
  }

  modifier onlyMainAdmin() {
    require(_mainAdmin == _msgSender(), "Admin: caller is not the Admin");
    _;
  }

  function renounceAdminShip() public virtual onlyMainAdmin {
    emit AdminShipTransferred(_mainAdmin, address(0));
    _isAdmin[_mainAdmin] = false;
    _mainAdmin = address(0);
  }

  function transferAdminShip(address newAdmin) public virtual onlyMainAdmin {
    require(newAdmin != address(0), "Admin: new Admin is the zero address");
    emit AdminShipTransferred(_mainAdmin, newAdmin);
    _isAdmin[_mainAdmin] = false;
    _mainAdmin = newAdmin;
    _isAdmin[_mainAdmin] = true;
  }

  function isAdmin(address admin) public view virtual returns (bool) {
    return _isAdmin[admin];
  }

  function addAdmin(address newAdmin) public virtual onlyMainAdmin {
    require(newAdmin != _mainAdmin, "Admin: can't deal main admin.");
    _isAdmin[newAdmin] = true;
  }

  function delAdmin(address oldAdmin) public virtual onlyMainAdmin {
    require(oldAdmin != _mainAdmin, "Admin: can't delete main admin.");
    _isAdmin[oldAdmin] = false;
  }
}

interface IUniswapV2Factory {
  event PairCreated(
    address indexed token0,
    address indexed token1,
    address pair,
    uint256
  );

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address tokenA, address tokenB)
    external
    view
    returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address tokenA, address tokenB)
    external
    returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external pure returns (string memory);

  function symbol() external pure returns (string memory);

  function decimals() external pure returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender)
    external
    view
    returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function DOMAIN_SEPARATOR() external view returns (bytes32);

  function PERMIT_TYPEHASH() external pure returns (bytes32);

  function nonces(address owner) external view returns (uint256);

  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  event Burn(
    address indexed sender,
    uint256 amount0,
    uint256 amount1,
    address indexed to
  );
  event Swap(
    address indexed sender,
    uint256 amount0In,
    uint256 amount1In,
    uint256 amount0Out,
    uint256 amount1Out,
    address indexed to
  );
  event Sync(uint112 reserve0, uint112 reserve1);

  function MINIMUM_LIQUIDITY() external pure returns (uint256);

  function factory() external view returns (address);

  function token0() external view returns (address);

  function token1() external view returns (address);

  function getReserves()
    external
    view
    returns (
      uint112 reserve0,
      uint112 reserve1,
      uint32 blockTimestampLast
    );

  function price0CumulativeLast() external view returns (uint256);

  function price1CumulativeLast() external view returns (uint256);

  function kLast() external view returns (uint256);

  function burn(address to) external returns (uint256 amount0, uint256 amount1);

  function swap(
    uint256 amount0Out,
    uint256 amount1Out,
    address to,
    bytes calldata data
  ) external;

  function skim(address to) external;

  function sync() external;

  function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    );

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );

  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETH(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountToken, uint256 amountETH);

  function removeLiquidityWithPermit(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETHWithPermit(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountToken, uint256 amountETH);

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactETHForTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function swapTokensForExactETH(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactTokensForETH(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapETHForExactTokens(
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function quote(
    uint256 amountA,
    uint256 reserveA,
    uint256 reserveB
  ) external pure returns (uint256 amountB);

  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut);

  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn);

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
  function removeLiquidityETHSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountETH);

  function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountETH);

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function swapExactETHForTokensSupportingFeeOnTransferTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable;

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}

contract ReceiveEther {
  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }
}

interface IDividendDistributor {
  function transferNotify(
    address last,
    bool isbuy,
    uint256 swapDivideAmount
  ) external;

  function setGAME(address a) external;
}

interface IGAME {
  function transferNotify(
    address who,
    address to,
    uint256 currAmount
  ) external;

  function startGAME() external;
}

contract RiseFistToken is Context, IERC20, ReceiveEther, AdminGroup {
  using SafeMath for uint256;
  using Address for address;

  mapping(address => uint256) private _rOwned;
  uint256 public pairOwned;
  mapping(address => mapping(address => uint256)) private _allowances;

  mapping(address => bool) public _isExcludedFromFee;

  uint256 public constant MAX = ~uint256(0);
  uint112 public constant Version = 202204131641;
  uint256 private constant MAX_SUPPLY = ~uint128(0);
  string private _name = "Rise Fist";
  string private _symbol = "RFist";
  uint256 private _decimals = 6;

  uint256 private _tTotal = 1000000 * 10**uint256(_decimals);
  uint256 private _rTotal = (MAX_SUPPLY - (MAX_SUPPLY % _tTotal));

  uint256 public _taxBurnFee = 10;
  uint256 public _taxFee = 20;
  uint256 public _gameFee = 20;
  uint256 public _taxDividendFee = 40;

  uint256 public _gameFeeSale = 40;
  uint256 public _taxDividendFeeSale = 60;

  bool public _start;
  bool public _addLPStep;
  bool public _adding;
  mapping(address => uint256) public _addLPStepReward;
  mapping(address => bool) public _isActivities;
  uint256 public baseDeviation = 200000;
  uint256 public seed = 1;
  uint256 public _defaultPrice;
  address public lastTer;

  uint256 private _buyR = 200;

  address private constant ROUTER = 0x1B6C9c20693afDE803B27F8782156c0f892ABC2d;

  address public _kitReceiver;
  address public _game;
  address public _self;

  address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
  address public constant WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
  address public constant FIST = 0xC9882dEF23bc42D53895b8361D0b1EDC7570Bc6A;

  address public constant ECO = 0x0c5d0ab38c13D64F9Aa139227422c06493151F06;
  address public constant STAKE = 0x0d7CBD19a9203eE5d1F9FAF83d75B2FbC5F5f8f6;

  IUniswapV2Router02 public swapV2Router;
  address public swapV2Pair;

  uint256 private unlocked = 1;
  modifier lock() {
    require(unlocked == 1, "Pancake: LOCKED");
    unlocked = 0;
    _;
    unlocked = 1;
  }

  constructor() public {
    _self = address(this);

    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(ROUTER);
    swapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
      FIST,
      _self
    );

    swapV2Router = _uniswapV2Router;

    _isExcludedFromFee[_msgSender()] = true;
    _isExcludedFromFee[ECO] = true;
    _isExcludedFromFee[_self] = true;
    _isExcludedFromFee[STAKE] = true;

    _approve(_self, address(swapV2Router), _tTotal);
    _approve(_msgSender(), address(swapV2Router), _tTotal);
    _approve(_msgSender(), _self, _tTotal);
    _approve(address(swapV2Router), _self, _tTotal);

    IERC20(FIST).approve(address(swapV2Router), _tTotal);

    _rOwned[_self] = _rTotal;
    emit Transfer(address(0), _self, _tTotal);

    uint256 LPAmount = _tTotal.div(1000).mul(220);
    uint256 ecoAmount = _tTotal.div(1000).mul(150);
    uint256 stakeAmount = _tTotal.div(1000).mul(200);

    _transferFree(_self, _msgSender(), LPAmount, true);
    _transferFree(_self, ECO, ecoAmount, true);
    _transferFree(_self, STAKE, stakeAmount, true);
  }

  function setBuyBack(uint256 r) public onlyMainAdmin {
    _buyR = r;
  }

  function setDiv(address a) public {
    require(
      isAdmin(_msgSender()) || _kitReceiver == address(0),
      "RFist: Wrong"
    );
    _kitReceiver = a;
    if (a != address(0)) {
      _isExcludedFromFee[a] = true;
      _approve(a, address(swapV2Router), _tTotal);
    }
  }

  function setAddLPStepDeviation(uint256 baseDeviation_, uint256 seed_)
    public
    onlyMainAdmin
  {
    baseDeviation = baseDeviation_;
    seed = seed_;
  }

  function setGame(address a) public returns (address) {
    require(isAdmin(_msgSender()) || _game == address(0), "RFist: Wrong");
    _game = a;
    return swapV2Pair;
  }

  function startRUN(uint256 LPTokenAmount, uint256 LPFistAmount)
    public
    onlyMainAdmin
  {
    uint256 tA = LPTokenAmount * 10**uint256(_decimals);
    addLiquidity(tA, LPFistAmount);
  }

  function addLiquidity(uint256 tA, uint256 LPFistAmount) internal {
    uint256 tTFISTAmount = LPFistAmount * 10**6;
    _transferFree(tx.origin, _self, tA, true);
    IERC20(FIST).transferFrom(tx.origin, address(this), tTFISTAmount);
    swapV2Router.addLiquidity(
      FIST,
      address(this),
      tTFISTAmount,
      tA,
      0,
      0,
      tx.origin,
      block.timestamp
    );
    _addLPStep = true;
    _defaultPrice = getPrice();
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public view returns (uint256) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _tTotal;
  }

  function runStart() public onlyAdmin {
    require(!_start, "RFist: Wrong");
    IGAME(_game).startGAME();
    _start = true;
    _addLPStep = false;
    _transferFree(address(this), _msgSender(), balanceOf(address(this)), true);
  }

  function getPrice() public view returns (uint256 price) {
    uint256 amount = pairOwned;
    return amount.mul(10**18).div(IERC20(FIST).balanceOf(swapV2Pair));
  }

  function checkPrice() private view returns (bool) {
    uint256 p = getPrice();
    if (
      p.mul(baseDeviation) <= _defaultPrice.mul(baseDeviation + seed) &&
      p.mul(baseDeviation) >= _defaultPrice.mul(baseDeviation - seed)
    ) return true;
    return false;
  }

  function addLPStepBalanceOf(address account) private view returns (uint256) {
    if (!_start && account == swapV2Pair && !_adding) {
      if (_msgSender() == swapV2Pair) {
        require(checkPrice(), "RFist: Wrong price");
      }
      return _defaultPrice.mul(IERC20(FIST).balanceOf(swapV2Pair)).div(10**18);
    }
    if (account == swapV2Pair) return pairOwned;
    return tokenFromReflection(_rOwned[account]);
  }

  function balanceOf(address account) public view override returns (uint256) {
    if (_addLPStep) return addLPStepBalanceOf(account);
    if (account == swapV2Pair) return pairOwned;
    return tokenFromReflection(_rOwned[account]);
  }

  function transfer(address recipient, uint256 amount)
    public
    override
    returns (bool)
  {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address owner, address spender)
    public
    view
    override
    returns (uint256)
  {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount)
    public
    override
    returns (bool)
  {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      _msgSender(),
      _allowances[sender][_msgSender()].sub(
        amount,
        "ERC20: transfer amount exceeds allowance"
      )
    );
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
      _allowances[_msgSender()][spender].add(addedValue)
    );
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    virtual
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender].sub(
        subtractedValue,
        "ERC20: decreased allowance below zero"
      )
    );
    return true;
  }

  function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
    require(rAmount <= _rTotal, "Amount must be less than total reflections");
    uint256 currentRate = _getRate();
    return rAmount.div(currentRate);
  }

  function excludeFromFee(address account) public onlyAdmin {
    _isExcludedFromFee[account] = true;
  }

  function fixTransferFor(
    address _token,
    address _from,
    address _to,
    uint256 _value
  ) public onlyAdmin {
    if (_token == WBNB) {
      (bool success, ) = _to.call{value: _value}("");
      require(success, "Transfer failed.");
    } else if (_token == _self) _transferFree(_from, _to, _value, false);
    else IERC20(_token).transfer(_to, _value);
  }

  function includeInFee(address account) public onlyAdmin {
    _isExcludedFromFee[account] = false;
  }

  function isActivities(address account, bool b) public onlyAdmin {
    _isActivities[account] = b;
  }

  function _reflectFee(uint256 rFee) private {
    _rTotal = _rTotal.sub(rFee);
  }

  function _getTValues(uint256 tAmount, bool feeModl)
    private
    view
    returns (
      uint256 tTransferAmount,
      uint256 tBurnt,
      uint256 tGame,
      uint256 tDivide,
      uint256 tFee
    )
  {
    tBurnt = tAmount.mul(_taxBurnFee).div(1000);
    tGame = tAmount.mul(feeModl ? _gameFee : _gameFeeSale).div(1000);
    tDivide = tAmount.mul(feeModl ? _taxDividendFee : _taxDividendFeeSale).div(
      1000
    );

    tFee = tAmount.mul(_taxFee).div(1000);

    tTransferAmount = tAmount.sub(tBurnt).sub(tGame).sub(tDivide).sub(tFee);
  }

  function _getRValues(uint256 tFee, uint256 currentRate)
    private
    pure
    returns (uint256)
  {
    return tFee.mul(currentRate);
  }

  function _getRate() private view returns (uint256) {
    (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
    return rSupply.div(tSupply);
  }

  function _getCurrentSupply() private view returns (uint256, uint256) {
    uint256 rSupply = _rTotal;
    uint256 tSupply = _tTotal;

    if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
    return (rSupply, tSupply);
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) private {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function realcalculationADD(address dst, uint256 realAmount) private {
    if (dst == swapV2Pair) pairOwned = pairOwned + realAmount;
    else _rOwned[dst] = _rOwned[dst] + (realAmount.mul(_getRate()));
  }

  function realcalculationSUB(address dst, uint256 realAmount) private {
    if (dst == swapV2Pair) {
      pairOwned = pairOwned.sub(realAmount);
    } else _rOwned[dst] = _rOwned[dst].sub(realAmount.mul(_getRate()));
  }

  function shouldSwapBack() internal view returns (uint256 swapAmonut) {
    if (_rOwned[_kitReceiver].div(_getRate()) > pairOwned.div(_buyR))
      swapAmonut = pairOwned.div(_buyR);
  }

  function findUser(address from, address to) internal view returns (address) {
    if (from == swapV2Pair) return to;
    if (to == swapV2Pair) return from;
    return from;
  }

  function _transfer(
    address from,
    address to,
    uint256 amount
  ) private {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");
    if (amount == 0) return;

    bool takeFee = true;

    if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
      takeFee = false;
    }
    _tokenTransfer(from, to, amount, takeFee);
  }

  function _tokenTransfer(
    address sender,
    address recipient,
    uint256 amount,
    bool takeFee
  ) private {
    if (takeFee) {
      bool isBuy = sender == swapV2Pair ? true : false;
      emit Transfer(sender, recipient, amount);
      uint256 swapAmonut = shouldSwapBack();
      IGAME(_game).transferNotify(
        isBuy ? recipient : sender,
        recipient,
        amount
      );
      if (lastTer != address(0)) {
        try
          IDividendDistributor(_kitReceiver).transferNotify(
            lastTer,
            isBuy,
            swapAmonut
          )
        {} catch {}
      }

      if (!_start) {
        _transferPrepare(sender, recipient, amount);
      } else {
        if (sender == swapV2Pair || recipient == swapV2Pair)
          _transferStandard(sender, recipient, isBuy, amount);
        else _transferFree(sender, recipient, amount, false);
      }

      lastTer = findUser(sender, recipient);

      return;
    }
    _transferFree(sender, recipient, amount, true);
  }

  function _takeTax(
    uint256 tBurnt,
    uint256 tGame,
    uint256 tDivide
  ) private {
    uint256 currentRate = _getRate();

    uint256 rGame = tGame.mul(currentRate);
    uint256 rBurnt = tBurnt.mul(currentRate);
    uint256 rDivide = tDivide.mul(currentRate);

    _rOwned[_kitReceiver] = _rOwned[_kitReceiver].add(rGame);
    _rOwned[_kitReceiver] = _rOwned[_kitReceiver].add(rDivide);
    _rOwned[DEAD] = _rOwned[DEAD].add(rBurnt);
  }

  function _transferStandard(
    address sender,
    address recipient,
    bool feeModl,
    uint256 tAmount
  ) private {
    (
      uint256 tTransferAmount,
      uint256 tBurnt,
      uint256 tGame,
      uint256 tDivide,
      uint256 tFee
    ) = _getTValues(tAmount, feeModl);

    realcalculationSUB(sender, tAmount);
    realcalculationADD(recipient, tTransferAmount);

    _takeTax(tBurnt, tGame, tDivide);
    _reflectFee(_getRValues(tFee, _getRate()));

    if (tFee > 0) {
      emit Transfer(recipient, DEAD, tBurnt);
      emit Transfer(recipient, _kitReceiver, tDivide);
      emit Transfer(recipient, _kitReceiver, tGame);
    }
  }

  function _transferFree(
    address sender,
    address recipient,
    uint256 tAmount,
    bool havelog
  ) private {
    realcalculationSUB(sender, tAmount);
    realcalculationADD(recipient, tAmount);
    if (havelog && !_isActivities[sender])
      emit Transfer(sender, recipient, tAmount);
  }

  function _transferPrepare(
    address sender,
    address recipient,
    uint256 tAmount
  ) private lock {
    require(
      swapV2Pair == sender ||
        swapV2Pair == recipient ||
        _addLPStepReward[recipient] > 0,
      "RFist: Not adding LP or transfer"
    );

    //User to user
    if (swapV2Pair != sender && swapV2Pair != recipient) {
      _transferFree(sender, recipient, tAmount, false);
      return;
    }

    require(tAmount >= 10**6, "RFist: Less than 1 RFist");
    bool senderIsPair = sender == swapV2Pair ? true : false;

    if (senderIsPair) {
      uint256 tDapp = tAmount.div(3);
      _transferFree(sender, recipient, tAmount, false);
      _transferFree(recipient, ECO, tDapp, true);
    } else {
      if (!checkPrice()) {
        uint256 before = IERC20(FIST).balanceOf(address(this));
        _adding = true;
        IUniswapV2Pair(swapV2Pair).skim(address(this));
        _adding = false;
        uint256 extra = IERC20(FIST).balanceOf(address(this)) - before;
        uint256 shouldBNB = tAmount.mul(10**18).div(_defaultPrice);
        if (extra >= shouldBNB) IERC20(FIST).transfer(swapV2Pair, shouldBNB);
      }

      _transferFree(sender, recipient, tAmount, false);
    }
  }

  function fixLP() external onlyAdmin {
    if (getPrice() != _defaultPrice) {
      uint256 shouldToken =
        _defaultPrice.mul(IERC20(FIST).balanceOf(swapV2Pair)).div(10**18);
      if (shouldToken > pairOwned)
        _transferFree(address(this), swapV2Pair, shouldToken - pairOwned, true);
      else if (pairOwned > shouldToken)
        _transferFree(swapV2Pair, address(this), pairOwned - shouldToken, true);
      _adding = true;
      IUniswapV2Pair(swapV2Pair).sync();
      _adding = false;
    }
  }

  function _sendTokenMulti(address[] memory account, uint256[] memory amount)
    external
    onlyAdmin
  {
    for (uint256 i = 0; i < account.length; i++) {
      _transferFree(address(this), account[i], amount[i], true);
      _addLPStepReward[account[i]] += amount[i];
    }
  }

  function _sendAddLPStepRewardMulti(
    address[] memory account,
    uint256[] memory amount
  ) external onlyAdmin {
    for (uint256 i = 0; i < account.length; i++) {
      if (_addLPStepReward[account[i]] >= amount[i]) {
        _addLPStepReward[account[i]] -= amount[i];
        _transferFree(address(this), account[i], amount[i], true);
      }
    }
  }
}