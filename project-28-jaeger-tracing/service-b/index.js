const express = require('express');
const app = express();

app.get('/process', async (req, res) => {
  await new Promise(resolve => setTimeout(resolve, 200));
  res.send('Processed by Service B');
});

app.listen(5000, () => {
  console.log('Service B running on port 5000');
});
