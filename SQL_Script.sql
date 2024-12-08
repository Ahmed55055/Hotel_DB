/*
================================================================================================
================================================================================================
	Index									From Line		To
	--------------------------------------------------------------
	Tables With No Foriegn keys					1		:	156
	Tables With Foriegn keys					165		:	511
	Normal Insert statments						536		:	755
	Select Queries								736		:	858
	Insertion query extracted from dataset		864		:	1380

	---------------------------------------------------------------

	NOTE:
	There is a database design mistakes here and there but didn't realise it untill it's too late

	And To know more about why everything is made like this and what the purpose of all the details
	please visit this GitHub repo to read the documentation: https://github.com/Ahmed55055/Hotel_DB/blob/main/Documentation.md


================================================================================================
================================================================================================
*/

-- Creating Database

-- CREATE DATABASE Hotel_DB;
-- Use Hotel_DB;

--==================================================================================================
---------------------------[		Helper Tables		]-----------------------------------
--==================================================================================================

--Create Countries Table
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
	CONSTRAINT CK_capacity		CHECK (capacity >= 1)
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
    currency_name	NVARCHAR(255) NOT NULL ,
    currency_code	NVARCHAR(10) NOT NULL,
	
	CONSTRAINT PK_Currencies	Primary Key (currency_id),
	CONSTRAINT UC_currency		Unique		(currency_name , currency_code)
);

--==================================================================================================
---------------------------[		Create Main Table			]-----------------------------------
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
-- For more information check Documentation
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
    is_active		BIT				DEFAULT 1,
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

CREATE NONCLUSTERED INDEX idx_person_id
ON Users (person_id);

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
	CONSTRAINT CK_Room_Types_Capacity	CHECK		(capacity >= 1),
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
	-- 1-24			7  digits		4 bytes storage size
	-- 25-53		15 digits		8 bytes storage size

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
    capacity		SMALLINT	NOT NULL, -- unnesasairy denormalization can cause errors and info conflict
    floor			SMALLINT	NOT NULL,
    room_status_id	INT			NOT NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Rooms					Primary Key (room_id),

	--Check
	CONSTRAINT CK_Rooms_capacity		CHECK		(capacity >= 1),	-- Capacity must be positive
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
    performance_rating		FLOAT(24)		DEFAULT 5,	-- 0 To 5
    employment_status		INT				NOT NULL,	-- forgot to make status table for employees
    hire_date				DATETIME		NOT NULL,	-- should'v be Date
    departure_date			DATE			NULL,
    user_id					INT				NOT NULL,

-- CONSTRAINTS
	CONSTRAINT PK_Staff				Primary Key (staff_id),

-- CHECK
	CONSTRAINT CK_salary				CHECK (salary >= 0), -- Salary must be non-negative
	CONSTRAINT CK_performance_rating	CHECK (performance_rating >= 0 AND performance_rating <= 5), -- Rating between 0 and 5
	CONSTRAINT UC_Staff_person_id		Unique (person_id),

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
    payment_date		DATETIME		NOT NULL Default GetDate(),
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







--====================================================================================================
--=============================[		Insert Statments		]=====================================


-- NOTE
-- I got some data from a dataset like (countries, currencies)
-- but i left an insert statment of all the countries on Github If needed

-- And this is how i got the insert statment on the Github
-- select insert_statment = '(''' + name + ''' , '''+ iso_code + ''' , '''+iso_code+'''),' from Countries
 

-------------------------------------------------------------------------------------------------

-- Normal insert Statments

-- Insert Bed Types
INSERT INTO bed_types (type_name, description, capacity) 
VALUES 
('Platform Bed'			, 'A bed with a solid or slatted base that supports a mattress without the need for a box spring.', 2),
('Canopy Bed'			, 'A bed with posts at each corner extending upwards, often draped with fabric.', 2),
('Sleigh Bed'			, 'A bed characterized by curved or scrolled headboards and footboards.', 2),
('Four-Poster Bed'		, 'A bed with four vertical posts, often without fabric draping.', 2),
('Daybed'				, 'A versatile piece that can serve as a sofa or a bed, often with a twin mattress.', 1);


-- Insert Payment Cards Types 
INSERT INTO Card_types (card_name, description) VALUES 
('Visa', 'A widely accepted credit card known for its reliability and security.'),
('MasterCard', 'A popular credit card that offers various benefits and rewards.'),
('American Express', 'A premium credit card known for its travel rewards and customer service.');

-- Insert Communication Way That is Avilable
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

-- Insert Departments For Employees
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

-- Insert Employee's Types
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

-- Insert Identity proofing types
INSERT INTO id_proof_types (proof_type_name) VALUES 
('Passport'),
('Driver''s License'),
('National ID Card'),
('Voter ID'),
('Employee ID'),
('Student ID'),
('Utility Bill'),
('Bank Statement');

-- Insert Users Types And Thier Default permissions
INSERT INTO User_Types (type_name, description, permissions) VALUES 
('Admin', 'Users with full access to all system features and settings.', 1),  -- permissions as a binary flag
('Staff', 'Regular staff members with access to operational features.', 2),
('Guest', 'Users who can book and manage their reservations.', 4),
('Manager', 'Users who oversee specific departments and have managerial access.', 8),
('Maintenance', 'Users responsible for maintenance tasks with limited access.', 16),
('Housekeeping', 'Users who manage room cleaning and maintenance tasks.', 32);

-- Insert Loyalty Tiers
INSERT INTO Loyalty_Tiers (tier_name, min_points) VALUES 
('Bronze', 0),
('Silver', 1000),
('Gold', 5000),
('Platinum', 10000),
('Diamond', 20000);

-- Insert Services
INSERT INTO Services (service_name, description, price_usd) VALUES 
('Room Service', '24-hour room service with a variety of dining options.', 15.00),
('Spa Treatment', 'Relaxing spa services including massages and facials.', 100.00),
('Airport Shuttle', 'Transportation to and from the airport.', 30.00),
('Laundry Service', 'Same-day laundry and dry cleaning services.', 20.00),
('Concierge Services', 'Personalized assistance for reservations and recommendations.', 10.00),
('Gym Access', 'Access to the hotel gym and fitness facilities.', 5.00);

-- insert diffrant rooms status
INSERT INTO room_status (status, description) VALUES 
('Available', 'Room is available for booking.'),
('Occupied', 'Room is currently occupied by a guest.'),
('Under Maintenance', 'Room is undergoing maintenance and cannot be booked.'),
('Clean', 'Room has been cleaned and is ready for the next guest.'),
('Dirty', 'Room needs cleaning after guest checkout.'),
('Reserved', 'Room has been reserved but not yet checked in.');

-- insert payment methods we accept
INSERT INTO Payment_Methods (method_name, description) VALUES 
('Credit Card', 'Payment made using a credit card.'),
('Debit Card', 'Payment made using a debit card.'),
('Cash', 'Payment made in cash at the hotel.'),
('Online Payment', 'Payment made through online banking or payment gateways.'),
('Mobile Payment', 'Payment made using mobile payment applications (e.g., Apple Pay, Google Pay).');

-- insert payment status
INSERT INTO Payment_Status (status_name, description) VALUES 
('Pending', 'Payment is pending and has not been completed.'),
('Completed', 'Payment has been successfully completed.'),
('Failed', 'Payment attempt has failed.'),
('Refunded', 'Payment has been refunded to the guest.'),
('Cancelled', 'Payment has been cancelled by the guest or the hotel.');

-- insert rooms types
INSERT INTO Room_Types (bed_type_id, capacity, wifi, internet_speed_MB, tv, work_desk, balcony, refrigerator, coffee_maker, safe, room_orientation, base_price_rate) VALUES 
(1, 2, 1, 100.0, 1, 1, 1, 1, 1, 1, 'Ocean View', 150.00),
(2, 4, 1, 50.0, 1, 1, 0, 1, 1, 1, 'City View', 250.00),
(3, 1, 1, 10.0, 0, 0, 0, 0, 0, 1, 'Garden View', 100.00),
(1, 3, 1, 75.0, 1, 1, 1, 0, 1, 0, 'Mountain View', 200.00),
(2, 2, 0, NULL, 1, 0, 0, 1, 0, 1, 'Pool View', 180.00);

-- insert benefits of loyalty tiers
INSERT INTO Loyalty_Benefits (loyalty_tier_id, service_id, discount_percentage, points) VALUES 
(1, 1, 5.0, 100),  -- Bronze tier		benefit for Room Service
(2, 2, 10.0, 200), -- Silver tier		benefit for Spa Treatment
(3, 3, 15.0, 300), -- Gold tier			benefit for Airport Shuttle
(4, 4, 20.0, 400), -- Platinum tier		benefit for Laundry Service
(4, 5, 20.0, 400), -- Platinum tier		benefit for Concierge Service
(5, 2, 25.0, 500), -- Diamond tier		benefit for Spa Services
(5, 5, 25.0, 500); -- Diamond tier		benefit for Concierge Services

-- insert rooms (room status insertion is up)
INSERT INTO Rooms (room_type_id, capacity, floor, room_status_id) VALUES 
(1, 2, 1, 1),  -- Room Type ID 1,	Capacity 2,		Floor 1,	Status ID 1 (Available)
(2, 4, 2, 2),  -- Room Type ID 2,	Capacity 4,		Floor 2,	Status ID 2 (Occupied)
(3, 1, 1, 3),  -- Room Type ID 3,	Capacity 1,		Floor 1,	Status ID 3 (Under Maintenance)
(1, 3, 3, 4),  -- Room Type ID 1,	Capacity 3,		Floor 3,	Status ID 4 (Clean)
(2, 2, 2, 5);  -- Room Type ID 2,	Capacity 2,		Floor 2,	Status ID 5 (Dirty)

-- insert people
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

-- insert users
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

-- insert guests
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

-- insert employees positions
INSERT INTO Position (title, department_id, salary_min, salary_max, qualifications, responsibilities) VALUES 
('Front Desk Manager', 1, 3000.00, 5000.00, 'Bachelor''s degree in Hospitality Management', 'Oversee front desk operations, manage staff, and ensure guest satisfaction.'),
('Housekeeping Supervisor', 2, 2000.00, 3500.00, 'High school diploma or equivalent', 'Supervise housekeeping staff and ensure cleanliness of guest rooms.'),
('Sales Manager', 3, 4000.00, 7000.00, 'Bachelor''s degree in Marketing or Business', 'Develop sales strategies and manage relationships with corporate clients.'),
('Chef', 4, 3500.00, 6000.00, 'Culinary degree or equivalent experience', 'Prepare meals, manage kitchen staff, and ensure food quality.'),
('Maintenance Technician', 5, 2500.00, 4000.00, 'Technical certification or equivalent experience', 'Perform maintenance and repairs on hotel facilities.');

-- insert phone numbers
INSERT INTO Phone (phone_number, person_id, is_active) VALUES 
('123-456-7890', 1, 1),
('0987654321', 2, 1),  
('555-5555555', 3, 1), 
('444444-4444', 4, 1), 
('333-333-3333', 5, 1);

-- insert reservation
INSERT INTO Reservation (guest_id, room_id, check_in_date, check_out_date, actual_check_out_date, payment_id) VALUES 
(1, 1, '2024-12-01 15:00:00', '2024-12-12 11:00:00', NULL, NULL),  -- Reservation for guest 1 in room 1
(2, 2, '2024-12-02 15:00:00', '2024-12-15 11:00:00', NULL, NULL),  -- Reservation for guest 2 in room 2
(3, 3, '2024-12-03 15:00:00', '2024-12-12 11:00:00', NULL, NULL),  -- Reservation for guest 3 in room 3
(4, 4, '2024-12-04 15:00:00', '2024-12-30 11:00:00', NULL, NULL),  -- Reservation for guest 4 in room 4
(5, 5, '2024-12-05 15:00:00', '2024-12-12 11:00:00', NULL, NULL);  -- Reservation for guest 5 in room 5

-- insert payments
INSERT INTO Payment (reservation_id, guest_id, amount, payment_method_id, payment_status_id, card_type_id, payment_date, currency_id, note) VALUES 
(1, 1, 500.00, 1, 1, 1, '2023-10-01 14:00:00', 1, 'Paid in full'),  -- Payment for reservation 1
(2, 2, 600.00, 2, 1, 2, '2023-10-02 14:30:00', 1, 'Paid in full'),  -- Payment for reservation 2
(3, 3, 700.00, 1, 1, 1, '2023-10-03 15:00:00', 1, 'Paid in full'),  -- Payment for reservation 3
(4, 4, 800.00, 3, 1,  2, '2023-10-04 15:30:00', 1, 'Paid in full'),  -- Payment for reservation 4
(5, 5, 900.00, 2, 1, 2, '2023-10-05 16:00:00', 1, 'Paid in full');  -- Payment for reservation 5

-- insert employees 
INSERT INTO Staff (person_id, department_id, position_id, manager_id, salary, employee_type_id, emergency_contact_phone, bank_account_number, performance_rating, employment_status, hire_date, departure_date, user_id) VALUES 
(1, 1, 1, NULL, 3000.00, 1, '123-456-7890', '1234567890123456', 4.5, 1, '2023-01-15', NULL, 1), 
(2, 1, 2, 1, 2500.00, 1, '098-765-4321', '2345678901234567', 4.0, 1, '2023-02-01', NULL, 2), 
(3, 2, 3, 1, 4000.00, 2, '555-555-5555', '3456789012345678', 5.0, 1, '2023-03-10', NULL, 3),  
(4, 2, 4, 2, 3500.00, 1, '444-444-4444', '4567890123456789', 3.5, 1, '2023-04-20', NULL, 4), 
(5, 3, 5, NULL, 4500.00, 2, '333-333-3333', '5678901234567890', 4.8, 1, '2023-05-25', NULL, 5); 



--SELECT QUERIES
----------------------------------------


-- get person information by email

-- this query is tested on a database with the people table is over 9,000,000 records and
-- users table is 155,000 record
-- the improvment of making index for Users.person_id is 
-- reducing excution time from 13,000 microsocond to 81 microsocond 16,000% improvment
-- this code is maybe a simulation of login atempt or searching for a person by email
SELECT People.first_name,People.last_name,Users.username, People.email
FROM Users inner JOIN
   People ON Users.person_id = People.person_id
   where People.email = 'olivia.wilson@42E264EC-6991-438E-90BB-E19FA7B621C5.com';


-------------------------------------

-- Get number of visits of each Country and sort them from the higher
SELECT Countries.name, count(Countries.name) As Total_Visists
FROM Countries 
				INNER JOIN	People	ON Countries.country_id		= People.country_id 
				INNER JOIN  Guests	ON People.person_id			= Guests.person_id
GROUP BY Countries.name
order by Total_Visists desc


-------------------------------------

-- get total number of reservations in a month in a year and sort them from the higher
SELECT	year(check_in_date)			AS Year,
		month(check_in_date)		As Month,
		count(month(check_in_date))	As Number_of_visitors

FROM Reservation
	group by year(check_in_date),month(check_in_date)
	Order by Number_of_visitors desc


-------------------------------------

-- Get Average, Min, Max age of geusts in thier last visit
SELECT  AVG(DATEDIFF(Year,People.date_of_birth,Guests.last_stay_date))As AVG_Age,
		MAX(DATEDIFF(Year,People.date_of_birth,Guests.last_stay_date))As Max_Age,
		Min(DATEDIFF(Year,People.date_of_birth,Guests.last_stay_date))As Min_Age
FROM Guests INNER JOIN
   People ON Guests.person_id = People.person_id
   WHERE Guests.last_stay_date IS NOT NULL

-------------------------------------

-- Number of visitors checked in right know
SELECT count(check_in_date)
FROM Reservation
	where GetDate() between check_in_date AND check_out_date
	And check_in_date IS NOT NULL

-------------------------------------

-- Visited room Type
SELECT Rooms.room_type_id, Count(Reservation.room_id) As Visiting_Times
FROM Reservation INNER JOIN Rooms ON Reservation.room_id = Rooms.room_id
   Group by Rooms.room_type_id
   Order By Visiting_Times desc

-------------------------------------

--get total income of the year and how many payments preformed in this year
SELECT Year(Payment.payment_date)As Year, FLOOR(sum( Payment.amount ))AS Income, Count(Payment.amount)AS Total_payments  FROM Payment
group by Year(Payment.payment_date)
order by income desc

-------------------------------------

-- the can be view to get the data to the receptionist
SELECT People.first_name, People.second_name, People.third_name, People.last_name, People.email, Users.username, People.date_of_birth, Guests.last_stay_date, Guests.loyalty_tier_id, Room_Types.room_type_id
FROM People 
			LEFT JOIN Countries ON Countries.country_id = People.country_id 
			INNER JOIN Guests ON People.person_id = Guests.person_id 
			LEFT JOIN Users ON People.person_id = Users.person_id AND Guests.user_id = Users.user_id 
			INNER JOIN Room_Types ON Guests.preferred_room_type_id = Room_Types.room_type_id
order by username desc

-------------------------------------

-- select guests with Loyalty_Tiers from the higher (diamond) to lower (bronze)
SELECT People.first_name, People.last_name, People.email, Loyalty_Tiers.tier_name
FROM Loyalty_Tiers 
		INNER JOIN Guests ON Loyalty_Tiers.loyalty_tier_id	= Guests.loyalty_tier_id 
		INNER JOIN People ON Guests.person_id				= People.person_id
order by Loyalty_Tiers.loyalty_tier_id desc

-------------------------------------

-- get Available Rooms
SELECT Rooms.room_id, Rooms.floor, room_status.status
FROM Rooms INNER JOIN
   room_status ON Rooms.room_status_id = room_status.room_status_id
   where Rooms.room_status_id = 1 -- Available


   -------------------------------------------------------------------------------------------
--contries insert data

insert into Countries (name,country_code,iso_code)
values
('Afghanistan' , 'AFG' , 'AFG'),
('Albania' , 'ALB' , 'ALB'),
('Algeria' , 'DZA' , 'DZA'),
('Andorra' , 'AND' , 'AND'),
('Angola' , 'AGO' , 'AGO'),
('Antarctica' , 'ATA' , 'ATA'),
('Antigua and Barb.' , 'ATG' , 'ATG'),
('Argentina' , 'ARG' , 'ARG'),
('Armenia' , 'ARM' , 'ARM'),
('Australia' , 'AUS' , 'AUS'),
('Austria' , 'AUT' , 'AUT'),
('Azerbaijan' , 'AZE' , 'AZE'),
('Bahamas' , 'BHS' , 'BHS'),
('Bahrain' , 'BHR' , 'BHR'),
('Bangladesh' , 'BGD' , 'BGD'),
('Barbados' , 'BRB' , 'BRB'),
('Belarus' , 'BLR' , 'BLR'),
('Belgium' , 'BEL' , 'BEL'),
('Belize' , 'BLZ' , 'BLZ'),
('Benin' , 'BEN' , 'BEN'),
('Bhutan' , 'BTN' , 'BTN'),
('Bolivia' , 'BOL' , 'BOL'),
('Bosnia and Herz.' , 'BIH' , 'BIH'),
('Botswana' , 'BWA' , 'BWA'),
('Brazil' , 'BRA' , 'BRA'),
('Brunei' , 'BRN' , 'BRN'),
('Bulgaria' , 'BGR' , 'BGR'),
('Burkina Faso' , 'BFA' , 'BFA'),
('Burundi' , 'BDI' , 'BDI'),
('Cabo Verde' , 'CPV' , 'CPV'),
('Cambodia' , 'KHM' , 'KHM'),
('Cameroon' , 'CMR' , 'CMR'),
('Canada' , 'CAN' , 'CAN'),
('Central African Rep.' , 'CAF' , 'CAF'),
('Chad' , 'TCD' , 'TCD'),
('Chile' , 'CHL' , 'CHL'),
('China' , 'CHN' , 'CHN'),
('Colombia' , 'COL' , 'COL'),
('Comoros' , 'COM' , 'COM'),
('Congo' , 'COG' , 'COG'),
('Costa Rica' , 'CRI' , 'CRI'),
('Côte d''Ivoire' , 'CIV' , 'CIV'),
('Croatia' , 'HRV' , 'HRV'),
('Cuba' , 'CUB' , 'CUB'),
('Cyprus' , 'CYP' , 'CYP'),
('Czechia' , 'CZE' , 'CZE'),
('Dem. Rep. Congo' , 'COD' , 'COD'),
('Denmark' , 'DNK' , 'DNK'),
('Djibouti' , 'DJI' , 'DJI'),
('Dominica' , 'DMA' , 'DMA'),
('Dominican Rep.' , 'DOM' , 'DOM'),
('Ecuador' , 'ECU' , 'ECU'),
('Egypt' , 'EGY' , 'EGY'),
('El Salvador' , 'SLV' , 'SLV'),
('Eq. Guinea' , 'GNQ' , 'GNQ'),
('Eritrea' , 'ERI' , 'ERI'),
('Estonia' , 'EST' , 'EST'),
('eSwatini' , 'SWZ' , 'SWZ'),
('Ethiopia' , 'ETH' , 'ETH'),
('Fiji' , 'FJI' , 'FJI'),
('Finland' , 'FIN' , 'FIN'),
('France' , 'FRA' , 'FRA'),
('Gabon' , 'GAB' , 'GAB'),
('Gambia' , 'GMB' , 'GMB'),
('Georgia' , 'GEO' , 'GEO'),
('Germany' , 'DEU' , 'DEU'),
('Ghana' , 'GHA' , 'GHA'),
('Greece' , 'GRC' , 'GRC'),
('Grenada' , 'GRD' , 'GRD'),
('Guatemala' , 'GTM' , 'GTM'),
('Guinea' , 'GIN' , 'GIN'),
('Guinea-Bissau' , 'GNB' , 'GNB'),
('Guyana' , 'GUY' , 'GUY'),
('Haiti' , 'HTI' , 'HTI'),
('Honduras' , 'HND' , 'HND'),
('Hungary' , 'HUN' , 'HUN'),
('Iceland' , 'ISL' , 'ISL'),
('India' , 'IND' , 'IND'),
('Indonesia' , 'IDN' , 'IDN'),
('Iran' , 'IRN' , 'IRN'),
('Iraq' , 'IRQ' , 'IRQ'),
('Ireland' , 'IRL' , 'IRL'),
('Israel' , 'ISR' , 'ISR'),
('Italy' , 'ITA' , 'ITA'),
('Jamaica' , 'JAM' , 'JAM'),
('Japan' , 'JPN' , 'JPN'),
('Jordan' , 'JOR' , 'JOR'),
('Kazakhstan' , 'KAZ' , 'KAZ'),
('Kenya' , 'KEN' , 'KEN'),
('Kiribati' , 'KIR' , 'KIR'),
('Kosovo' , 'XKX' , 'XKX'),
('Kuwait' , 'KWT' , 'KWT'),
('Kyrgyzstan' , 'KGZ' , 'KGZ'),
('Laos' , 'LAO' , 'LAO'),
('Latvia' , 'LVA' , 'LVA'),
('Lebanon' , 'LBN' , 'LBN'),
('Lesotho' , 'LSO' , 'LSO'),
('Liberia' , 'LBR' , 'LBR'),
('Libya' , 'LBY' , 'LBY'),
('Liechtenstein' , 'LIE' , 'LIE'),
('Lithuania' , 'LTU' , 'LTU'),
('Luxembourg' , 'LUX' , 'LUX'),
('Madagascar' , 'MDG' , 'MDG'),
('Malawi' , 'MWI' , 'MWI'),
('Malaysia' , 'MYS' , 'MYS'),
('Maldives' , 'MDV' , 'MDV'),
('Mali' , 'MLI' , 'MLI'),
('Malta' , 'MLT' , 'MLT'),
('Marshall Is.' , 'MHL' , 'MHL'),
('Mauritania' , 'MRT' , 'MRT'),
('Mauritius' , 'MUS' , 'MUS'),
('Mexico' , 'MEX' , 'MEX'),
('Micronesia' , 'FSM' , 'FSM'),
('Moldova' , 'MDA' , 'MDA'),
('Monaco' , 'MCO' , 'MCO'),
('Mongolia' , 'MNG' , 'MNG'),
('Montenegro' , 'MNE' , 'MNE'),
('Morocco' , 'MAR' , 'MAR'),
('Mozambique' , 'MOZ' , 'MOZ'),
('Myanmar' , 'MMR' , 'MMR'),
('Namibia' , 'NAM' , 'NAM'),
('Nauru' , 'NRU' , 'NRU'),
('Nepal' , 'NPL' , 'NPL'),
('Netherlands' , 'NLD' , 'NLD'),
('New Zealand' , 'NZL' , 'NZL'),
('Nicaragua' , 'NIC' , 'NIC'),
('Niger' , 'NER' , 'NER'),
('Nigeria' , 'NGA' , 'NGA'),
('North Korea' , 'PRK' , 'PRK'),
('North Macedonia' , 'MKD' , 'MKD'),
('Norway' , 'NOR' , 'NOR'),
('Oman' , 'OMN' , 'OMN'),
('Pakistan' , 'PAK' , 'PAK'),
('Palau' , 'PLW' , 'PLW'),
('Panama' , 'PAN' , 'PAN'),
('Papua New Guinea' , 'PNG' , 'PNG'),
('Paraguay' , 'PRY' , 'PRY'),
('Peru' , 'PER' , 'PER'),
('Philippines' , 'PHL' , 'PHL'),
('Poland' , 'POL' , 'POL'),
('Portugal' , 'PRT' , 'PRT'),
('Qatar' , 'QAT' , 'QAT'),
('Romania' , 'ROU' , 'ROU'),
('Russia' , 'RUS' , 'RUS'),
('Rwanda' , 'RWA' , 'RWA'),
('S. Sudan' , 'SSD' , 'SSD'),
('Saint Lucia' , 'LCA' , 'LCA'),
('Samoa' , 'WSM' , 'WSM'),
('San Marino' , 'SMR' , 'SMR'),
('São Tomé and Principe' , 'STP' , 'STP'),
('Saudi Arabia' , 'SAU' , 'SAU'),
('Senegal' , 'SEN' , 'SEN'),
('Serbia' , 'SRB' , 'SRB'),
('Seychelles' , 'SYC' , 'SYC'),
('Sierra Leone' , 'SLE' , 'SLE'),
('Singapore' , 'SGP' , 'SGP'),
('Slovakia' , 'SVK' , 'SVK'),
('Slovenia' , 'SVN' , 'SVN'),
('Solomon Is.' , 'SLB' , 'SLB'),
('Somalia' , 'SOM' , 'SOM'),
('South Africa' , 'ZAF' , 'ZAF'),
('South Korea' , 'KOR' , 'KOR'),
('Spain' , 'ESP' , 'ESP'),
('Sri Lanka' , 'LKA' , 'LKA'),
('St. Kitts and Nevis' , 'KNA' , 'KNA'),
('St. Vin. and Gren.' , 'VCT' , 'VCT'),
('Sudan' , 'SDN' , 'SDN'),
('Suriname' , 'SUR' , 'SUR'),
('Sweden' , 'SWE' , 'SWE'),
('Switzerland' , 'CHE' , 'CHE'),
('Syria' , 'SYR' , 'SYR'),
('Taiwan' , 'TWN' , 'TWN'),
('Tajikistan' , 'TJK' , 'TJK'),
('Tanzania' , 'TZA' , 'TZA'),
('Thailand' , 'THA' , 'THA'),
('Timor-Leste' , 'TLS' , 'TLS'),
('Togo' , 'TGO' , 'TGO'),
('Tonga' , 'TON' , 'TON'),
('Trinidad and Tobago' , 'TTO' , 'TTO'),
('Tunisia' , 'TUN' , 'TUN'),
('Turkey' , 'TUR' , 'TUR'),
('Turkmenistan' , 'TKM' , 'TKM'),
('Tuvalu' , 'TUV' , 'TUV'),
('Uganda' , 'UGA' , 'UGA'),
('Ukraine' , 'UKR' , 'UKR'),
('United Arab Emirates' , 'ARE' , 'ARE'),
('United Kingdom' , 'GBR' , 'GBR'),
('United States of America' , 'USA' , 'USA'),
('Uruguay' , 'URY' , 'URY'),
('Uzbekistan' , 'UZB' , 'UZB'),
('Vanuatu' , 'VUT' , 'VUT'),
('Vatican' , 'VAT' , 'VAT'),
('Venezuela' , 'VEN' , 'VEN'),
('Vietnam' , 'VNM' , 'VNM'),
('W. Sahara' , 'ESH' , 'ESH'),
('Yemen' , 'YEM' , 'YEM'),
('Zambia' , 'ZMB' , 'ZMB'),
('Zimbabwe' , 'ZWE' , 'ZWE');


-- insert Currencies data
Insert Into Currencies (currency_name, currency_code)
values
('"A" Account (convertible Peseta Account)' , 'ESB'),
('ADB Unit of Account' , 'XUA'),
('Afghani' , 'AFA'),
('Afghani' , 'AFN'),
('Algerian Dinar' , 'DZD'),
('Andorran Peseta' , 'ADP'),
('Argentine Peso' , 'ARS'),
('Armenian Dram' , 'AMD'),
('Aruban Florin' , 'AWG'),
('Austral' , 'ARA'),
('Australian Dollar' , 'AUD'),
('Azerbaijan Manat' , 'AYM'),
('Azerbaijan Manat' , 'AZN'),
('Azerbaijanian Manat' , 'AZM'),
('Bahamian Dollar' , 'BSD'),
('Bahraini Dinar' , 'BHD'),
('Baht' , 'THB'),
('Balboa' , 'PAB'),
('Barbados Dollar' , 'BBD'),
('Belarusian Ruble' , 'BYB'),
('Belarusian Ruble' , 'BYN'),
('Belarusian Ruble' , 'BYR'),
('Belgian Franc' , 'BEF'),
('Belize Dollar' , 'BZD'),
('Bermudian Dollar' , 'BMD'),
('BolÃ­var' , 'VEF'),
('BolÃ­var Soberano' , 'VED'),
('BolÃ­var Soberano' , 'VES'),
('Bolivar' , 'VEB'),
('Bolivar' , 'VEF'),
('Bolivar Fuerte' , 'VEF'),
('Boliviano' , 'BOB'),
('Bond Markets Unit European Composite Unit (EURCO)' , 'XBA'),
('Bond Markets Unit European Monetary Unit (E.M.U.-6)' , 'XBB'),
('Bond Markets Unit European Unit of Account 17 (E.U.A.-17)' , 'XBD'),
('Bond Markets Unit European Unit of Account 9 (E.U.A.-9)' , 'XBC'),
('Brazilian Real' , 'BRL'),
('Brunei Dollar' , 'BND'),
('Bulgarian Lev' , 'BGN'),
('Burundi Franc' , 'BIF'),
('Cabo Verde Escudo' , 'CVE'),
('Canadian Dollar' , 'CAD'),
('Cayman Islands Dollar' , 'KYD'),
('Cedi' , 'GHC'),
('CFA Franc BCEAO' , 'XOF'),
('CFA Franc BEAC' , 'XAF'),
('CFP Franc' , 'XPF'),
('Chilean Peso' , 'CLP'),
('Colombian Peso' , 'COP'),
('Comorian Franc' , 'KMF'),
('Congolese Franc' , 'CDF'),
('Convertible Franc' , 'BEC'),
('Convertible Mark' , 'BAM'),
('Cordoba' , 'NIC'),
('Cordoba Oro' , 'NIO'),
('Costa Rican Colon' , 'CRC'),
('Croatian Dinar' , 'HRD'),
('Croatian Kuna' , 'HRK'),
('Cruzado' , 'BRC'),
('Cruzeiro' , 'BRB'),
('Cruzeiro' , 'BRE'),
('Cruzeiro Real' , 'BRR'),
('Cuban Peso' , 'CUP'),
('Cyprus Pound' , 'CYP'),
('Czech Koruna' , 'CZK'),
('Dalasi' , 'GMD'),
('Danish Krone' , 'DKK'),
('Denar' , 'MKD'),
('Deutsche Mark' , 'DEM'),
('Dinar' , 'BAD'),
('Djibouti Franc' , 'DJF'),
('Dobra' , 'STD'),
('Dobra' , 'STN'),
('Dominican Peso' , 'DOP'),
('Dong' , 'VND'),
('Drachma' , 'GRD'),
('East Caribbean Dollar' , 'XCD'),
('Egyptian Pound' , 'EGP'),
('Ekwele' , 'GQE'),
('El Salvador Colon' , 'SVC'),
('Ethiopian Birr' , 'ETB'),
('Euro' , 'EUR'),
('European Currency Unit (E.C.U)' , 'XEU'),
('Falkland Islands Pound' , 'FKP'),
('Fiji Dollar' , 'FJD'),
('Financial Franc' , 'BEL'),
('Financial Rand' , 'ZAL'),
('Forint' , 'HUF'),
('French Franc' , 'FRF'),
('Georgian Coupon' , 'GEK'),
('Ghana Cedi' , 'GHP'),
('Ghana Cedi' , 'GHS'),
('Gibraltar Pound' , 'GIP'),
('Gold' , 'XAU'),
('Gold-Franc' , 'XFO'),
('Gourde' , 'HTG'),
('Guarani' , 'PYG'),
('Guinea Escudo' , 'GWE'),
('Guinea-Bissau Peso' , 'GWP'),
('Guinean Franc' , 'GNF'),
('Guyana Dollar' , 'GYD'),
('Hong Kong Dollar' , 'HKD'),
('Hryvnia' , 'UAH'),
('Iceland Krona' , 'ISK'),
('Indian Rupee' , 'INR'),
('Inti' , 'PEI'),
('Iranian Rial' , 'IRR'),
('Iraqi Dinar' , 'IQD'),
('Irish Pound' , 'IEP'),
('Italian Lira' , 'ITL'),
('Jamaican Dollar' , 'JMD'),
('Jordanian Dinar' , 'JOD'),
('Karbovanet' , 'UAK'),
('Kenyan Shilling' , 'KES'),
('Kina' , 'PGK'),
('Koruna' , 'CSK'),
('Krona A/53' , 'CSJ'),
('Kroon' , 'EEK'),
('Kuna' , 'HRK'),
('Kuwaiti Dinar' , 'KWD'),
('Kwacha' , 'MWK'),
('Kwanza' , 'AOA'),
('Kwanza' , 'AOK'),
('Kwanza Reajustado' , 'AOR'),
('Kyat' , 'BUK'),
('Kyat' , 'MMK'),
('Lao Kip' , 'LAK'),
('Lari' , 'GEL'),
('Latvian Lats' , 'LVL'),
('Latvian Ruble' , 'LVR'),
('Lebanese Pound' , 'LBP'),
('Lek' , 'ALL'),
('Lempira' , 'HNL'),
('Leone' , 'SLE'),
('Leone' , 'SLL'),
('Leu A/52' , 'ROK'),
('Lev' , 'BGL'),
('Lev A/52' , 'BGJ'),
('Lev A/62' , 'BGK'),
('Liberian Dollar' , 'LRD'),
('Libyan Dinar' , 'LYD'),
('Lilangeni' , 'SZL'),
('Lithuanian Litas' , 'LTL'),
('Loti' , 'LSL'),
('Loti' , 'LSM'),
('Luxembourg Convertible Franc' , 'LUC'),
('Luxembourg Financial Franc' , 'LUL'),
('Luxembourg Franc' , 'LUF'),
('Malagasy Ariary' , 'MGA'),
('Malagasy Franc' , 'MGF'),
('Malawi Kwacha' , 'MWK'),
('Malaysian Ringgit' , 'MYR'),
('Maldive Rupee' , 'MVQ'),
('Mali Franc' , 'MLF'),
('Maltese Lira' , 'MTL'),
('Maltese Pound' , 'MTP'),
('Mark der DDR' , 'DDM'),
('Markka' , 'FIM'),
('Mauritius Rupee' , 'MUR'),
('Mexican Peso' , 'MXN'),
('Mexican Peso' , 'MXP'),
('Mexican Unidad de Inversion (UDI)' , 'MXV'),
('Moldovan Leu' , 'MDL'),
('Moroccan Dirham' , 'MAD'),
('Mozambique Escudo' , 'MZE'),
('Mozambique Metical' , 'MZM'),
('Mozambique Metical' , 'MZN'),
('Mvdol' , 'BOV'),
('Naira' , 'NGN'),
('Nakfa' , 'ERN'),
('Namibia Dollar' , 'NAD'),
('Nepalese Rupee' , 'NPR'),
('Netherlands Antillean Guilder' , 'ANG'),
('Netherlands Guilder' , 'NLG'),
('New Cruzado' , 'BRN'),
('New Dinar' , 'YUM'),
('New Israeli Sheqel' , 'ILS'),
('New Kwanza' , 'AON'),
('New Romanian Leu' , 'RON'),
('New Taiwan Dollar' , 'TWD'),
('New Turkish Lira' , 'TRY'),
('New Yugoslavian Dinar' , 'YUD'),
('New Zaire' , 'ZRN'),
('New Zealand Dollar' , 'NZD'),
('Ngultrum' , 'BTN'),
('North Korean Won' , 'KPW'),
('Norwegian Krone' , 'NOK'),
('Nuevo Sol' , 'PEN'),
('Old Dong' , 'VNC'),
('Old Krona' , 'ISJ'),
('Old Lek' , 'ALK'),
('Old Leu' , 'ROL'),
('Old Shekel' , 'ILR'),
('Old Shilling' , 'UGW'),
('Old Turkish Lira' , 'TRL'),
('Old Uruguay Peso' , 'UYN'),
('Ouguiya' , 'MRO'),
('Ouguiya' , 'MRU'),
('Paâanga' , 'TOP'),
('Pakistan Rupee' , 'PKR'),
('Palladium' , 'XPD'),
('Pataca' , 'MOP'),
('Pathet Lao Kip' , 'LAJ'),
('Peso' , 'ARY'),
('Peso Argentino' , 'ARP'),
('Peso boliviano' , 'BOP'),
('Peso Convertible' , 'CUC'),
('Peso Uruguayo' , 'UYU'),
('Philippine Peso' , 'PHP'),
('Platinum' , 'XPT'),
('Portuguese Escudo' , 'PTE'),
('Pound' , 'ILP'),
('Pound Sterling' , 'GBP'),
('Pula' , 'BWP'),
('Qatari Rial' , 'QAR'),
('Quetzal' , 'GTQ'),
('Rand' , 'ZAR'),
('Rhodesian Dollar' , 'RHD'),
('Rhodesian Dollar' , 'ZWC'),
('Rial Omani' , 'OMR'),
('Riel' , 'KHR'),
('RINET Funds Code' , 'XRE'),
('Romanian Leu' , 'RON'),
('Rouble' , 'SUR'),
('Rufiyaa' , 'MVR'),
('Rupiah' , 'IDR'),
('Russian Ruble' , 'RUB'),
('Russian Ruble' , 'RUR'),
('Rwanda Franc' , 'RWF'),
('Saint Helena Pound' , 'SHP'),
('Saudi Riyal' , 'SAR'),
('Schilling' , 'ATS'),
('SDR (Special Drawing Right)' , 'XDR'),
('Serbian Dinar' , 'CSD'),
('Serbian Dinar' , 'RSD'),
('Seychelles Rupee' , 'SCR'),
('Silver' , 'XAG'),
('Singapore Dollar' , 'SGD'),
('Slovak Koruna' , 'SKK'),
('Sol' , 'PEH'),
('Sol' , 'PEN'),
('Sol' , 'PES'),
('Solomon Islands Dollar' , 'SBD'),
('Som' , 'KGS'),
('Somali Shilling' , 'SOS'),
('Somoni' , 'TJS'),
('South Sudanese Pound' , 'SSP'),
('Spanish Peseta' , 'ESA'),
('Spanish Peseta' , 'ESP'),
('Sri Lanka Rupee' , 'LKR'),
('Sucre' , 'ECS'),
('Sucre' , 'XSU'),
('Sudanese Dinar' , 'SDD'),
('Sudanese Pound' , 'SDG'),
('Sudanese Pound' , 'SDP'),
('Surinam Dollar' , 'SRD'),
('Surinam Guilder' , 'SRG'),
('Swedish Krona' , 'SEK'),
('Swiss Franc' , 'CHF'),
('Syli' , 'GNE'),
('Syli' , 'GNS'),
('Syrian Pound' , 'SYP'),
('Tajik Ruble' , 'TJR'),
('Taka' , 'BDT'),
('Tala' , 'WST'),
('Talonas' , 'LTT'),
('Tanzanian Shilling' , 'TZS'),
('Tenge' , 'KZT'),
('The codes assigned for transactions where no currency is involved' , 'XXX'),
('Timor Escudo' , 'TPE'),
('Tolar' , 'SIT'),
('Trinidad and Tobago Dollar' , 'TTD'),
('Tugrik' , 'MNT'),
('Tunisian Dinar' , 'TND'),
('Turkish Lira' , 'TRY'),
('Turkmenistan Manat' , 'TMM'),
('Turkmenistan New Manat' , 'TMT'),
('UAE Dirham' , 'AED'),
('Uganda Shilling' , 'UGS'),
('Uganda Shilling' , 'UGX'),
('UIC-Franc' , 'XFU'),
('Unidad de Fomento' , 'CLF'),
('Unidad de Valor Constante (UVC)' , 'ECV'),
('Unidad de Valor Real' , 'COU'),
('Unidad Previsional' , 'UYW'),
('Uruguay Peso en Unidades Indexadas (UI)' , 'UYI'),
('Uruguayan Peso' , 'UYP'),
('US Dollar' , 'USD'),
('US Dollar (Next day)' , 'USN'),
('US Dollar (Same day)' , 'USS'),
('Uzbekistan Sum' , 'UZS'),
('Vatu' , 'VUV'),
('WIR Euro' , 'CHE'),
('WIR Franc' , 'CHW'),
('WIR Franc (for electronic)' , 'CHC'),
('Won' , 'KRW'),
('Yemeni Dinar' , 'YDD'),
('Yemeni Rial' , 'YER'),
('Yen' , 'JPY'),
('Yuan Renminbi' , 'CNY'),
('Yugoslavian Dinar' , 'YUN'),
('Zaire' , 'ZRZ'),
('Zambian Kwacha' , 'ZMK'),
('Zambian Kwacha' , 'ZMW'),
('Zimbabwe Dollar' , 'ZWD'),
('Zimbabwe Dollar' , 'ZWL'),
('Zimbabwe Dollar' , 'ZWR'),
('Zimbabwe Dollar (new)' , 'ZWN'),
('Zimbabwe Dollar (old)' , 'ZWD'),
('Zimbabwe Gold' , 'ZWG'),
('Zloty' , 'PLN'),
('Zloty' , 'PLZ')

