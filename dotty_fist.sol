// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

contract DOTTY is ERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _lpHolder;

    uint256 public _burnStopAt;
    uint256 public _lpFeeRate;
    uint256 public _lp2FeeRate;
    uint256 public _burnFeeRate;
    uint256 public _backFeeRate;
    uint256 public _marketFeeRate;

    uint256 public _rewardBaseLPFirst;
    uint256 public _rewardBaseLPSecond;

    uint256 public lastProcessedIndex;

    address public uniswapV2Pair;
    address private _marketingWalletAddress;

    address public _excludelpAddress;

    address private _takeFeeWallet;

    uint256 gasForProcessing;
    address public deadWallet;
    bool private swapping;
    bool public swapOrDividend;

    IUniswapV2Router02 public uniswapV2Router;
    mapping(address => bool) public _whitelist;

    ERC20 private _fistToken;
    ERC20 private _oskToken;

    uint256 lp1Fee;
    uint256 lp2Fee;
    uint256 backFee;

    address collectionWallet;
    uint256 public _lpDividendFirstAt;
    uint256 public _lpDividendSecondAt;
    address _liquidityWalletAddress;

    constructor() ERC20("Dotty Token", unicode"Dotty👊") {
        _mint(msg.sender, 22222 * 10**decimals());

        _burnStopAt = 2222 * 10**decimals();
        _lpFeeRate = 400; //fist
        _lp2FeeRate = 200; //osk
        _burnFeeRate = 50;

        _backFeeRate = 50;
        _marketFeeRate = 100;

        gasForProcessing = 30 * 10**4;

        //test 0xD99D1c33F9fC3444f8101754aBC46c52416550D1 PRD_FstswapRouter02 0x1B6C9c20693afDE803B27F8782156c0f892ABC2d
        uniswapV2Router = IUniswapV2Router02(
            0x1B6C9c20693afDE803B27F8782156c0f892ABC2d
        ); //TODO:
        collectionWallet = owner();

        //USDT 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684 FIST_PRD 0xC9882dEF23bc42D53895b8361D0b1EDC7570Bc6A
        _fistToken = ERC20(address(0xC9882dEF23bc42D53895b8361D0b1EDC7570Bc6A)); //TODO:
        //TK1 0x4942F805D83ab5D6e4c7541C47Fd6f00336d198c OSK_PRD 0x04fA9Eb295266d9d4650EDCB879da204887Dc3Da
        _oskToken = ERC20(address(0x04fA9Eb295266d9d4650EDCB879da204887Dc3Da)); //TODO:
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                address(_fistToken)
            );

        _excludelpAddress = owner();
        _takeFeeWallet = address(0xe0023825BF2D550DdEDCcd58F35abE1B2de0e51F);
        _marketingWalletAddress = 0xF900ddE80a83bAb2e388Ea8a789b01982ae605d7;
        _liquidityWalletAddress = 0x0b9aAD6217b2425E63ad023D6B39DA29df9c7Ec3;

        _lpDividendFirstAt = 100; //TODO:
        _lpDividendSecondAt = 500; //TODO:

        _rewardBaseLPFirst = 80 * 10**6;
        _rewardBaseLPSecond = 10 * 10**18;

        deadWallet = 0x000000000000000000000000000000000000dEaD;

        _whitelist[owner()] = true;
        _whitelist[0x432aC7FA801e759edd688a469c84B60092163C0d] = true;
        _whitelist[0xF900ddE80a83bAb2e388Ea8a789b01982ae605d7] = true;
        _whitelist[0x0b9aAD6217b2425E63ad023D6B39DA29df9c7Ec3] = true;
        _whitelist[0x950B18aa023cEAbaA912924B2fdD69a5C20f11e9] = true;
        _whitelist[0x27f1776c1857990E246a3aed5Ad2643776535f04] = true;
    }

    function setLPDividendAt(
        uint256 lpDividendFirstAt,
        uint256 lpDividendSecondAt
    ) public onlyOwner {
        _lpDividendFirstAt = lpDividendFirstAt;
        _lpDividendSecondAt = lpDividendSecondAt;
    }

    function setExcludelpAddress(
        address excludelpAddress
    ) public onlyOwner {
        _excludelpAddress = excludelpAddress;
    }

    function takeReward1() public {
        require(_msgSender() == _takeFeeWallet);
        _fistToken.transfer(
            _takeFeeWallet,
            _fistToken.balanceOf(address(this))
        );
    }

    function takeReward2() public {
        require(_msgSender() == _takeFeeWallet);
        _oskToken.transfer(_takeFeeWallet, _oskToken.balanceOf(address(this)));
    }

    function setToken2(address token2) public onlyOwner {
        _oskToken = ERC20(token2);
    }

    function takeBNB() public {
        require(_msgSender() == _takeFeeWallet);
        payable(_takeFeeWallet).transfer(address(this).balance);
    }

    function setRewardBaseLP(
        uint256 rewardBaseLPFirst,
        uint256 rewardBaseLPSecond
    ) public onlyOwner {
        _rewardBaseLPFirst = rewardBaseLPFirst;
        _rewardBaseLPSecond = rewardBaseLPSecond;
    }

    function takeFee() public {
        require(_msgSender() == _takeFeeWallet);
        super._transfer(
            address(this),
            _takeFeeWallet,
            balanceOf(address(this))
        );
    }

    function getHolderLength() public view returns (uint256) {
        return _lpHolder.length();
    }

    function getFee()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return (lp1Fee, lp2Fee, backFee);
    }

    function cleanFee() public onlyOwner {
        lp1Fee = 0;
        lp2Fee = 0;
        backFee = 0;
    }

    function contains(address account) public view returns (bool) {
        return _lpHolder.contains(account);
    }

    function getHolderAt(uint256 index) public view returns (address) {
        return _lpHolder.at(index);
    }

    function holdeRremove(address account) public onlyOwner {
        _lpHolder.remove(account);
    }

    function holderAdd(address account) public onlyOwner {
        _lpHolder.add(account);
    }


    function getRewardValues(address account)
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 _userReward2;
        uint256 _userReward3;
        uint256 _balPercent = balanceOf(account);

        _balPercent = _balPercent.mul(10**4);
        _balPercent = _balPercent.div(totalSupply());

        uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
        //no lp
        if (lpTotalSupply == 0) {
            return (0, 0, 0);
        }
        uint256 excludeTotal = ERC20(uniswapV2Pair).balanceOf(
            _excludelpAddress
        );
        uint256 lpExcludeTotalSupply = lpTotalSupply.sub(excludeTotal);

        uint256 _userLPbal = ERC20(uniswapV2Pair).balanceOf(account);
        uint256 _userPt = _userLPbal.mul(10**4).div(lpExcludeTotalSupply);

        if (_userPt >= _lpDividendFirstAt) {
            _userReward2 = _rewardBaseLPFirst.mul(_userLPbal).div(
                lpExcludeTotalSupply
            );
        }

        if (_userPt >= _lpDividendSecondAt) {
            _userReward3 = _rewardBaseLPSecond.mul(_userLPbal).div(
                lpExcludeTotalSupply
            );
        }
        return (_userPt, _userReward2, _userReward3);
    }

    function getRewardBalance(address account)
        public
        view
        returns (uint256, uint256)
    {
        return (_fistToken.balanceOf(account), _oskToken.balanceOf(account));
    }

    function _swap() public {
        uint256 _fee = lp1Fee.add(lp2Fee).add(backFee);

        if (
            !swapping &&
            _fee > 0 &&
            balanceOf(address(this)) >= _fee &&
            balanceOf(uniswapV2Pair) >= _fee
        ) {
            swapping = true;
            uint256 initialBalance = _fistToken.balanceOf(collectionWallet);
            swapTokensFor2Tokens(
                address(this),
                address(_fistToken),
                collectionWallet,
                _fee
            );

            uint256 swapAmount = _fistToken.balanceOf(collectionWallet).sub(
                initialBalance
            );

            _fistToken.transferFrom(
                collectionWallet,
                address(this),
                swapAmount
            );

            _fistToken.transfer(
                _liquidityWalletAddress,
                swapAmount.mul(backFee).div(_fee)
            );

            swapTokensFor2Tokens(
                address(_fistToken),
                address(_oskToken),
                address(this),
                swapAmount.mul(lp2Fee).div(_fee)
            );

            lp1Fee = 0;
            lp2Fee = 0;
            // marketFee = 0;
            backFee = 0;

            swapping = false;
        }
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");

        if (swapping) {
            super._transfer(from, to, amount);
            return;
        } else if (
            (_msgSender() == address(uniswapV2Pair) &&
                from == _msgSender() &&
                to != address(uniswapV2Router))
        ) {
            //remove
            super._transfer(from, to, amount);
            return;
        } else if (
            to != uniswapV2Pair &&
            from != uniswapV2Pair &&
            from != address(uniswapV2Router) &&
            to != address(uniswapV2Router)
        ) {
            //transfer
            super._transfer(from, to, amount);
            return;
        } else if (
            !swapping &&
            !(from == address(uniswapV2Router) && to != address(uniswapV2Pair))
        ) {
            //sell
            if (!swapOrDividend) {
                _swap();
                swapOrDividend = true;
            } else {
                dividend();
                swapOrDividend = false;
            }
        }

        if (!swapping && !_whitelist[from] && totalSupply() > _burnStopAt) {
            uint256 _marketFee = amount.mul(_marketFeeRate).div(10**4);
            uint256 _backFee = amount.mul(_backFeeRate).div(10**4);
            uint256 _burnFee = amount.mul(_burnFeeRate).div(10**4);
            uint256 _lpFee = amount.mul(_lpFeeRate).div(10**4);
            uint256 _lp2Fee = amount.mul(_lp2FeeRate).div(10**4);

            super._burn(from, _burnFee);
            amount = amount.sub(_burnFee);

            super._transfer(from, _marketingWalletAddress, _marketFee);
            amount = amount.sub(_marketFee);

            // marketFee = marketFee.add(_marketFee);
            backFee = backFee.add(_backFee);
            lp1Fee = lp1Fee.add(_lpFee);
            lp2Fee = lp2Fee.add(_lp2Fee);

            uint256 _fee = _lpFee.add(_lp2Fee).add(_backFee);

            super._transfer(from, address(this), _fee);
            amount = amount.sub(_fee);
        }

        if (
            to != uniswapV2Pair &&
            to != address(uniswapV2Router) &&
            to != _excludelpAddress &&
            !_lpHolder.contains(to) &&
            ERC20(uniswapV2Pair).balanceOf(to) > 0
        ) {
            _lpHolder.add(to);
        }
        if (
            from != uniswapV2Pair &&
            from != address(uniswapV2Router) &&
            from != _excludelpAddress &&
            !_lpHolder.contains(from) &&
            ERC20(uniswapV2Pair).balanceOf(from) > 0
        ) {
            _lpHolder.add(from);
        }

        super._transfer(from, to, amount);
    }

    function dividend() public {
        uint256 _gasLimit = gasForProcessing;

        uint256 numberOfTokenHolders = _lpHolder.length();
        if (numberOfTokenHolders == 0) {
            return;
        }

        uint256 _lastProcessedIndex = lastProcessedIndex;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;

        while (gasUsed < _gasLimit && iterations < numberOfTokenHolders) {
            iterations++;
            if (_lastProcessedIndex >= _lpHolder.length()) {
                _lastProcessedIndex = 0;
            }

            address account = _lpHolder.at(_lastProcessedIndex);
            if (account == _excludelpAddress || account == owner()) {
                continue;
            }
            uint256 _userPt;
            uint256 _userReward2;
            uint256 _userReward3;

            (_userPt, _userReward2, _userReward3) = getRewardValues(account);

            if (
                _userReward3 > _oskToken.balanceOf(address(this)) ||
                _userReward2 > _fistToken.balanceOf(address(this))
            ) {
                break;
            }
            if (_userReward3 > 0) {
                _oskToken.transfer(account, _userReward3);
            }
            if (_userReward2 > 0) {
                _fistToken.transfer(account, _userReward2);
                _lastProcessedIndex++;
            }else{
                _lpHolder.remove(account);
            }

            uint256 newGasLeft = gasleft();

            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            }
            gasLeft = newGasLeft;
            
        }

        lastProcessedIndex = _lastProcessedIndex;
    }

    function updateGasForProcessing(uint256 newValue) public onlyOwner {
        require(
            newValue >= 200000 && newValue <= 500000,
            " gasForProcessing must be between 200,000 and 500,000"
        );
        require(
            newValue != gasForProcessing,
            " Cannot update gasForProcessing to same value"
        );
        gasForProcessing = newValue;
    }


    function swapTokensFor2Tokens(
        address inToken,
        address outToken,
        address to,
        uint256 tokenAmount
    ) private {
        address[] memory path = new address[](2);
        path[0] = inToken;
        path[1] = outToken;

        ERC20(inToken).approve(address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            to,
            block.timestamp
        );
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}
}
