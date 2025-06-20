const express = require('express');
const path = require('path');
const session = require('express-session');
const bcrypt = require('bcrypt');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();

// Database connection configuration
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'DogWalkService'
};

// Session middleware configuration
app.use(session({
  secret: 'dog-walking-service-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    maxAge: 24 * 60 * 60 * 1000
  }
}));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '/public')));

// Login route
app.post('/login', async (req, res) => {
  console.log('Login request received:', req.body);
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'Username and password are required' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);
    const [rows] = await connection.execute(
      'SELECT user_id, username, password_hash, role FROM Users WHERE username = ?',
      [username]
    );
    await connection.end();

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    const user = rows[0];

    if (password !== user.password_hash) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    req.session.userId = user.user_id;
    req.session.username = user.username;
    req.session.role = user.role;

    // Return success response with user role
    res.json({
      success: true,
      role: user.role,
      username: user.username
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Logout route
app.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ message: 'Could not log out' });
    }
    res.json({ success: true });
  });
});

// Middleware for auth
const requireAuth = (req, res, next) => {
  if (!req.session.userId) {
    return res.status(401).json({ message: 'Unauthorized' });
  }
  next();
