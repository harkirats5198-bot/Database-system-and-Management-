CREATE DATABASE SmartDBNavigator;
USE SmartDBNavigator;

CREATE TABLE Station (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    station_code VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Train (
    train_id INT PRIMARY KEY AUTO_INCREMENT,
    train_number VARCHAR(20) NOT NULL UNIQUE,
    train_type VARCHAR(20) NOT NULL,
    total_coaches INT NOT NULL CHECK (total_coaches > 0)
);

CREATE TABLE Route (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    source_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    distance_km DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (source_station_id) REFERENCES Station(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Station(station_id)
);

CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT NOT NULL,
    route_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    FOREIGN KEY (train_id) REFERENCES Train(train_id),
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

CREATE TABLE Coach (
    coach_id INT PRIMARY KEY AUTO_INCREMENT,
    train_id INT NOT NULL,
    coach_number VARCHAR(10) NOT NULL,
    total_seats INT NOT NULL CHECK (total_seats > 0),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);

CREATE TABLE Seat (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    coach_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_status VARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id),
    UNIQUE (coach_id, seat_number)
);

CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL
);

CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    schedule_id INT NOT NULL,
    seat_id INT NOT NULL,
    reservation_status VARCHAR(20) DEFAULT 'Booked',
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (schedule_id) REFERENCES Schedule(schedule_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id)
);

CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id INT NOT NULL UNIQUE,
    ticket_price DECIMAL(8,2) NOT NULL CHECK (ticket_price > 0),
    ticket_status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Paid',
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id)
);



INSERT INTO Station (station_name, city, station_code) VALUES
('Berlin Hbf', 'Berlin', 'BER'),
('Munich Hbf', 'Munich', 'MUN'),
('Frankfurt Hbf', 'Frankfurt', 'FRA'),
('Hamburg Hbf', 'Hamburg', 'HAM'),
('Cologne Hbf', 'Cologne', 'COL');

INSERT INTO Train (train_number, train_type, total_coaches) VALUES
('ICE 1001', 'ICE', 3),
('IC 2205', 'IC', 2),
('RE 3302', 'RE', 2);

INSERT INTO Route (source_station_id, destination_station_id, distance_km) VALUES
(1, 2, 584.00),
(1, 3, 545.00),
(4, 5, 424.00),
(3, 2, 394.00);

INSERT INTO Schedule (train_id, route_id, departure_time, arrival_time) VALUES
(1, 1, '2026-07-01 08:00:00', '2026-07-01 12:30:00'),
(2, 2, '2026-07-01 09:15:00', '2026-07-01 13:00:00'),
(3, 3, '2026-07-01 10:00:00', '2026-07-01 14:20:00'),
(1, 4, '2026-07-02 07:30:00', '2026-07-02 11:00:00');

INSERT INTO Coach (train_id, coach_number, total_seats) VALUES
(1, 'C1', 5),
(1, 'C2', 5),
(1, 'C3', 5),
(2, 'C1', 5),
(2, 'C2', 5),
(3, 'C1', 5),
(3, 'C2', 5);

INSERT INTO Seat (coach_id, seat_number) VALUES
(1, '1A'), (1, '1B'), (1, '1C'), (1, '1D'), (1, '1E'),
(2, '2A'), (2, '2B'), (2, '2C'), (2, '2D'), (2, '2E'),
(3, '3A'), (3, '3B'), (3, '3C'), (3, '3D'), (3, '3E'),
(4, '1A'), (4, '1B'), (4, '1C'), (4, '1D'), (4, '1E'),
(5, '2A'), (5, '2B'), (5, '2C'), (5, '2D'), (5, '2E');

INSERT INTO Passenger (full_name, email, phone) VALUES
('Ali Khan', 'ali@example.com', '03001234567'),
('Sara Ahmed', 'sara@example.com', '03011234567'),
('John Smith', 'john@example.com', '03021234567'),
('Maria Khan', 'maria@example.com', '03031234567');

INSERT INTO Reservation (passenger_id, schedule_id, seat_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 16);

UPDATE Seat 
SET seat_status = 'Booked' 
WHERE seat_id IN (1, 2, 16);

INSERT INTO Ticket (reservation_id, ticket_price) VALUES
(1, 89.99),
(2, 89.99),
(3, 59.99);

INSERT INTO Payment (ticket_id, amount, payment_method) VALUES
(1, 89.99, 'Card'),
(2, 89.99, 'Cash'),
(3, 59.99, 'Card');


SELECT
    t.train_number,
    t.train_type,
    s1.station_name AS Source,
    s2.station_name AS Destination,
    r.distance_km
FROM Route r
JOIN Station s1 ON r.source_station_id = s1.station_id
JOIN Station s2 ON r.destination_station_id = s2.station_id
JOIN Schedule sc ON r.route_id = sc.route_id
JOIN Train t ON sc.train_id = t.train_id;


SELECT
    seat_id,
    seat_number,
    seat_status
FROM Seat
WHERE seat_status = 'Available';


SELECT
    seat_id,
    seat_number,
    seat_status
FROM Seat
WHERE seat_status = 'Booked';


SELECT
    p.full_name,
    r.reservation_id,
    se.seat_number
FROM Reservation r
JOIN Passenger p
ON r.passenger_id = p.passenger_id
JOIN Seat se
ON r.seat_id = se.seat_id;

SELECT
    p.full_name,
    t.ticket_id,
    t.ticket_price
FROM Ticket t
JOIN Reservation r
ON t.reservation_id = r.reservation_id
JOIN Passenger p
ON r.passenger_id = p.passenger_id;

SELECT
    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_status
FROM Payment pay;



UPDATE Seat
SET seat_status='Available'
WHERE seat_id=1;

SELECT * FROM Seat WHERE seat_id=1;

DELETE FROM Payment
WHERE payment_id=3;

SELECT * FROM Payment;