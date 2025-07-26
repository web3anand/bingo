# Starknet Bingo

This repository contains a fully on-chain multiplayer Bingo game built on Starknet using Dojo for smart contracts and a React front-end powered by starknet-react and the AVNU paymaster SDK.

## Features
- Unique usernames stored on Starknet.
- Create or join rooms with up to five players via invite code.
- Bingo boards are assigned when a game starts; numbers are called by the host.
- All actions (joining a game, calling numbers, winning) are recorded on chain.
- Gas fees are sponsored through AVNU’s paymaster.

## Contracts
The smart contracts are written in Cairo and reside in the `src/` directory. Components include:
- `Player` – stores each player's address, hashed username, assigned board, marks and bingo progress.
- `Game` – tracks the host, list of players, current number and finished status.

Systems handle registration, game creation, joining games, starting games and calling numbers.

## Front-end
The `frontend/` folder contains a Vite-powered React app using `@starknet-react/core` and `@avnu/paymaster-sdk` to interact with the contracts. The UI includes wallet connection and placeholder components for the lobby and game. You can extend it to fully implement the Bingo game experience.

## Deployment
To compile and deploy the Cairo contracts, install Dojo and run:
```
sozo build
sozo migrate --world <world_address>
```

To run the front-end locally:
```
cd frontend
npm install
npm run dev
```

Please see the contract source files for more details.
