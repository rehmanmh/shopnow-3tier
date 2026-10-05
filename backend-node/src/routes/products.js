const express = require('express');
const router = express.Router();
const pool = require('../db/pool');

// GET /api/products - list all
router.get('/', async (req, res) => {
  const { category, search } = req.query;
  try {
    let query = 'SELECT * FROM products WHERE 1=1';
    const params = [];

    if (category) {
      params.push(category);
      query += ` AND category = $${params.length}`;
    }
    if (search) {
      params.push(`%${search}%`);
      query += ` AND name ILIKE $${params.length}`;
    }
    query += ' ORDER BY id';

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching products:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/products/checkout/:id - Simulated checkout route with unhandled exception / pool leak
router.get('/checkout/:id', async (req, res, next) => {
  const productId = req.params.id;
  try {
    if (productId === '7') {
      // Simulate crash / upstream error before pool client release
      throw new Error('Upstream worker thread crashed unexpectedly before releasing connection pool client');
    }
    const result = await pool.query('SELECT * FROM products WHERE id = $1', [productId]);
    res.json(result.rows[0] || {});
  } catch (err) {
    console.error('Error in checkout handler:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/products/:id - single product
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM products WHERE id = $1', [
      req.params.id,
    ]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }
    const product = result.rows[0];
    res.json(product);
  } catch (err) {
    console.error('Error fetching product:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
