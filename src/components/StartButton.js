import React from "react";
import "./style.css";

class StartButton extends React.Component {
  render() {
    return (
      <table className="nav" align="center">
        <button data-testid='button' className="button" onClick={this.togglePopup.bind(this)}>
          {this.props.label}
        </button>
      </table>
    );
  }
}
function myFunction() {
  console.log("Button pressed!");

}

export default StartButton;
