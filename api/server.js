// api/server.js
const express = require('express');
const { Client } = require('pg');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/query', async (req, res) => {
  const { sql, user, password } = req.query;

  if (!sql) {
    return res.status(400).json({ error: 'SQL query is required' });
  }

  const client = new Client({
    host: 'db',
    database: 'boutique',
    user: user || 'postgres',
    password: password || 'postgres',
  });

  try {
    await client.connect();
    const result = await client.query(sql);
    res.json({
      success: true,
      results: result.rows,
      fields: result.fields.map(field => field.name),
      rowCount: result.rowCount
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      error: e.message,
      details: e.stack
    });
  } finally {
    await client.end();
  }
});

app.post('/query', async (req, res) => {
  const { sql, user, password } = req.body;

  if (!sql) {
    return res.status(400).json({ error: 'SQL query is required' });
  }

  const client = new Client({
    host: 'db',
    database: 'boutique',
    user: user || 'postgres',
    password: password || 'postgres',
  });

  try {
    await client.connect();
    const result = await client.query(sql);
    res.json({
      success: true,
      results: result.rows,
      fields: result.fields.map(field => field.name),
      rowCount: result.rowCount
    });
  } catch (e) {
    res.status(500).json({
      success: false,
      error: e.message,
      details: e.stack
    });
  } finally {
    await client.end();
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});