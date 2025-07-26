import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import { StarknetConfig, InjectedConnector } from '@starknet-react/core';

// Entry point for the React application. This mounts the App component and
// provides Starknet wallet connectivity.
const connectors = [
  new InjectedConnector({ options: { id: 'argentX' } }),
  new InjectedConnector({ options: { id: 'braavos' } }),
];

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <StarknetConfig autoConnect connectors={connectors}>
      <App />
    </StarknetConfig>
  </React.StrictMode>
);
