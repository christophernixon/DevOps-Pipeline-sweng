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
import distanceCalculator from './distance'


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
      gameOver: false,
      score: 0,
      counter: 0,
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

  endGame() {
    this.setState({
      gameOver: !this.state.gameOver
    })
  }

  restartGame() {
    this.randomQuestion()
    //this.endGame()
    this.setState({
      gameOver: false,
      counter: 0,
      //showPopup: !this.state.showPopup,
      score: 0
      
    })
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
    const dist = distanceCalculator(lat, lon, latA, lonA)
   let score = 5000-dist
    if(score<0){
      score =0
    }

    score = score/100;

    this.setState({
      score: this.state.score + Math.floor(score),
      counter: this.state.counter + 1
    })
    this.randomQuestion()
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
        <p className='scoreBoard'>Score: {this.state.score}</p>
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
          {this.state.showPopup && this.state.counter<5 && !this.state.gameOver?
            <Popup
              submitA={<button className='button' onClick={this.submitAnswer.bind(this)}>Submit Answer</button>}
              endGame={<button className='button' onClick={this.endGame.bind(this)}>End Game</button>}
              text={this.state.question.text}
              closePopup={<button className='button' onClick={this.togglePopup.bind(this)}>Close</button>}
              //coords={this.state.marker.latitude + ' ' + this.state.marker.longitude}
            />
            : null
          }

          {this.state.gameOver || this.state.counter>=5?
            <Popup 
              text={<div>{this.state.score > 50? `Well done, your score is: ${this.state.score}`
            : `Try harder next time, your score is: ${this.state.score}`}</div>}
              submitA={<button className='button' onClick={this.restartGame.bind(this)}>Restart Game</button>}
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


export default App;
