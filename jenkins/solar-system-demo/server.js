const express = require('express');
const app = express();
const port = 3000;

// Serve static frontend files
app.use(express.static('public'));

// Simple solar system data API
const solarSystem = [
  { name: 'Mercury', type: 'planet', distanceFromSun: '57.9 million km' },
  { name: 'Venus', type: 'planet', distanceFromSun: '108.2 million km' },
  { name: 'Earth', type: 'planet', distanceFromSun: '149.6 million km' },
  { name: 'Mars', type: 'planet', distanceFromSun: '227.9 million km' },
  { name: 'Jupiter', type: 'planet', distanceFromSun: '778.3 million km' },
  { name: 'Saturn', type: 'planet', distanceFromSun: '1.4 billion km' },
  { name: 'Uranus', type: 'planet', distanceFromSun: '2.9 billion km' },
  { name: 'Neptune', type: 'planet', distanceFromSun: '4.5 billion km' }
];

app.get('/api/planets', (req, res) => {
  res.json(solarSystem);
});

app.listen(port, () => {
  console.log(`Solar System demo app listening at http://localhost:${port}`);
});
