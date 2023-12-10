const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db');
const authRoutes = require('./routes/AuthRoutes');
const itemRoutes = require('./routes/ItemRoutes');
const userRoutes = require('./routes/UserRoutes');

const app = express();
const port = process.env.PORT || 3001;


app.use(bodyParser.json());
app.use(cors());

app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/items', itemRoutes);

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
