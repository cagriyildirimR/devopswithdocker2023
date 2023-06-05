const express = require('express')
const app = express()

app.get('/', (req, res) => {
  res.send('<h1>Hello World!</h1><br><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris quis justo ut mauris convallis ullamcorper sed a nisi. Sed id fermentum lorem. Maecenas vitae placerat neque. Ut viverra tincidunt mi, a lobortis odio tincidunt non.</p>')
})

const PORT = 8080

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})