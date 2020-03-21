import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import App from './App';
import ReactDOM from 'react-dom'
import distanceCalculator from './distance'
import Popup from './components/Popup';

test('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
  ReactDOM.unmountComponentAtNode(div);
 
});


it('renders button correctly', () => {
  const {getByTestId} = render(<button data-testid= 'button'>Start game</button>)
  expect(getByTestId('button').textContent).toBe("Start game")
})

it('renders button correctly', () => {
  const {getByTestId} = render(<button data-testid= 'button'>Next Question</button>)
  expect(getByTestId('button').textContent).toBe("Next Question")
})

it('distance funtion returns correct value', () => {
  
  const distanceAnswer = 1433
  const dist = distanceCalculator(41.890220642089844, 12.492316246032715, 51.50807571411133, -0.09714961051940918)
  expect(Math.floor(dist)).toBe(distanceAnswer)
})

