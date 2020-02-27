// eslint-disable-next-line
import logo from './logo.svg';
import React, { useState } from 'react';
import ReactMapGL from 'react-map-gl';
import './App.css';
import './map.jsx';

function App() {
  const [viewport, setViewport] = useState({
    width: "100vw",
    height: "100vh",
    latitude: 37.7577,
    longitude: -122.4376,
    zoom: 10
  });

  console.log(process.env.REACT_APP_MAPBOX_TOKEN)



  return (
    <ReactMapGL
      {...viewport}
      mapboxApiAccessToken = {process.env.REACT_APP_MAPBOX_TOKEN}
      onViewportChange={setViewport}
    />

  );
}
// eslint-disable-next-line
function startGame(){
  console.log("Start game button pressed!")
}

export default App;
