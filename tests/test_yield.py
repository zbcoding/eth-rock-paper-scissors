import time
from brownie.network.account import LocalAccount
import pytest
from brownie import ERC20Basic, network
from scripts.getAccount import get_account

LOCAL_BLOCKCHAIN_ENVIRONMENTS =\
[
    "mainnet-fork",
    "binance-fork",
    "matic-fork",
    "development",
    "ganache",
		"hardhat",
]

@pytest.fixture

def deploy_erc20():
	#Arrange
	#Act
	erc20 = ERC20Basic.deploy(1000,{"from": get_account()})
	#Assert
	assert erc20 is not None
	return erc20
#can decorate like @pytest.mark.require_network("mainnet-fork") to use certain network
def test_erc20_totalSupply(deploy_erc20):
	#Arrange
	if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
		pytest.skip("Only for local testing or network not found, skipping...")
	erc20 = deploy_erc20
	#Act/Assert
	assert erc20.totalSupply() > 0
def test_erc20_transfer(deploy_erc20):
	#Arrange
	if network.show_active not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
		pytest.skip("Only for local testing, or network not found, skipping...")
	erc20 = deploy_erc20
	tokensToTransfer = 10
	receiverAddress = '0x0000000000000000000000000000000000000000'
	senderOldTokenBalance = erc20.balanceOf(get_account())
	#Act
	transaction_receipt = \
		erc20.transfer(receiverAddress,\
		tokensToTransfer,\
		{"from": get_account()})
	newTokenBalance = erc20.balanceOf(get_account())
	#Assert
	assert newTokenBalance < senderOldTokenBalance
def test_burnOneToken_function(deploy_erc20):
	#Arrange
	if network.show_active not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
		pytest.skip("Only for local testing, or network not found, skipping...")
	erc20 = deploy_erc20
	senderOldTokenBalance = erc20.balanceOf(get_account())
	#Act
	transaction_receipt = \
		erc20.burnOneToken()
	newTokenBalance = erc20.balanceOf(get_account())
	#Assert
	assert newTokenBalance == senderOldTokenBalance - 1e8
