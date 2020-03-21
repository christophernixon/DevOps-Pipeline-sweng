import React from 'react';
import './style.css';

class Popup extends React.Component {
  render() {
    return (
      <div className='popup'>
        <div className='popup\_inner'>
          <div>{this.props.text}</div>
          {this.props.submitA}
          {this.props.closePopup}
          {this.props.endGame}
        </div>
      </div>
    );
  }
}

export default Popup;