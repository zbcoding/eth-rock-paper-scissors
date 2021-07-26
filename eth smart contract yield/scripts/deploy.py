from brownie import Yield, config, accounts

def deployContract():
	account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
	#the Yield contract constructor only needs a total supply parameter
	return Yield.deploy( 1000e8, {'from': account})

def main():
	deployContract()

#brownie run deploy.py --network kovan