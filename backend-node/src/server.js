const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config();

const pool = require('./db/pool');
const productsRouter = require('./routes/products');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(morgan('combined'));
app.use(express.json());

// Health check - checks DB connectivity too, used by k8s probes later
app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).json({ status: 'UP', db: 'connected', timestamp: new Date().toISOString() });
  } catch (err) {
    res.status(503).json({ status: 'DOWN', db: 'disconnected', error: err.message });
  }
});

app.use('/api/products', productsRouter);

app.listen(PORT, () => {
  console.log(`ShopNow backend (business logic tier) running on http://localhost:${PORT}`);
});
