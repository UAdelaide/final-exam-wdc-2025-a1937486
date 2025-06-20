USE DogWalkService;

-- Users Table Inserts
INSERT INTO Users (username, email, password_hash, role) VALUES
('alice123', 'alice@example.com', 'hashed123', 'owner'),
('bobwalker', 'bob@example.com', 'hashed456', 'walker'),
('carol123', 'carol@example.com', 'hashed789', 'owner'),
('davidowner', 'david@example.com', 'hashedabc', 'owner'),
('evewalker', 'eve@example.com', 'hasheddef', 'walker');




-- Dogs Table Inserts
INSERT INTO Dogs (owner_id, name, size) VALUES
((SELECT user_id FROM Users WHERE username = 'alice123'), 'Max', 'medium'),
((SELECT user_id FROM Users WHERE username = 'carol123'), 'Bella', 'small'),
((SELECT user_id FROM Users WHERE username = 'davidowner'), 'Rocky', 'large'),
((SELECT user_id FROM Users WHERE username = 'alice123'), 'Lucy', 'medium'),
((SELECT user_id FROM Users WHERE username = 'carol123'), 'Charlie', 'small');




-- WalkRequests Table Inserts
INSERT INTO WalkRequests (dog_id, requested_time, duration_minutes, location, status) VALUES
((SELECT dog_id FROM Dogs WHERE name = 'Max' AND owner_id = (SELECT user_id FROM Users WHERE username = 'alice123')), '2025-06-10 08:00:00', 30, 'Parklands', 'open'),
((SELECT dog_id FROM Dogs WHERE name = 'Bella' AND owner_id = (SELECT user_id FROM Users WHERE username = 'carol123')), '2025-06-10 09:30:00', 45, 'Beachside Ave', 'accepted'),
((SELECT dog_id FROM Dogs WHERE name = 'Rocky' AND owner_id = (SELECT user_id FROM Users WHERE username = 'davidowner')), '2025-06-10 10:00:00', 60, 'City Park', 'open'),
((SELECT dog_id FROM Dogs WHERE name = 'Lucy' AND owner_id = (SELECT user_id FROM Users WHERE username = 'alice123')), '2025-06-10 11:00:00', 30, 'Riverwalk', 'open'),
((SELECT dog_id FROM Dogs WHERE name = 'Charlie' AND owner_id = (SELECT user_id FROM Users WHERE username = 'carol123')), '2025-06-10 14:00:00', 45, 'Green Valley', 'completed');


