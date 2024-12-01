
--================================================================================================
--================================================================================================
--	Creating tables code is not heavily commented because it's self-descriptive
--	To know more about why everything is made like this and what the purpose of all the details
--	please visit this GitHub repo to read the documentation: https://github.com/Ahmed55055/Hotel_DB/blob/main/Documentation.md

--	the creating script of the database is saperated into two parts
--	First is helper tables which are the tables where the info will be fixed 
--	or won't need to be updated for a long time
--	the second part is the main tables that have references and indexes
--================================================================================================
--================================================================================================

-- Creating Database

-- CREATE DATABASE Hotel_DB;
-- Use Hotel_DB;

--==================================================================================================
---------------------------[		Helper Tables		]-----------------------------------
--==================================================================================================
-- Create Countries Table
CREATE TABLE Countries (
    country_id		INT IDENTITY(1,1),
    name			NVARCHAR(255)	NOT NULL,
    country_code	NVARCHAR(10)	NOT NULL,
    iso_code		NVARCHAR(10)	NOT NULL,

	CONSTRAINT PK_Countries Primary Key (country_id)
);

-- Create ID Proof Types Table
CREATE TABLE id_proof_types (
    id_proof_type_id	INT IDENTITY(1,1),
    proof_type_name		NVARCHAR(255)	NOT NULL,

	CONSTRAINT PK_id_proof_types Primary Key (id_proof_type_id)
);

-- Create User Types Table
CREATE TABLE User_Types (
    user_type_id	INT IDENTITY(1,1),
    type_name		NVARCHAR(255)	NOT NULL,
    description		NVARCHAR(MAX)	NULL,		-- Using NVARCHAR(MAX) for potentially large text
    permissions		BIGINT			NOT NULL,
	-- to not make the database more bigger made the permissions as binary data structure / flag
	-- to be handled at businuss logic layer and it would be better like that and more flexable

	CONSTRAINT PK_User_Types Primary Key (user_type_id)
);

-- Create Communication Ways Table
CREATE TABLE Communication_Ways (
    communication_way_id	INT IDENTITY(1,1),
    communication_name		NVARCHAR(255) NOT NULL,

	CONSTRAINT PK_Communication_Ways Primary Key (communication_way_id)
	CONSTRAINT UC_communication_name UNIQUE (communication_name),

);

-- Create Loyalty Tiers Table
CREATE TABLE Loyalty_Tiers (
    loyalty_tier_id INT IDENTITY(1,1),
    tier_name		NVARCHAR(255)	NOT NULL,
    min_points		INT				NOT NULL,

	CONSTRAINT PK_Loyalty_Tiers Primary Key (loyalty_tier_id)
);

-- Create Services Table
CREATE TABLE Services (
    service_id		INT IDENTITY(1,1),
    service_name	NVARCHAR(255)	NOT NULL,
    description		NVARCHAR(MAX)	NULL,		-- Using NVARCHAR(MAX) for potentially large text
    price_usd		SMALLMONEY		NOT NULL,

	CONSTRAINT PK_Services Primary Key (service_id)
);

-- Create Bed Types Table
CREATE TABLE bed_types (
    bed_type_id INT IDENTITY(1,1),
    type_name	NVARCHAR(255)	NOT NULL,
    description NVARCHAR(MAX)	NULL,
    capacity	SMALLINT		NOT NULL

-- CONSTRAINT
	CONSTRAINT PK_bed_types		Primary Key (bed_type_id),
	CONSTRAINT CK_capacity		CHECK (capacity > 0)
);

-- Create Employee Types Table
CREATE TABLE Employee_Types (
    employee_type_id	INT IDENTITY(1,1),
    type_name			NVARCHAR(255) NOT NULL,
    description			NVARCHAR(MAX) NULL

	CONSTRAINT PK_Employee_Types Primary Key (employee_type_id)
);

-- Create Room Status Table
CREATE TABLE room_status (
    room_status_id INT	IDENTITY(1,1),
    status				NVARCHAR(255) NOT NULL,
    description			NVARCHAR(MAX) NULL

	CONSTRAINT PK_room_status Primary Key (room_status_id)
);


-- Create Payment Methods Table
CREATE TABLE Payment_Methods (
    payment_method_id	INT IDENTITY(1,1),
    method_name			NVARCHAR(255) NOT NULL,
    description			NVARCHAR(MAX) NULL

	CONSTRAINT PK_Payment_Methods Primary Key (payment_method_id)
);

-- Create Payment Status Table
CREATE TABLE Payment_Status (
    status_id	INT IDENTITY(1,1),
    status_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL

	CONSTRAINT PK_Payment_Status Primary Key (status_id)
);

-- Create Card Types Table
CREATE TABLE Card_Types (
    card_type_id	INT IDENTITY(1,1),
    card_name		NVARCHAR(255) NOT NULL,
    description		NVARCHAR(MAX) NULL

	CONSTRAINT PK_Card_Types Primary Key (card_type_id)
);

-- Create Currencies Table
CREATE TABLE Currencies (
    currency_id		INT IDENTITY(1,1),
    currency_name	NVARCHAR(255) NOT NULL,
    currency_code	NVARCHAR(10) NOT NULL,
	
	CONSTRAINT PK_Currencies	Primary Key (currency_id),
	CONSTRAINT UC_currency		Unique		(currency_name , currency_code)
);

--==================================================================================================
---------------------------[		Create People Table			]-----------------------------------
--==================================================================================================



-- Create people table
CREATE TABLE People (
    person_id			INT IDENTITY(1,1),
    first_name			NVARCHAR(255)	NOT NULL,
    second_name			NVARCHAR(255)	NULL,
    third_name			NVARCHAR(255)	NULL,
    last_name			NVARCHAR(255)	NOT NULL,
    email				NVARCHAR(255)	NULL,		 
    date_of_birth		DATE			NULL,
    id_proof_type_id	INT				NOT NULL,
    id_proof_type_number NVARCHAR(255)	NOT NULL,
    country_id			INT				NOT NULL,

--Constraints
    CONSTRAINT PK_People				Primary Key (person_id),	 -- Clustered Index By Defualt
	CONSTRAINT UC_id_proof_type_number	UNIQUE		(id_proof_type_number),
	CONSTRAINT FK_Person_Country		FOREIGN KEY (country_id)		REFERENCES Countries(country_id),
    CONSTRAINT FK_Person_IDProofType	FOREIGN KEY (id_proof_type_id)	REFERENCES id_proof_types(id_proof_type_id)
);

-- INDEXIES

-- Indexing email
-- Conditional index to be able to store multiple nullables in a unique field
-- why we need unique email 
CREATE UNIQUE NONCLUSTERED INDEX idx_people_email ON People(email)
WHERE email IS NOT NULL

-- Indexing first name
CREATE NONCLUSTERED INDEX idx_first_name
ON People (first_name);

-- Indexing last name
CREATE NONCLUSTERED INDEX idx_last_name
ON People (first_name);



----------------------------------------------------------------------------------------------------

-- create Users Table
CREATE TABLE Users (
    user_id			INT IDENTITY(1,1),
    username		NVARCHAR(255)	NOT NULL,
    password_hash	NVARCHAR(255)	NOT NULL,			-- Will be hashed inside Business Logic Layer
    is_active		BIT				DEFAULT 1,			-- 1 Is true, 0 is false
    last_login		DATETIME		NULL,
    account_locked	BIT				DEFAULT 0,
    account_locked_until DATETIME	NULL,
    person_id		INT				NULL,
    user_type_id	INT				NOT NULL,

-- Constraints
    CONSTRAINT PK_Users				Primary Key (user_id),
	CONSTRAINT UC_username			UNIQUE (username),
    CONSTRAINT FK_Users_Person		FOREIGN KEY (person_id)		REFERENCES People(person_id),
    CONSTRAINT FK_Users_UserType	FOREIGN KEY (user_type_id)	REFERENCES User_Types(user_type_id)
);

-- Indexies
CREATE NONCLUSTERED INDEX idx_username
ON Users (username);


--------------------------------------------------------------------------------------------------

-- Create Room Types Table
CREATE TABLE Room_Types (
    room_type_id		INT IDENTITY(1,1),
	room_name			NVARCHAR(255)	NOT NULL,
    bed_type_id			INT				NOT NULL,
    capacity			SMALLINT		NOT NULL,
    wifi				BIT DEFAULT 0,
    internet_speed_MB	FLOAT(24)		NULL,
    tv					BIT DEFAULT 0,
    work_desk			BIT DEFAULT 0,
    balcony				BIT DEFAULT 0,
    refrigerator		BIT DEFAULT 0,
    coffee_maker		BIT DEFAULT 0,
    safe				BIT DEFAULT 0,
    room_orientation	NVARCHAR(255)	NULL,
    base_price_rate		SMALLMONEY		NOT NULL,

	-- CONSTRAINTs
	CONSTRAINT PK_Room_Types			Primary Key (room_type_id),
	CONSTRAINT CK_Room_Types_Capacity	CHECK		(capacity > 0), --capacity cant be 0 or negative
    CONSTRAINT FK_RoomTypes_BedType		FOREIGN KEY (bed_type_id) REFERENCES bed_types(bed_type_id)
);



------------------------------------------------------------------------------------------------

-- Create Guests Table

-- NOTE: denormalized "last_stay_date" and "total_stays" for better preformance 
-- Instead of EXECUTING a Query on other table for every person we need this information about him
-- To see how the businuss logic will be like look at Documentation here: https://github.com/Ahmed55055/Hotel_DB/blob/main/Documentation.md#17-guests-table
CREATE TABLE Guests (
    guest_id		INT IDENTITY(1,1),	
    person_id		INT			NOT NULL ,		-- Indexed For Joined Query Preformance
    loyalty_tier_id INT,
    loyalty_points	INT DEFAULT 0,				-- When creating a guest it's his first stay so he won't have loyalty points
    total_stays		INT DEFAULT 0,				-- When creating a guest it's his he didn't stay yet
    preferred_room_type_id INT	NULL,
    last_stay_date	DATE		NULL,
    communication_preference_id INT,
    is_vip			BIT DEFAULT 0,
    user_id			INT			NULL,

-- Constraints
	CONSTRAINT PK_Guests					Primary Key (guest_id),
    CONSTRAINT FK_Guests_Person				FOREIGN KEY (person_id)						REFERENCES People(person_id),
    CONSTRAINT FK_Guests_LoyaltyTier		FOREIGN KEY (loyalty_tier_id)				REFERENCES Loyalty_Tiers(loyalty_tier_id),
    CONSTRAINT FK_Guests_PreferredRoomType	FOREIGN KEY (preferred_room_type_id)		REFERENCES Room_Types(room_type_id),
    CONSTRAINT FK_Guests_CommunicationPref	FOREIGN KEY (communication_preference_id)	REFERENCES Communication_Ways(communication_way_id),
    CONSTRAINT FK_Guests_User				FOREIGN KEY (user_id)						REFERENCES Users(user_id)
);
-- indexing person_id
-- Indexed For Joined Query Preformance
CREATE NONCLUSTERED INDEX idx_person_id
ON People (person_id);


-------------------------------------------------------------------------------------------------------

-- Create Loyalty Benefits Table

	-- float Precision
	-- 1-24		7  digits	4 bytes storage size
	-- 25-53	15 digits	8 bytes storage size

CREATE TABLE Loyalty_Benefits (
    benefit_id				INT IDENTITY(1,1),
    loyalty_tier_id			INT			NOT NULL,
    service_id				INT			NOT NULL,
    discount_percentage		float(24)	NOT NULL, 
    points					INT			NOT NULL,

	-- Adding constraint for discount percentage and forign keys
	CONSTRAINT PK_Loyalty_Benefits				Primary Key (benefit_id),
	CONSTRAINT CK_discount_percentage			CHECK		(discount_percentage >= 0 AND discount_percentage <= 100), 
    CONSTRAINT FK_LoyaltyBenefits_LoyaltyTier	FOREIGN KEY (loyalty_tier_id)	REFERENCES Loyalty_Tiers(loyalty_tier_id),
    CONSTRAINT FK_LoyaltyBenefits_Service		FOREIGN KEY (service_id)		REFERENCES Services(service_id)
);



--------------------------------------------------------------------------------------------------


-- Create Rooms Table
CREATE TABLE Rooms (
    room_id			INT IDENTITY(1,1),
    room_type_id	INT			NOT NULL,
    capacity		SMALLINT	NOT NULL,
    floor			SMALLINT	NOT NULL,
    room_status_id	INT			NOT NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Rooms					Primary Key (room_id),

	--Check
	CONSTRAINT CK_Rooms_capacity		CHECK		(capacity > 0),	-- Capacity must be positive
	CONSTRAINT CK_Floor					CHECK		(floor >= 0),	-- Floor must be non-negative

	-- FOREIGN KEYs
    CONSTRAINT FK_Rooms_RoomType		FOREIGN KEY (room_type_id)		REFERENCES Room_Types(room_type_id),
    CONSTRAINT FK_Rooms_CurrentStatus	FOREIGN KEY (room_status_id)	REFERENCES room_status(room_status_id)
);



----------------------------------------------------------------------------------------------------

-- Create Staff Table
CREATE TABLE Staff (
    staff_id				INT IDENTITY(1,1),
    person_id				INT				NOT NULL,
    department_id			INT				NULL,		-- Staff REFERENCES departments and the opposite
    position_id				INT				NOT NULL,
    manager_id				INT				NULL,
    salary					SMALLMONEY		NOT NULL,
    employee_type_id		INT				NOT NULL,
    emergency_contact_phone NVARCHAR(15)	NULL,
    bank_account_number		NVARCHAR(20)	NULL,
    performance_rating		FLOAT(24)		DEFAULT 5,
    employment_status		INT				NOT NULL,
    hire_date				DATETIME		NOT NULL,
    departure_date			DATE			NULL,
    user_id					INT				NOT NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Staff				Primary Key (staff_id),

-- CHECK
	CONSTRAINT CK_salary			 CHECK (salary >= 0), -- Salary must be non-negative
	CONSTRAINT CK_performance_rating CHECK (performance_rating >= 0 AND performance_rating <= 5), -- Rating between 0 and 5

-- FOREIGN KEY
    CONSTRAINT FK_Staff_Person		FOREIGN KEY (person_id)		REFERENCES People(person_id),
	CONSTRAINT FK_Staff_Manager		FOREIGN KEY (manager_id)	REFERENCES Staff(staff_id), -- Self refrantioal
    CONSTRAINT FK_Staff_User		FOREIGN KEY (user_id)		REFERENCES Users(user_id)


--	Two CONSTRAINTS Added Later By Alter Table 
--	Due to the disability of making a FOREIGN KEY referencing a table isn't created yet.
--	The constraints made after each table creation
--	CONSTRAINT 1: department_id REFERENCES Departments
--	CONSTRAINT 2: position_id REFERENCES Positions

);

-- Indexing person_id for better joined Query Preformance
CREATE NONCLUSTERED INDEX idx_person_id
ON Staff (person_id);


----------------------------------------------------------------------------------------------------


-- Create Departments Table
CREATE TABLE Departments (
    department_id	INT IDENTITY(1,1),
    department_name NVARCHAR(255)	NOT NULL,
    department_head INT				NULL,
    email			NVARCHAR(255)	NULL,
    budget			MONEY			NOT NULL ,
    location		NVARCHAR(255)	NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Departments					Primary Key (department_id),
	CONSTRAINT CK_budget						CHECK (budget >= 0), -- Budget must be non-negative
    CONSTRAINT FK_Departments_DepartmentHead	FOREIGN KEY (department_head) REFERENCES Staff(staff_id)
);

--	because circular referencing
--	The staff table has references for departments.
--	and departments has refrence for staff
--	The department_id in the staff table should be nullable.
--	and must add the forign key constrint after creating the tow tables

Alter Table Staff
Add CONSTRAINT FK_Staff_Department	FOREIGN KEY (department_id) REFERENCES Departments(department_id);


----------------------------------------------------------------------------------------------------

-- Create Position Table
CREATE TABLE Position (
    position_id		 INT IDENTITY(1,1),
    title			 NVARCHAR(255)	NOT NULL,
    department_id	 INT			NOT NULL,
    salary_min		 MONEY			NOT NULL, 
    salary_max		 MONEY			NOT NULL, 
    qualifications	 NVARCHAR(MAX)	NULL,
    responsibilities NVARCHAR(MAX)	NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Position				Primary Key (position_id),
	CONSTRAINT CK_salary_min			CHECK		(salary_min >= 0),			-- Minimum salary must be non-negative
	CONSTRAINT CK_salary_max			CHECK		(salary_max >= salary_min),	-- Maximum salary must be greater than or equal to minimum
    CONSTRAINT FK_Position_Department	FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

Alter Table Staff
Add CONSTRAINT FK_Staff_Position FOREIGN KEY (position_id) REFERENCES Position(position_id);


----------------------------------------------------------------------------------------------------


-- Create Phone Table
CREATE TABLE Phone (
    phone_id		INT IDENTITY(1,1),
    phone_number	NVARCHAR(15)	NOT NULL,
    person_id		INT				NOT NULL,
    is_active		BIT				DEFAULT 1,

-- CONSTRAINTS
	CONSTRAINT PK_Phone			Primary Key (phone_id),
    CONSTRAINT FK_Phone_Person	FOREIGN KEY (person_id) REFERENCES People(person_id)
);

-- indexing person_id
CREATE NONCLUSTERED INDEX idx_person_id
ON Phone (person_id);

----------------------------------------------------------------------------------------------------

-- Create Reservation Table
CREATE TABLE Reservation (
    reservation_id			INT IDENTITY(1,1),
    guest_id				INT			NOT NULL,
    room_id					INT			NOT NULL,
    check_in_date			DATETIME	NOT NULL,
    check_out_date			DATETIME	NOT NULL,
    actual_check_out_date	DATETIME	NULL,
    payment_id				INT			NULL,

-- Constraints
	CONSTRAINT PK_Reservation			Primary Key (reservation_id),
    CONSTRAINT FK_Reservation_Guest		FOREIGN KEY (guest_id)		REFERENCES Guests(guest_id),
    CONSTRAINT FK_Reservation_Room		FOREIGN KEY (room_id)		REFERENCES Rooms(room_id),
-- there is a fk constraint added later due to circluare refrance
);

--indexing guest id
CREATE NONCLUSTERED INDEX idx_person_id
ON Reservation (guest_id);


----------------------------------------------------------------------------------------------------


-- Create Payment Table
CREATE TABLE Payment (
    payment_id			INT IDENTITY(1,1),
    reservation_id		INT				NOT NULL,
    guest_id			INT				NOT NULL,
    amount				MONEY			NOT NULL,
    payment_method_id	INT				NOT NULL,
    payment_status_id	INT				NOT NULL,
    card_type_id		INT				NOT NULL,
    payment_date		DATETIME		NOT NULL,
    currency_id			INT				NOT NULL,
    note				NVARCHAR(MAX)	NULL,

-- Constraints
	CONSTRAINT PK_Payment			Primary Key (payment_id),

-- Check
	CONSTRAINT CK_amount CHECK (amount >= 0), -- Amount must be non-negative

-- Forign Keys
    CONSTRAINT FK_Payment_Reservation	FOREIGN KEY (reservation_id)	REFERENCES Reservation(reservation_id),
    CONSTRAINT FK_Payment_Guest			FOREIGN KEY (guest_id)			REFERENCES Guests(guest_id),
    CONSTRAINT FK_Payment_Method		FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id),
    CONSTRAINT FK_Payment_Status		FOREIGN KEY (payment_status_id) REFERENCES Payment_Status(status_id),
    CONSTRAINT FK_Payment_CardType		FOREIGN KEY (card_type_id)		REFERENCES Card_Types(card_type_id),
    CONSTRAINT FK_Payment_Currency		FOREIGN KEY (currency_id)		REFERENCES Currencies(currency_id)
);

Alter Table Reservation
add CONSTRAINT FK_Reservation_Payment	FOREIGN KEY (payment_id)	REFERENCES Payment(payment_id)

-- End of Database Creation Script





--====================================================================================================
--=============================[		Insert Statments		]=====================================


-- NOTE
-- I got some data from a dataset like (countries, currencies)
-- but i left an insert statment of all the countries on Github If needed

-- And this is how i got the insert statment on the Github
-- select insert_statment = '(''' + name + ''' , '''+ iso_code + ''' , '''+iso_code+'''),' from Countries



-------------------------------------------------------------------------------------------------

-- normale insert 


INSERT INTO bed_types (type_name, description, capacity) 
VALUES 
('Platform Bed'			, 'A bed with a solid or slatted base that supports a mattress without the need for a box spring.', 2),
('Canopy Bed'			, 'A bed with posts at each corner extending upwards, often draped with fabric.', 2),
('Sleigh Bed'			, 'A bed characterized by curved or scrolled headboards and footboards.', 2),
('Four-Poster Bed'		, 'A bed with four vertical posts, often without fabric draping.', 2),
('Daybed'				, 'A versatile piece that can serve as a sofa or a bed, often with a twin mattress.', 1);


INSERT INTO Card_types (card_name, description) VALUES 
('Visa', 'A widely accepted credit card known for its reliability and security.'),
('MasterCard', 'A popular credit card that offers various benefits and rewards.'),
('American Express', 'A premium credit card known for its travel rewards and customer service.');

INSERT INTO Communication_Ways (communication_name) VALUES 
('Phone'),
('Email'),
('SMS/Text Messaging'),
('In-Person Communication'),
('Chat (Live Chat)'),
('Social Media'),
('Website Contact Form'),
('Mobile App Notifications'),
('Video Conferencing'),
('Fax');

INSERT INTO Departments (department_name, email, budget, location) VALUES 
('Front Office', 'frontoffice@hotel.com', 200000.00, 'Main Lobby'),
('Housekeeping', 'housekeeping@hotel.com', 150000.00, 'Ground Floor'),
('Food and Beverage', 'fandb@hotel.com', 300000.00, 'Restaurant Level'),
('Sales and Marketing', 'sales@hotel.com', 250000.00, 'Office Block'),
('Human Resources', 'hr@hotel.com', 100000.00, 'Admin Wing'),
('Finance', 'finance@hotel.com', 120000.00, 'Finance Department'),
('Maintenance', 'maintenance@hotel.com', 80000.00, 'Service Area'),
('IT Department', 'it@hotel.com', 90000.00, 'Tech Hub'),
('Spa and Wellness', 'spa@hotel.com', 70000.00, 'Spa Level'),
('Security', 'security@hotel.com', 60000.00, 'Main Entrance');


INSERT INTO Employee_Types (type_name, description) VALUES 
('Full-Time', 'Employees who work a standard number of hours per week, typically 40 hours.'),
('Part-Time', 'Employees who work fewer hours than full-time employees, often on a flexible schedule.'),
('Temporary', 'Employees hired for a specific period or project, often to cover peak seasons.'),
('Intern', 'Students or recent graduates who work temporarily to gain practical experience.'),
('Contractor', 'Self-employed individuals or companies hired to perform specific tasks or projects.'),
('Seasonal', 'Employees hired during peak seasons, such as summer or holidays, to meet increased demand.'),
('Manager', 'Employees responsible for overseeing specific departments or operations within the hotel.'),
('Staff', 'General employees who perform various operational tasks within the hotel.'),
('Executive', 'High-level employees responsible for strategic decision-making and overall management.'),
('Culinary', 'Employees who work in the kitchen, including chefs and kitchen staff.');


INSERT INTO id_proof_types (proof_type_name) VALUES 
('Passport'),
('Driver''s License'),
('National ID Card'),
('Voter ID'),
('Employee ID'),
('Student ID'),
('Utility Bill'),
('Bank Statement');

INSERT INTO User_Types (type_name, description, permissions) VALUES 
('Admin', 'Users with full access to all system features and settings.', 1),  -- permissions as a binary flag
('Staff', 'Regular staff members with access to operational features.', 2),
('Guest', 'Users who can book and manage their reservations.', 4),
('Manager', 'Users who oversee specific departments and have managerial access.', 8),
('Maintenance', 'Users responsible for maintenance tasks with limited access.', 16),
('Housekeeping', 'Users who manage room cleaning and maintenance tasks.', 32);

INSERT INTO Loyalty_Tiers (tier_name, min_points) VALUES 
('Bronze', 0),
('Silver', 1000),
('Gold', 5000),
('Platinum', 10000),
('Diamond', 20000);

INSERT INTO Services (service_name, description, price_usd) VALUES 
('Room Service', '24-hour room service with a variety of dining options.', 15.00),
('Spa Treatment', 'Relaxing spa services including massages and facials.', 100.00),
('Airport Shuttle', 'Transportation to and from the airport.', 30.00),
('Laundry Service', 'Same-day laundry and dry cleaning services.', 20.00),
('Concierge Services', 'Personalized assistance for reservations and recommendations.', 10.00),
('Gym Access', 'Access to the hotel gym and fitness facilities.', 5.00);

INSERT INTO room_status (status, description) VALUES 
('Available', 'Room is available for booking.'),
('Occupied', 'Room is currently occupied by a guest.'),
('Under Maintenance', 'Room is undergoing maintenance and cannot be booked.'),
('Clean', 'Room has been cleaned and is ready for the next guest.'),
('Dirty', 'Room needs cleaning after guest checkout.'),
('Reserved', 'Room has been reserved but not yet checked in.');

INSERT INTO Payment_Methods (method_name, description) VALUES 
('Credit Card', 'Payment made using a credit card.'),
('Debit Card', 'Payment made using a debit card.'),
('Cash', 'Payment made in cash at the hotel.'),
('Online Payment', 'Payment made through online banking or payment gateways.'),
('Mobile Payment', 'Payment made using mobile payment applications (e.g., Apple Pay, Google Pay).');

INSERT INTO Payment_Status (status_name, description) VALUES 
('Pending', 'Payment is pending and has not been completed.'),
('Completed', 'Payment has been successfully completed.'),
('Failed', 'Payment attempt has failed.'),
('Refunded', 'Payment has been refunded to the guest.'),
('Cancelled', 'Payment has been cancelled by the guest or the hotel.');

INSERT INTO Room_Types (bed_type_id, capacity, wifi, internet_speed_MB, tv, work_desk, balcony, refrigerator, coffee_maker, safe, room_orientation, base_price_rate) VALUES 
(1, 2, 1, 100.0, 1, 1, 1, 1, 1, 1, 'Ocean View', 150.00),
(2, 4, 1, 50.0, 1, 1, 0, 1, 1, 1, 'City View', 250.00),
(3, 1, 1, 10.0, 0, 0, 0, 0, 0, 1, 'Garden View', 100.00),
(1, 3, 1, 75.0, 1, 1, 1, 0, 1, 0, 'Mountain View', 200.00),
(2, 2, 0, NULL, 1, 0, 0, 1, 0, 1, 'Pool View', 180.00);


INSERT INTO Loyalty_Benefits (loyalty_tier_id, service_id, discount_percentage, points) VALUES 
(1, 1, 5.0, 100),  -- Bronze tier		benefit for Room Service
(2, 2, 10.0, 200), -- Silver tier		benefit for Spa Treatment
(3, 3, 15.0, 300), -- Gold tier			benefit for Airport Shuttle
(4, 4, 20.0, 400), -- Platinum tier		benefit for Laundry Service
(4, 5, 20.0, 400), -- Platinum tier		benefit for Concierge Service
(5, 2, 25.0, 500), -- Diamond tier		benefit for Spa Services
(5, 5, 25.0, 500); -- Diamond tier		benefit for Concierge Services


INSERT INTO Rooms (room_type_id, capacity, floor, room_status_id) VALUES 
(1, 2, 1, 1),  -- Room Type ID 1,	Capacity 2,		Floor 1,	Status ID 1 (Available)
(2, 4, 2, 2),  -- Room Type ID 2,	Capacity 4,		Floor 2,	Status ID 2 (Occupied)
(3, 1, 1, 3),  -- Room Type ID 3,	Capacity 1,		Floor 1,	Status ID 3 (Under Maintenance)
(1, 3, 3, 4),  -- Room Type ID 1,	Capacity 3,		Floor 3,	Status ID 4 (Clean)
(2, 2, 2, 5);  -- Room Type ID 2,	Capacity 2,		Floor 2,	Status ID 5 (Dirty)


INSERT INTO People (first_name, second_name, third_name, last_name, email, date_of_birth, id_proof_type_id, id_proof_type_number, country_id) VALUES 
('Ahmed', 'Ibrahim'	, NULL	, 'Sayed', 'ahmed.ibrahim@gmail.com', '2005-06-15', 1, 'A123456789', 1),  -- Ahmed Ibrahim Sayed
('Ahmed', 'Bassem'	,NULL	, 'Ramadan', 'ahmed.bassem.ramadan@gmail.com', '2005-04-25', 2, 'B987654321', 2),  -- Ahmed Bassem Ramadan
('Ahmed', 'Hegazy'	,NULL	, 'Abdel-Aal', 'ahmed.hegazy.abdel.aal@gmail.com', '2005-11-30', 1, 'C123123123', 3),  -- Ahmed Hegazy Abdel-Aal
('Ahmed', 'Abdouh'	,NULL	, 'Mohamed', 'ahmed.abdouh.mohamed@gmail.com', '2005-01-20', 3, 'D987987987', 1),  -- Ahmed Abdouh Mohamed
('Ahmed', 'Mahmoud'	,NULL	, 'Ahmed', 'ahmed.mahmoud.ahmed@gmail.com', '2005-09-05', 2, 'E456456456', 2),  -- Ahmed Mahmoud Ahmed
('Ahmed', 'Eid'		, NULL	,'Ali', 'ahmed.eid.ali@gmail.com', '2005-02-14', 1, 'F123456789', 1),  -- Ahmed Eid Ali
('El-Sayed', 'Mohamed',NULL	, 'Sayed', 'el.sayed.mohamed.sayed@gmail.com', '2005-05-10', 2, 'G987654321', 2),  -- El-Sayed Mohamed Sayed
('Abrar', 'Mohamed'	,NULL	, 'Ahmed', 'abrar.mohamed.ahmed@gmail.com', '2005-07-20', 1, 'H123123123', 3),  -- Abrar Mohamed Ahmed
('Esraa', 'Eid'		,NULL	, 'Abdel-Sattar', 'esraa.eid.abdel.sattar@gmail.com', '2005-03-15', 1, 'I987987987', 1),  -- Esraa Eid Abdel-Sattar
('Esraa', 'Imad'	,NULL	, 'Abdel-Sattar', 'esraa.imad.abdel.sattar@gmail.com', '2005-12-30', 2, 'J456456456', 2);  -- Esraa Imad Abdel-Sattar

INSERT INTO Users (username, password_hash, is_active, last_login, account_locked, account_locked_until, person_id, user_type_id) VALUES 
('ahmedibrahimsayed', 'hashed_password_1', 1, NULL, 0, NULL, 1, 1),  
('ahmedbassemramadan', 'hashed_password_2', 1, NULL, 0, NULL, 2, 2),  
('ahmedhegazyabdelaal', 'hashed_password_3', 1, NULL, 0, NULL, 3, 1),  
('ahmedabdouhmohamed', 'hashed_password_4', 1, NULL, 0, NULL, 4, 2),  
('ahmedmahmoudahmed', 'hashed_password_5', 1, NULL, 0, NULL, 5, 1),  
('ahmedeidali', 'hashed_password_6', 1, NULL, 0, NULL, 6, 2), 
('elsayedmohamedsayed', 'hashed_password_7', 1, NULL, 0, NULL, 7, 1),  
('abramohamedahmed', 'hashed_password_8', 1, NULL, 0, NULL, 8, 2),  
('esraaeidabdesattar', 'hashed_password_9', 1, NULL, 0, NULL, 9 , 1), 
('esraaimadabdesattar', 'hashed_password_10', 1, NULL, 0, NULL, 10, 2);


INSERT INTO Guests (person_id, loyalty_tier_id, loyalty_points, total_stays, preferred_room_type_id, last_stay_date, communication_preference_id, is_vip, user_id) VALUES 
(1, 1, 0, 0, 1, NULL, 1, 0, 1),  -- Guest for Ahmed Ibrahim Sayed
(2, 2, 0, 0, 2, NULL, 2, 0, 2),  -- Guest for Ahmed Bassem Ramadan
(3, 1, 0, 0, 1, NULL, 1, 0, 3),  -- Guest for Ahmed Hegazy Abdel-Aal
(4, NULL, 0, 0, NULL, NULL, 1, 0, 4),  -- Guest for Ahmed Abdouh Mohamed
(5, 3, 0, 0, 2, NULL, 2, 5, null),  -- Guest for Ahmed Mahmoud Ahmed
(6, 1, 0, 0, 1, NULL, 1, 6, null),  -- Guest for Ahmed Eid Ali
(7, 2, 0, 0, 2, NULL, 2, 7, null),  -- Guest for El-Sayed Mohamed Sayed
(8, 1, 0, 0, 1, NULL, 1, 8, null),  -- Guest for Abrar Mohamed Ahmed
(9, 1, 0, 0, 1, NULL, 1, 9, null),  -- Guest for Esraa Eid Abdel-Sattar
(10, 2, 0, 0, 2, NULL, 2, 10, null);  -- Guest for Esraa Imad Abdel-Sattar

INSERT INTO Position (title, department_id, salary_min, salary_max, qualifications, responsibilities) VALUES 
('Front Desk Manager', 1, 3000.00, 5000.00, 'Bachelor''s degree in Hospitality Management', 'Oversee front desk operations, manage staff, and ensure guest satisfaction.'),
('Housekeeping Supervisor', 2, 2000.00, 3500.00, 'High school diploma or equivalent', 'Supervise housekeeping staff and ensure cleanliness of guest rooms.'),
('Sales Manager', 3, 4000.00, 7000.00, 'Bachelor''s degree in Marketing or Business', 'Develop sales strategies and manage relationships with corporate clients.'),
('Chef', 4, 3500.00, 6000.00, 'Culinary degree or equivalent experience', 'Prepare meals, manage kitchen staff, and ensure food quality.'),
('Maintenance Technician', 5, 2500.00, 4000.00, 'Technical certification or equivalent experience', 'Perform maintenance and repairs on hotel facilities.');



INSERT INTO Phone (phone_number, person_id, is_active) VALUES 
('123-456-7890', 1, 1),
('0987654321', 2, 1),  
('555-5555555', 3, 1), 
('444444-4444', 4, 1), 
('333-333-3333', 5, 1);


INSERT INTO Reservation (guest_id, room_id, check_in_date, check_out_date, actual_check_out_date, payment_id) VALUES 
(1, 1, '2024-12-01 15:00:00', '2024-12-12 11:00:00', NULL, NULL),  -- Reservation for guest 1 in room 101
(2, 2, '2024-12-02 15:00:00', '2024-12-15 11:00:00', NULL, NULL),  -- Reservation for guest 2 in room 102
(3, 3, '2024-12-03 15:00:00', '2024-12-12 11:00:00', NULL, NULL),  -- Reservation for guest 3 in room 103
(4, 4, '2024-12-04 15:00:00', '2024-12-30 11:00:00', NULL, NULL),  -- Reservation for guest 4 in room 104
(5, 5, '2024-12-05 15:00:00', '2024-12-12 11:00:00', NULL, NULL);  -- Reservation for guest 5 in room 105


INSERT INTO Payment (reservation_id, guest_id, amount, payment_method_id, payment_status_id, card_type_id, payment_date, currency_id, note) VALUES 
(1, 1, 500.00, 1, 1, 1, '2023-10-01 14:00:00', 1, 'Paid in full'),  -- Payment for reservation 1
(2, 2, 600.00, 2, 1, 2, '2023-10-02 14:30:00', 1, 'Paid in full'),  -- Payment for reservation 2
(3, 3, 700.00, 1, 1, 1, '2023-10-03 15:00:00', 1, 'Paid in full'),  -- Payment for reservation 3
(4, 4, 800.00, 3, 1,  2, '2023-10-04 15:30:00', 1, 'Paid in full'),  -- Payment for reservation 4
(5, 5, 900.00, 2, 1, 2, '2023-10-05 16:00:00', 1, 'Paid in full');  -- Payment for reservation 5

INSERT INTO Staff (person_id, department_id, position_id, manager_id, salary, employee_type_id, emergency_contact_phone, bank_account_number, performance_rating, employment_status, hire_date, departure_date, user_id) VALUES 
(1, 1, 1, NULL, 3000.00, 1, '123-456-7890', '1234567890123456', 4.5, 1, '2023-01-15', NULL, 1), 
(2, 1, 2, 1, 2500.00, 1, '098-765-4321', '2345678901234567', 4.0, 1, '2023-02-01', NULL, 2), 
(3, 2, 3, 1, 4000.00, 2, '555-555-5555', '3456789012345678', 5.0, 1, '2023-03-10', NULL, 3),  
(4, 2, 4, 2, 3500.00, 1, '444-444-4444', '4567890123456789', 3.5, 1, '2023-04-20', NULL, 4), 
(5, 3, 5, NULL, 4500.00, 2, '333-333-3333', '5678901234567890', 4.8, 1, '2023-05-25', NULL, 5); 




----------------------------------------


-- Get number of visits of each Country and sort them from the higher
SELECT Countries.name, count(Countries.name) As Total_Visists
FROM Countries 
				INNER JOIN	People ON Countries.country_id	= People.country_id 
				INNER JOIN  Guests ON People.person_id		= Guests.person_id
GROUP BY Countries.name
order by Total_Visists desc


-- get total number of reservations in a month in a year
SELECT year(check_in_date), month(check_in_date), count(month(check_in_date))
FROM Reservation
group by year(check_in_date),month(check_in_date)

-- avg age

-- number of visitors right know

-- most favorait room

-- 
