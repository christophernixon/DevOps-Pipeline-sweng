import React from "react";
import "./style.css";

class StartButton extends React.Component {
  render() {
    return (
      <table className="nav" align="center">
        <button className="button" onclick="myFunction();">
          Start Game
        </button>
      </table>
    );
  }
}
function myFunction() {
  console.log("Button pressed!");

}

export default StartButton;
