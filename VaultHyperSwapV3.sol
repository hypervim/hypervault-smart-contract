// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the balance of tokens.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IUniswapV3Pool {
    function slot0() external view returns (uint160, int24, uint16, uint16, uint16, uint8, bool);
}

interface INonfungiblePositionManager
{
    /// @notice Emitted when liquidity is increased for a position NFT
    /// @dev Also emitted when a token is minted
    /// @param tokenId The ID of the token for which liquidity was increased
    /// @param liquidity The amount by which liquidity for the NFT position was increased
    /// @param amount0 The amount of token0 that was paid for the increase in liquidity
    /// @param amount1 The amount of token1 that was paid for the increase in liquidity
    event IncreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
    /// @notice Emitted when liquidity is decreased for a position NFT
    /// @param tokenId The ID of the token for which liquidity was decreased
    /// @param liquidity The amount by which liquidity for the NFT position was decreased
    /// @param amount0 The amount of token0 that was accounted for the decrease in liquidity
    /// @param amount1 The amount of token1 that was accounted for the decrease in liquidity
    event DecreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
    /// @notice Emitted when tokens are collected for a position NFT
    /// @dev The amounts reported may not be exactly equivalent to the amounts transferred, due to rounding behavior
    /// @param tokenId The ID of the token for which underlying tokens were collected
    /// @param recipient The address of the account that received the collected tokens
    /// @param amount0 The amount of token0 owed to the position that was collected
    /// @param amount1 The amount of token1 owed to the position that was collected
    event Collect(uint256 indexed tokenId, address recipient, uint256 amount0, uint256 amount1);

    /// @notice Returns the position information associated with a given token ID.
    /// @dev Throws if the token ID is not valid.
    /// @param tokenId The ID of the token that represents the position
    /// @return nonce The nonce for permits
    /// @return operator The address that is approved for spending
    /// @return token0 The address of the token0 for a specific pool
    /// @return token1 The address of the token1 for a specific pool
    /// @return fee The fee associated with the pool
    /// @return tickLower The lower end of the tick range for the position
    /// @return tickUpper The higher end of the tick range for the position
    /// @return liquidity The liquidity of the position
    /// @return feeGrowthInside0LastX128 The fee growth of token0 as of the last action on the individual position
    /// @return feeGrowthInside1LastX128 The fee growth of token1 as of the last action on the individual position
    /// @return tokensOwed0 The uncollected amount of token0 owed to the position as of the last computation
    /// @return tokensOwed1 The uncollected amount of token1 owed to the position as of the last computation
    function positions(uint256 tokenId)
        external
        view
        returns (
            uint96 nonce,
            address operator,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        );

    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }

    /// @notice Creates a new position wrapped in a NFT
    /// @dev Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
    /// a method does not exist, i.e. the pool is assumed to be initialized.
    /// @param params The params necessary to mint a position, encoded as `MintParams` in calldata
    /// @return tokenId The ID of the token that represents the minted position
    /// @return liquidity The amount of liquidity for this position
    /// @return amount0 The amount of token0
    /// @return amount1 The amount of token1
    function mint(MintParams calldata params)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    struct IncreaseLiquidityParams {
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    /// @notice Increases the amount of liquidity in a position, with tokens paid by the `msg.sender`
    /// @param params tokenId The ID of the token for which liquidity is being increased,
    /// amount0Desired The desired amount of token0 to be spent,
    /// amount1Desired The desired amount of token1 to be spent,
    /// amount0Min The minimum amount of token0 to spend, which serves as a slippage check,
    /// amount1Min The minimum amount of token1 to spend, which serves as a slippage check,
    /// deadline The time by which the transaction must be included to effect the change
    /// @return liquidity The new liquidity amount as a result of the increase
    /// @return amount0 The amount of token0 to acheive resulting liquidity
    /// @return amount1 The amount of token1 to acheive resulting liquidity
    function increaseLiquidity(IncreaseLiquidityParams calldata params)
        external
        payable
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    struct DecreaseLiquidityParams {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    /// @notice Decreases the amount of liquidity in a position and accounts it to the position
    /// @param params tokenId The ID of the token for which liquidity is being decreased,
    /// amount The amount by which liquidity will be decreased,
    /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
    /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
    /// deadline The time by which the transaction must be included to effect the change
    /// @return amount0 The amount of token0 accounted to the position's tokens owed
    /// @return amount1 The amount of token1 accounted to the position's tokens owed
    function decreaseLiquidity(DecreaseLiquidityParams calldata params)
        external
        payable
        returns (uint256 amount0, uint256 amount1);

    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
    /// @param params tokenId The ID of the NFT for which tokens are being collected,
    /// recipient The account that should receive the tokens,
    /// amount0Max The maximum amount of token0 to collect,
    /// amount1Max The maximum amount of token1 to collect
    /// @return amount0 The amount of fees collected in token0
    /// @return amount1 The amount of fees collected in token1
    function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);

    /// @notice Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
    /// must be collected first.
    /// @param tokenId The ID of the token that is being burned
    function burn(uint256 tokenId) external payable;

    /// @notice Creates a new pool if it does not exist, then initializes if not initialized
    /// @dev This method can be bundled with others via IMulticall for the first action (e.g. mint) performed against a pool
    /// @param token0 The contract address of token0 of the pool
    /// @param token1 The contract address of token1 of the pool
    /// @param fee The fee amount of the v3 pool for the specified token pair
    /// @param sqrtPriceX96 The initial square root price of the pool as a Q64.96 value
    /// @return pool Returns the pool address based on the pair of tokens and fee, will return the newly created pool address if necessary
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable returns (address pool);

    function WETH9() external view returns (address);
    function factory() external view returns (address);
}

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
    */

    function balanceOf(address owner) external view returns (uint256 balance);
    
    

    function royaltyFee(uint256 tokenId) external view returns(uint256);
    function getCreator(uint256 tokenId) external view returns(address);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */

    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */

    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}
interface IVault{
    function withdraw(address _token, uint256 _amount) external;
    function deposit(address _token, uint256 _amount) external;
}
interface IStaking{
    function vault(address) external view returns(address);
}

contract VaultHyperSwapV3 {
    INonfungiblePositionManager public positionManager;
    address public operator;
    address public stake;
    mapping(address => bool) public isVault;
    mapping (address => uint256) public allocateBalance;
    constructor() {
        positionManager = INonfungiblePositionManager(0x6eDA206207c09e5428F281761DdC0D300851fBC8); //hyperswapv3 position manager
        operator = msg.sender;
    }

    modifier onlyOperator() {
        require(operator == msg.sender, "VaultHyperSwapV3: caller is not the operator");
        _;
    }
    function setHV(address _stake) public onlyOperator{
        stake = _stake;
    }
    function setOperator(address _operator) external onlyOperator {
        require(_operator != address(0), "Invalid operator address");
        operator = _operator;
    }
    function updateAllocateBalance(address _token, uint256 _amount, address _srcVault, address _destVault) external onlyOperator {
        require(_amount > 0, "Amount must be greater than zero");
        IVault(_srcVault).withdraw(_token, _amount);
        IERC20(_token).approve(_destVault, _amount);
        IVault(_destVault).deposit(_token, _amount);
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper,
        uint256 amountA,
        uint256 amountB,
        uint256 amount0Min,
        uint256 amount1Min,
        uint256 deadline
    ) external onlyOperator returns (uint256 tokenId) {
        address _vaultA = IStaking(stake).vault(tokenA);
        address _vaultB = IStaking(stake).vault(tokenB);
        require(_vaultA != address(0) && _vaultB != address(0), "Vault not found");
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        if(_balanceA < amountA){
            allocateBalance[tokenA] += amountA;
            IVault(_vaultA).withdraw(tokenA, amountA - _balanceA);
        }
        if(_balanceB < amountB){
            allocateBalance[tokenB] += amountB;
            IVault(_vaultB).withdraw(tokenB, amountB - _balanceB);
        }
        IERC20(tokenA).approve(address(positionManager), amountA);
        IERC20(tokenB).approve(address(positionManager), amountB);
        
        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: tokenA,
            token1: tokenB,
            fee: fee,
            tickLower: tickLower,
            tickUpper: tickUpper,
            amount0Desired: amountA,
            amount1Desired: amountB,
            amount0Min: amount0Min,
            amount1Min: amount1Min,
            recipient: address(this),
            deadline: deadline
        });
        
        (tokenId,,,) = positionManager.mint(params);
    }

    function increaseLiquidity(
        uint256 tokenId,
        uint256 amountA,
        uint256 amountB,
        uint256 amount0Min,
        uint256 amount1Min,
        uint256 deadline
    ) external onlyOperator{
        (,, address tokenA, address tokenB,,,,,,,,) = positionManager.positions(tokenId);
        address _vaultA = IStaking(stake).vault(tokenA);
        address _vaultB = IStaking(stake).vault(tokenB);
        require(_vaultA != address(0) && _vaultB != address(0), "Vault not found");
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        if(_balanceA < amountA){
            allocateBalance[tokenA] += (amountA - _balanceA);
            IVault(_vaultA).withdraw(tokenA, amountA - _balanceA);
        }
        if(_balanceB < amountB){
            allocateBalance[tokenB] += (amountB - _balanceB);
            IVault(_vaultB).withdraw(tokenB, amountB - _balanceB);
        }
            
        IERC20(tokenA).approve(address(positionManager), amountA);
        IERC20(tokenB).approve(address(positionManager), amountB);
        
        positionManager.increaseLiquidity(INonfungiblePositionManager.IncreaseLiquidityParams({
            tokenId: tokenId,
            amount0Desired: amountA,
            amount1Desired: amountB,
            amount0Min: amount0Min,
            amount1Min: amount1Min,
            deadline: deadline
        }));
    }

    function _decreaseLiquidity(uint256 tokenId, uint128 liquidity, uint256 amount0Min, uint256 amount1Min, uint256 deadline) internal {
        positionManager.decreaseLiquidity(INonfungiblePositionManager.DecreaseLiquidityParams({
            tokenId: tokenId,
            liquidity: liquidity,
            amount0Min: amount0Min,
            amount1Min: amount1Min,
            deadline: deadline
        }));
    }

    function decreaseLiquidity(uint256 tokenId, uint128 liquidity, uint256 amount0Min, uint256 amount1Min, uint256 deadline) external onlyOperator {
        (,, address tokenA, address tokenB,,,,,,,,) = positionManager.positions(tokenId);
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        positionManager.decreaseLiquidity(INonfungiblePositionManager.DecreaseLiquidityParams({
            tokenId: tokenId,
            liquidity: liquidity,
            amount0Min: amount0Min,
            amount1Min: amount1Min,
            deadline: deadline
        }));
        positionManager.collect(INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        }));
        if(allocateBalance[tokenA] < (IERC20(tokenA).balanceOf(address(this)) - _balanceA)){
            allocateBalance[tokenA] = 0;
        }
        else{
            allocateBalance[tokenA] -= (IERC20(tokenA).balanceOf(address(this)) - _balanceA);
        }
        if(allocateBalance[tokenB] < (IERC20(tokenB).balanceOf(address(this)) - _balanceB)){
            allocateBalance[tokenB] = 0;
        }
        else{
            allocateBalance[tokenB] -= (IERC20(tokenB).balanceOf(address(this)) - _balanceB);
        }
        depositToVaults(tokenA, tokenB);
    }

    function removeLiquidity(uint256 tokenId, uint256 amount0Min, uint256 amount1Min, uint256 deadline) external onlyOperator{
        (,,address tokenA, address tokenB,,,,uint128 liquidity,,,,) = positionManager.positions(tokenId);
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        _decreaseLiquidity(tokenId, liquidity, amount0Min, amount1Min, deadline);
        positionManager.collect(INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        }));
        positionManager.burn(tokenId);
        if(allocateBalance[tokenA] < (IERC20(tokenA).balanceOf(address(this)) - _balanceA)){
            allocateBalance[tokenA] = 0;
        }
        else{
            allocateBalance[tokenA] -= (IERC20(tokenA).balanceOf(address(this)) - _balanceA);
        }
        if(allocateBalance[tokenB] < (IERC20(tokenB).balanceOf(address(this)) - _balanceB)){
            allocateBalance[tokenB] = 0;
        }
        else{
            allocateBalance[tokenB] -= (IERC20(tokenB).balanceOf(address(this)) - _balanceB);
        }
        depositToVaults(tokenA, tokenB);
    }

    function collectFees(uint256 tokenId) external onlyOperator{
        positionManager.collect(INonfungiblePositionManager.CollectParams({
            tokenId: tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        }));
        (,, address tokenA, address tokenB,,,,,,,,) = positionManager.positions(tokenId);
        depositToVaults(tokenA, tokenB);
    }
    function depositToVaults(address tokenA, address tokenB) internal {
        address _vaultA = IStaking(stake).vault(tokenA);
        address _vaultB = IStaking(stake).vault(tokenB);
        require(_vaultA != address(0) && _vaultB != address(0), "Vault not found");
        uint256 _balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 _balanceB = IERC20(tokenB).balanceOf(address(this));
        if(_balanceA > 0){
            IERC20(tokenA).approve(_vaultA, _balanceA);
            IVault(_vaultA).deposit(tokenA, _balanceA);
        }
        if(_balanceB > 0){
            IERC20(tokenB).approve(_vaultB, _balanceB);
            IVault(_vaultB).deposit(tokenB, _balanceB);
        }
    }
    function getBalance(address _token) external view returns(uint256) {
        return allocateBalance[_token];
    }
    function getOtherProtocolBalance(address _token) external view returns(uint256){
        return allocateBalance[_token];
    }

    /**
     * @dev Calculate minimum amounts with slippage tolerance
     * @param amount0Desired The desired amount of token0
     * @param amount1Desired The desired amount of token1
     * @param slippageBps Slippage tolerance in basis points (e.g., 100 = 1%)
     * @return amount0Min Minimum amount of token0 with slippage applied
     * @return amount1Min Minimum amount of token1 with slippage applied
     */
    function calculateMinAmounts(
        uint256 amount0Desired,
        uint256 amount1Desired,
        uint256 slippageBps
    ) external pure returns (uint256 amount0Min, uint256 amount1Min) {
        require(slippageBps <= 10000, "Slippage too high"); // Max 100% slippage
        amount0Min = (amount0Desired * (10000 - slippageBps)) / 10000;
        amount1Min = (amount1Desired * (10000 - slippageBps)) / 10000;
    }

    /**
     * @dev Calculate a reasonable deadline (current time + buffer)
     * @param bufferSeconds Number of seconds to add to current time
     * @return deadline The calculated deadline timestamp
     */
    function calculateDeadline(uint256 bufferSeconds) external view returns (uint256 deadline) {
        require(bufferSeconds <= 3600, "Buffer too long"); // Max 1 hour
        deadline = block.timestamp + bufferSeconds;
    }
}