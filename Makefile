-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

all: clean remove install update build

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.3 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.3.0 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

zkbuild :; forge build --zksync

test :; forge test

zktest :; foundryup-zksync && forge test --zksync && foundryup

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

zk-anvil :; npx zksync-cli dev start

deploy-anvil:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(LOCAL_RPC_URL) --account $(LOCAL_ACCOUNT) --sender $(LOCAL_SENDER) --broadcast -vvvv

deploy-sepolia: 
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account $(SEP_ACCOUNT) --sender $(SEP_SENDER) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
