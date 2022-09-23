import React from 'react'
import { useContext } from 'react'
import { DarkModeContext } from './context/DarkModeContext'
​
const Lightswitch = () => {
    const { darkMode, toggleDarkMode } = useContext(DarkModeContext);
    const handleClick = () => {
        toggleDarkMode();
    }
    return (
        <div>
            <img onClick={handleClick} src={darkMode ? `../images/on.jpg` : `../images/off.jpg`} style={{ width: '200px', height: '140px' }} />
        </div>
    )
}
​
export default Lightswitch
