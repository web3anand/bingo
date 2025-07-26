import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';

// Entry point for the React application.  This file mounts the App
// component into the root DOM node defined in `index.html`.

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
