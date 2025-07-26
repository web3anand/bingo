import React from 'react';
import { useAccount, useConnect } from '@starknet-react/core';

// A minimal Bingo front‑end using starknet‑react.  This file sets up the
// Starknet provider with support for Argent X and Braavos wallets and
// provides a placeholder UI that can be extended to implement the full
// Bingo experience (lobby, room creation/joining, and the Bingo board).

export default function App() {
  const { address, isConnected } = useAccount();
  const { connect, connectors } = useConnect();
  const hasConnectors = Array.isArray(connectors) && connectors.length > 0;
  const firstConnector = hasConnectors ? connectors[0] : undefined;

  const handleConnect = () => {
    if (firstConnector) {
      connect({ connector: firstConnector });
    }
  };

  return (
    <div style={{ padding: '2rem' }}>
      <h1>Bingo Dapp ✅</h1>
      {!isConnected ? (
        hasConnectors ? (
          <button onClick={handleConnect}>Connect Wallet</button>
        ) : (
          <p>Loading wallet connectors…</p>
        )
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
