import React from 'react'
import StartButton from './StartButton'
import ReactDOM from 'react-dom'
import { render } from '@testing-library/react'
//import "@testing-library/jest-dom/extend-expect"

test('renders without crashing', () => {
    const div = document.createElement('div');
    ReactDOM.render(<StartButton></StartButton>, div)

});


it('renders button correctly', () => {
    const {getByTestId} = render(<StartButton label='Start game'></StartButton>)
    expect(getByTestId('button').textContent).toBe("Start game")
})