import React from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import NewStore from './NewStore';
import StoreFront from './StoreFront';
import Error from './Error';

function App() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/new-store/:appId" component={ NewStore } />
        <Route path="/view/:appId" component={ StoreFront } />
        <Route component={ Error } />
      </Switch>
    </BrowserRouter>
  
  );
}

export default App;
