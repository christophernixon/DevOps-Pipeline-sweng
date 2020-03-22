import React, { Component } from "react";
import ReactMapGL, { Marker } from "react-map-gl";
import green_marker from "./images/green_marker.png";
import "./App.css";
import "./map.jsx";
import StartButton from "./components/StartButton.js";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      viewport: {
        latitude: 37.8,
        longitude: -122.4,
        zoom: 1,
        width: "100vw",
        height: "100vh",
        bearing: 0,
        pitch: 0
      },
      marker: {
        latitude: 37.8,
        longitude: -122.4
      }
    };
  }

  _onMarkerDragEnd = event => {
    this.setState({
      marker: {
        latitude: event.lngLat[1],
        longitude: event.lngLat[0]
      }
    });
  };

  render() {
    const marker_style = {
      backgroundRepeat: "no-repeat",
      width: 25,
      height: 35
    };
    const { viewport, marker } = this.state;
    return (
      <div>
        <StartButton />

        <ReactMapGL
          {...viewport}
          mapStyle="mapbox://styles/mapbox/streets-v9"
          mapboxApiAccessToken={process.env.REACT_APP_MAPBOX_TOKEN}
          onViewportChange={viewport => this.setState({ viewport })}
        >
          <Marker
            latitude={marker.latitude}
            longitude={marker.longitude}
            draggable={true}
            onDragEnd={this._onMarkerDragEnd}
          >
            <img
              src={green_marker}
              style={marker_style}
              alt="green_marker"
            ></img>
          </Marker>
        </ReactMapGL>
      </div>
    );
  }
}
// eslint-disable-next-line
function startGame() {
  console.log("Start game button pressed!");
}

export default App;
