// api/server.js
app.get('/query', async (req, res) => {
  const { sql, user, password } = req.query
  
  const client = new Client({
    host: 'postgres',
    database: 'demo',
    user,
    password,
  })

  try {
    await client.connect()
    const { rows } = await client.query(sql)
    res.json(rows)
  } catch (e) {
    res.status(500).json({ error: e.message })
  } finally {
    await client.end()
  }
})