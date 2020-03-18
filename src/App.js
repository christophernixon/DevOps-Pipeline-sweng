import React, { Component } from "react";
import ReactMapGL, { Marker } from "react-map-gl";
import green_marker from "./images/green_marker.png";
import "./App.css";
import "./map.jsx";
//import StartButton from "./components/StartButton.js";
import Popup from './components/Popup';
//import questions from './data/questions.txt';
import data from './data/questionsList.json'
//import geo from './data/data.geojson'


class App extends Component {

  constructor(props) {
    const random = Math.floor(Math.random() * data.length)
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
      },

      showPopup: false,
      score: 0,
      question: {
        text: data[random].question,
        lat: data[random].lat,
        lon: data[random].lon
      }
    };
  }

  togglePopup() {
    this.setState({
      showPopup: !this.state.showPopup
    });
  }

  randomQuestion() {
    const random = Math.floor(Math.random() * data.length)
    this.setState({
      question:{
        text: data[random].question,
        lat: data[random].lat,
        lon: data[random].lon
      }
    })
  }

  submitAnswer() {
    let lon = this.state.marker.longitude
    let lat = this.state.marker.latitude
    let latA = this.state.question.lat
    let lonA = this.state.question.lon
    const dist = distance(lat, lon, latA, lonA)
   let score = 5000-dist
    if(score<0){
      score =0
    }

    this.setState({
      score: this.state.score + Math.floor(score)
    })
  }

  _onMarkerDragEnd = event => {
    this.setState({
      marker: {
        latitude: event.lngLat[1],
        longitude: event.lngLat[0]
      }
    });
  }


  render() {
    const marker_style = {
      backgroundRepeat: "no-repeat",
      width: 25,
      height: 35
    };

    const { viewport, marker } = this.state;
   

    return (
      <div>
        <button data-testid='button' className='button' onClick={this.togglePopup.bind(this)}>Start game </button>
       <p>{this.state.score}</p>
    <p>{this.state.question.lat}</p>
    <p>{this.state.question.lon}</p>

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
          {this.state.showPopup ?
            <Popup
              nextQ={this.randomQuestion.bind(this)}
              submitA={this.submitAnswer.bind(this)}
              text={this.state.question.text}
              closePopup={this.togglePopup.bind(this)}
              coords={this.state.marker.latitude + ' ' + this.state.marker.longitude}
            />
            : null
          }
        </ReactMapGL>
      </div>
    );
  }
}
// eslint-disable-next-line
function startGame() {
  console.log("Start game button pressed!");
}

// eslint-disable-next-line
function distance(lat1, lon1, lat2, lon2) {
  if ((lat1 === lat2) && (lon1 === lon2)) {
    return 0;
  }
  else {
    var radlat1 = Math.PI * lat1 / 180;
    var radlat2 = Math.PI * lat2 / 180;
    var theta = lon1 - lon2;
    var radtheta = Math.PI * theta / 180;
    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    if (dist > 1) {
      dist = 1;
    }
    dist = Math.acos(dist);
    dist = dist * 180 / Math.PI;
    dist = dist * 60 * 1.1515 * 1.609344;

    return dist;
  }
}

export default App;
