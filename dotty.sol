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

contract MyToken is ERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private _lpHolder;
    bool public swapEnabled = true;
    bool public tsDividendEnabled = true;

    uint256 public _burnStopAt;
    uint256 public _swapAt;
    uint256 public _lpFeeRate;
    uint256 public _lp2FeeRate;
    uint256 public _burnFeeRate;
    uint256 public _holderFeeRate;
    uint256 public _backFeeRate;
    uint256 public _marketFeeRate;
    uint256 public _feeRate;
    uint256 public _lpDividendFirst;
    uint256 public _lpDividendSecond;

    uint256 public _rewardBaseLPFirst;
    uint256 public _rewardBaseLPSecond;
    uint256 public _rewardBaseHolder;

    uint256 public _holderRewardAt;

    address public uniswapV2Pair;
    address public _marketingWalletAddress;
    address public _excludelpAddress;
    uint256 gasForProcessing;
    address public deadWallet = 0x000000000000000000000000000000000000dEaD;
    bool private swapping;

    IUniswapV2Router02 public uniswapV2Router;
    mapping(address => bool) public _isBlacklisted;
    mapping(address => bool) public automatedMarketMakerPairs;

    IERC20 private _dot;
    IERC20 private _shib;

    uint256 public tradingEnabledTimestamp = 1628258400; //2021-08-06 22:00:00的时间戳

    constructor() ERC20("dotty token", "dotty*") {
        _mint(msg.sender, 22222 * 10**decimals());
        _burnStopAt = 2222 * 10**decimals();
        _lpFeeRate = 400;
        _lp2FeeRate = 100;
        _burnFeeRate = 50;
        _holderFeeRate = 100;
        
        _backFeeRate = 50;
        _marketFeeRate = 100;

        gasForProcessing = 3 * 10**4;
        _marketingWalletAddress = 0x0;

        _lpDividendFirst = 110;
        _lpDividendSecond = 500;
        

        _feeRate = _lpFeeRate +_lp2FeeRate + _holderFeeRate + _backFeeRate + _marketFeeRate;

        uniswapV2Router = IUniswapV2Router02(
            0xD99D1c33F9fC3444f8101754aBC46c52416550D1
        );
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                uniswapV2Router.WETH()
            );
        _dot = IERC20();
        _shib = IERC20();

        _swapAt = 5 * 10**decimals();
        _holderRewardAt = 5*10**decimals();
        _excludelpAddress = owner();

        _rewardBaseLPFirst = 2 * 10**18;

       _rewardBaseLPSecond = 1 * 10**18;
       _rewardBaseHolder = 1* 10**7 * 10**18;

    }

    function setTsDividendEnabled(bool true) public onlyOwner{
        tsDividendEnabled = tsDividendEnabled;
    }

    function setFeeRate(uint256 lpFeeRate,uint256 lp2FeeRate,uint256 burnFeeRate,uint256 holderFeeRate,uint256 backFeeRate,uint256 marketFeeRate){
        _lpFeeRate = lpFeeRate;
        _lp2FeeRate = lp2FeeRate;
        _burnFeeRate = burnFeeRate;
        _holderFeeRate = holderFeeRate;
        _backFeeRate = backFeeRate;
        _marketFeeRate = marketFeeRate;
    }

    function setRewardToken(address _dot,address _shib) external onlyOwner {
        _dot = IERC20(_dot);
        _shib = IERC20(_shib);
    }

    function setRewardBase(uint256 rewardBaseLPFirst,uint256 rewardBaseLPSecond,uint256 rewardBaseHolder) external onlyOwner {
        _rewardBaseLPFirst = rewardBaseLPFirst;
        _rewardBaseLPSecond = rewardBaseLPSecond;
        _rewardBaseHolder = rewardBaseHolder;
    }


    function setSwapEnabled(bool _enabled) external onlyOwner {
        swapEnabled = _enabled;
    }

    function setSwapEnabled(bool _enabled) external onlyOwner {
        swapEnabled = _enabled;
    }

    function addBot(address recipient) private {
        if (!_isBlacklisted[recipient]) _isBlacklisted[recipient] = true;
    }

    function getTradingIsEnabled() public view returns (bool) {
        return block.timestamp >= tradingEnabledTimestamp;
    }

    function _getValues(uint256 tAmount)
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 _fee = tAmount.mul(_feeRate).div(10**4);
        uint256 _burn = tAmount.sub(_fee);
        tAmount = tAmount.sub(_fee).sub(_burn);

        return (tAmount, _fee, _burn);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(!_isBlacklisted[from], "Blacklisted address");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (swapping) {
            super._transfer(from, to, amount);
            return;
        }

        bool tradingIsEnabled = getTradingIsEnabled();

        if (
            tradingIsEnabled && //到达开盘时间
            balanceOf(uniswapV2Pair) > 0 && //流动池大于0
            automatedMarketMakerPairs[from] && //li流动性可用
            !owner() && //是否排除手续费
            tradingIsEnabled &&
            block.timestamp <= tradingEnabledTimestamp + 9 seconds
        ) {
            //当前块的时间戳小于等于 可交易时间戳+9秒。如果是在9秒内抢到
            addBot(to); //则添加黑名单
        }

        if (
            tsDividendEnabledtsDividendEnabled //TODO:
            swapEnabled &&
            !swapping &&
            balanceOf(address(this)) >= _swapAt &&
            !automatedMarketMakerPairs[from] &&
            from != owner() &&
            to != owner()
        ) {
            swapping = true;
            uint256 dotSwapRate = _lpFeeRate  + _marketFeeRate;
            uint256 totalRate = _feeRate;
             if (totalSupply() <= _burnStopAt){
                 dotSwapRate = dotSwapRate + _burnFeeRate;
                 totalRate  = totalRate + _burnFeeRate;
             }
            uint256 _dotAmount = _swapAt.mul(dotSwapRate).dlv(totalRate);
            swapTokensFor3Tokens(_dotAmount,address(_dot));
            uint256 _bnbAmount = _swapAt.mul(_lp2FeeRate).dlv(totalRate);

            swapTokensFor2Tokens(_bnbAmount,uniswapV2Router.WETH());

            uint256 _shibAmount = _swapAt.mul(_holderFeeRate).dlv(totalRate);
            swapTokensFor3Tokens(_dotAmount,address(_shib));


            swapping = false;
        }

        if (!swapping && from != owner() && to != owner() && (to == uniswapV2Pair || from == uniswapV2Pair)) {
            uint256 fees = amount.mul(_feeRate).div(10**4);

            uint256 burnFee = amount.mul(_burnFeeRate).div(10**4);
            if (totalSupply() > _burnStopAt) {
                super._burn(from, burnFee);
                amount = amount.sub(burnFee);
            } else {
                fees = fees.add(burnFee);
            }
            amount = amount.sub(fees);
            super._transfer(from, address(this), fees);

            if (!_lpHolder.contains(to)){
                 _lpHolder.add(to);
            }
            if (!_lpHolder.contains(from)){
                 _lpHolder.add(to);
            }
        }

        super._transfer(from, to, amount);

        if (!swapping) {

            // try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
            //     emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
            // }
            // catch {
            // }
        }
    }


   function dividend() public {
        uint256 _gasLimit = gasForProcessing;

        uint256 numberOfTokenHolders = _lpHolder.length();
        if (
            numberOfTokenHolders == 0
        ) {
            return;
        }

        uint256 _lastProcessedIndex = lastProcessedIndex;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;

        uint256 excludeTotal = IERC20(uniswapV2Pair).balanceOf(
            _excludelpAddress
        );
        uint256 totalSupply = IERC20(uniswapV2Pair).totalSupply().sub(
            excludeTotal
        );

        while (gasUsed < _gasLimit && iterations < numberOfTokenHolders) {
            iterations++;
            if (_lastProcessedIndex >= _lpHolder.length()) {
                _lastProcessedIndex = 0;
            }

            address account = _lpHolder.at(_lastProcessedIndex);
            address accountBal = balanceOf(account);

            uint256 _userReward1;
            uint256 _userReward2;
            uint256 _userReward3;

            if (balanceOf(account) > _holderRewardAt){
                   _userReward1 =  _rewardBaseHolder.mul(balanceOf(account)).dlv(totalSupply());
            }

            if (_userReward1 > _dot.balanceOf(address(this))){

            }

            if (balanceOf(account) > _holderRewardAt){
                   _userReward2 =  _rewardBaseHolder.mul(balanceOf(account)).dlv(totalSupply());
            }


            uint256 accountLPBal = IERC20(uniswapV2Pair).balanceOf(account);

            if (accountLPBal.div(totalSupply).mul(10**4) > _lpDividendFirst){

            }
            uint256 _userReward1 = _shib.balanceOf(address(this))



            uint256 _accountBal = IERC20(uniswapV2Pair).balanceOf(account);
            if (_accountBal == 0) {
                _lpHolder.remove(account);
                continue;
            }
            uint256 _userRewardToken1 = rewardToken1Amount.mul(_accountBal).div(
                total
            );
            uint256 _userRewardToken2 = rewardToken2Amount.mul(_accountBal).div(
                total
            );

            if (
                address(this).balance < _userRewardToken1 ||
                rewardToken2.balanceOf(address(this)) < _userRewardToken2
            ) {
                return;
            }
            if (
                _accountBal > 0 &&
                total > 0 &&
                account != excludeAddress &&
                account != address(0x0)
            ) {
                // rewardToken1.transfer(account, _userRewardToken1);
                payable(account).transfer(_userRewardToken1);
                rewardToken2.transfer(account, _userRewardToken2);
            }
            uint256 newGasLeft = gasleft();

            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            }
          
            gasLeft = newGasLeft;
            _lastProcessedIndex++;
        }

        lastProcessedIndex = _lastProcessedIndex;
    }

    function _holder(address from, address to) internal {
        uint256 excludeTotal = IERC20(uniswapV2Pair).balanceOf(
            _excludelpAddress
        );
        uint256 totalSupply = IERC20(uniswapV2Pair).totalSupply().sub(
            excludeTotal
        );
        uint256 fromLPBal = IERC20(uniswapV2Pair).balanceOf(from);
        uint256 toLPBal = IERC20(uniswapV2Pair).balanceOf(to);

        if (
            fromLPBal > 0 &&
            !_lpHolder.contains(from) &&
            (fromLPBal.dlv(totalSupply).mul(10**4) > _lpDividendFirst)
        ) {
            _lpHolder.add(from);
        } else if (_lpHolder.contains(from)) {
            _lpHolder.remove(from);
        }

        if (
            toLPBal > 0 &&
            !_lpHolder.contains(to) &&
            (toLPBal.dlv(totalSupply).mul(10**4) > _lpDividendFirst)
        ) {
            _lpHolder.add(to);
        } else if (_lpHolder.contains(to)) {
            _lpHolder.remove(to);
        }
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(
            automatedMarketMakerPairs[pair] != value,
            "RedCheCoin Automated market maker pair is already set to that value"
        );
        automatedMarketMakerPairs[pair] = value;
    }

    function updateGasForProcessing(uint256 newValue) public onlyOwner {
        require(
            newValue >= 200000 && newValue <= 500000,
            "RedCheCoin gasForProcessing must be between 200,000 and 500,000"
        );
        require(
            newValue != gasForProcessing,
            "RedCheCoin Cannot update gasForProcessing to same value"
        );
        gasForProcessing = newValue;
    }

    //发送给营销钱包手续费用
    function swapAndSendToFee(uint256 tokens) private {
        uint256 initialBNBBalance = address(this).balance;
        swapTokensForEth(tokens);
        uint256 newBalance = address(this).balance.sub(initialBNBBalance);
        payable(_marketingWalletAddress).transfer(newBalance);
    }

    //交易流动性
    function swapAndLiquify(uint256 tokens) private {
        // split the contract balance into halves 把该合同余额平分，分成一半
        uint256 half = tokens.div(2);
        uint256 otherHalf = tokens.sub(half);

        // capture the contract's current ETH balance.   获取合同当前ETH余额。
        // this is so that we can capture exactly the amount of ETH that the   这样我们就能准确地捕获ETH的数量
        // swap creates, and not make the liquidity event include any ETH that    交换产生，而不使流动性事件包括任何ETH
        // has been manually sent to the contract    手动发送给合约地址
        uint256 initialBalance = address(this).balance;

        // swap tokens for ETH  ETH交换代币
        swapTokensForEth(half);
        // <- this breaks the ETH -> HATE swap when swap+liquify is triggered  当swap+liquify被触发时，这会打破ETH ->HATE swap

        // how much ETH did we just swap into?   我们刚才换了多少ETH ?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to uniswap      为uniswap增加流动性
        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    //交换代币
    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth  生成unswap pair周边合约代币路径 -> 用eth位来表示
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    //添加流动性
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios      批准代币转账以覆盖所有可能的场景
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity           添加流动性
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable     //滑点是不可避免的
            0, // slippage is unavoidable   //滑点是不可避免的
            liquidityWallet, //流动性钱包;
            block.timestamp //当块的时间戳
        );
    }

    function swapTokensFor3Tokens(uint256 tokenAmount, address outToken)
        public
    {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = outToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
        function swapTokensFor2Tokens(uint256 tokenAmount, address outToken)
        public
    {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = outToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

        //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}
}
