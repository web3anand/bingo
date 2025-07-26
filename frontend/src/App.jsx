import React, { useState } from 'react';
import {
  StarknetConfig,
  useAccount,
  useConnect,
} from '@starknet-react/core';

// A minimal Bingo front‑end using starknet‑react.  This file sets up the
// Starknet provider with support for Argent X and Braavos wallets and
// provides a placeholder UI that can be extended to implement the full
// Bingo experience (lobby, room creation/joining, and the Bingo board).

function BingoGame() {
  const { address, isConnected } = useAccount();
  const { connect } = useConnect();

  return (
    <div style={{ padding: '2rem', fontFamily: 'sans-serif' }}>
      <h1>Starknet Bingo</h1>
      {!isConnected ? (
        <button onClick={() => connect()}>Connect Wallet</button>
      ) : (
        <p>Connected as {address}</p>
      )}
      {/*
        TODO: implement lobby where users can register a username, create
        games, join games via invite code, and start playing.  Each of these
        actions will call the corresponding Cairo systems using the
        Paymaster-enabled transactions from the AVNU SDK.
      */}
      <p style={{ marginTop: '1rem' }}>Multiplayer Bingo is coming soon!</p>
    </div>
  );
}

export default function App() {
  return (
    <StarknetConfig
      autoConnect={true}
      connectorsOptions={{
        argentX: {},
        braavos: {},
      }}
    >
      <BingoGame />
    </StarknetConfig>
  );
}
