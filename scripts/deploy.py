from brownie import ERC20Basic, config, accounts, network
from web3 import eth

def deployContract():
	account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
	#the Yield contract constructor only needs a total supply parameter
	
	return ERC20Basic.deploy( 1000e8, {'from': account})

def main():
	deployContract()

#brownie run deploy.py --network kovan