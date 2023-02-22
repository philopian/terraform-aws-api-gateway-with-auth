import { useState } from 'react'

import './App.css'

const URL = 'https://6v72fsx15e.execute-api.us-west-2.amazonaws.com/v1/api'
const mockBearerToken = 'Bearer 123456789'

function App() {
  const [data, setData] = useState({})

  const handleClick = () => {
    fetch(URL, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': mockBearerToken,
      },
    })
      .then((response) => {
        if (response.ok) {
          return response.text()
        }
        throw new Error(`Request failed with status ${response.status}`)
      })
      .then((data) => {
        console.log(data)
        setData(data)
      })
      .catch((error) => {
        console.error(error)
      })
  }

  return (
    <div className="App">
      <button onClick={handleClick}>Get Data</button>

      <h1>Data</h1>
      <pre>{JSON.stringify(data, null, 1)}</pre>
    </div>
  )
}

export default App
