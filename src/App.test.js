import React from 'react';
import { render } from '@testing-library/react';
import App from './App';
import ReactDOM from 'react-dom'

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