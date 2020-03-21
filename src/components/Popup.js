import React from 'react';
import './style.css';

class Popup extends React.Component {
  render() {
    return (
      <div className='popup'>
        <div className='popup\_inner'>
          <div>{this.props.text}</div>
          <button className='button' onClick={() => {
            this.props.nextQ();
            this.props.submitA();
          }}>Submit Answer</button>
          <button className='button' onClick={this.props.closePopup}>Close</button>
        </div>
      </div>
    );
  }
}

export default Popup;
