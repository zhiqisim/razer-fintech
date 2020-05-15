import React from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import NewStore from './NewStore';
import StoreFront from './StoreFront';
import Error from './Error';

function App() {
  return (
    <div>
      <BrowserRouter>
        <Switch>
          <Route path="/new-store" component={ NewStore } />
          <Route path="/:appName" component={ StoreFront } />
          <Route component={ Error } />
        </Switch>
      </BrowserRouter>
    </div>
  );
}

export default App;
