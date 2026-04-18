require('./tracing'); // MUST be first

const express = require('express');
const app = express();

const axios = require('axios'); // ✅ ADD THIS LINE

const { trace } = require('@opentelemetry/api');
const tracer = trace.getTracer('payment-service');

// Normal route
app.get('/', (req, res) => {
  res.send('Hello from Service A');
});

// Slow route with custom span
app.get('/slow', async (req, res) => {
  tracer.startActiveSpan('payment-process', async (span) => {

    await new Promise(resolve => setTimeout(resolve, 300));

    await axios.get('http://localhost:5000/process');

    await new Promise(resolve => setTimeout(resolve, 200));

    span.end();
    res.send('Processed via Service B');
  });
});

app.listen(4000, () => {
  console.log('Service running on port 4000');
});
