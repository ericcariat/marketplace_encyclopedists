#!/usr/bin/env bash
SECONDS=0
npx hardhat clean
npx hardhat compile
npx hardhat run --network goerli scripts/01_deploy.js
npx hardhat run --network goerli scripts/02_deploy.js
duration=$SECONDS
echo "Deployment time = $SECONDS seconds"
