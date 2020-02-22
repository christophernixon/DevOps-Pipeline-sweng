
import React from "react";
import "./App.css";

function App() {

  return (
    <div className="App">
      <header className="App-header">
        <button className="Button" onClick={startGame}>
          Start Game!
        </button>
      </header>{" "}
    </div>
  );
}

function startGame(){
  console.log("Start game button pressed!")
}

export default App;
