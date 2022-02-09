pragma solidity ^ 0.8.0;

import "./crowdsale.sol";

contract ICO is Crowdsale {
    
    uint public currentIcoPhase =1;
    uint private preSaleTokens=3*10**16;
    uint private seedSaleTokens =5*10**16;
    uint private finalSaleTokens=2*10**16;
    uint public soldTokens;

    constructor(address payable wallet, IERC20 token)  Crowdsale(wallet,token) public {}

    function _getTokenAmount(uint256 weiAmount) virtual internal override view returns (uint256) {
        return weiAmount*tokenPrice()/denominator();
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) virtual override internal {
        uint tokens = soldTokens + tokenAmount;
        require(
                    currentIcoPhase ==1 && tokens <= preSaleTokens ||
                    currentIcoPhase ==2 && tokens <= seedSaleTokens + preSaleTokens ||
                    currentIcoPhase ==3 && tokens <= finalSaleTokens + seedSaleTokens + preSaleTokens
                );
        _deliverTokens(beneficiary, tokenAmount);
        soldTokens += tokenAmount;
        if(tokensRemainsToBeSold() ==0   && currentIcoPhase < 3){
            changePhase();
        }
    }

    function tokensRemainsToBeSold() public view returns(uint) 
    {
        if(currentIcoPhase==1){
            return preSaleTokens - soldTokens;
        }
        else if(currentIcoPhase==2){
            return preSaleTokens + seedSaleTokens - soldTokens;
        } 
        else if(currentIcoPhase ==3){
            return 10* 10**6 *10**9 - soldTokens;
        }
    }

    function changePhase() internal{
        currentIcoPhase ++;
    }

    function tokenPrice() internal view returns(uint) {
        if(currentIcoPhase == 1) {
            return 3;
        }
        else if(currentIcoPhase == 2) {
            return 3;
        }
        else if(currentIcoPhase ==3) {
            return 9;
        }
    }

    function denominator() internal view returns(uint){
         if(currentIcoPhase == 1) {
            return 10**4;
        }
        else if(currentIcoPhase == 2) {
            return  2*10**4;
        }
        else if(currentIcoPhase ==3) {
            return 10**4;
        }
    }

}
