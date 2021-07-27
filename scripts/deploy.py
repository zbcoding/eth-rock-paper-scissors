from brownie import Contract, config, accounts, network
from web3 import eth

def deployContract():
	account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
	
	return Contract.deploy( {'from': account})

def main():
	deployContract()

#brownie run deploy.py --network kovan