
--================================================================================================
--================================================================================================
--	Creating tables code is not heavily commented because it's self-descriptive
--	To know more about why everything is made like this and what the purpose of all the details
--	please visit this GitHub repo to read the documentation: 

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
    country_id		INT PRIMARY	KEY IDENTITY(1,1),
    name			NVARCHAR(255)	NOT NULL,
    country_code	NVARCHAR(10)	NOT NULL,
    iso_code		NVARCHAR(10)	NOT NULL
);

-- Create ID Proof Types Table
CREATE TABLE id_proof_types (
    id_proof_type_id	INT PRIMARY KEY IDENTITY(1,1),
    proof_type_name		NVARCHAR(255)	NOT NULL
);

-- Create User Types Table
CREATE TABLE User_Types (
    user_type_id	INT PRIMARY KEY IDENTITY(1,1),
    type_name		NVARCHAR(255)	NOT NULL,
    description		NVARCHAR(MAX)	NULL,		-- Using NVARCHAR(MAX) for potentially large text
    permissions		BIGINT			NOT NULL
	-- to not make the database more bigger made the permissions as binary data structure
	-- to be handled at businuss logic layer
);

-- Create Communication Ways Table
CREATE TABLE Communication_Ways (
    communication_way_id	INT PRIMARY KEY IDENTITY(1,1),
    communication_name		NVARCHAR(255) NOT NULL UNIQUE
);

-- Create Loyalty Tiers Table
CREATE TABLE Loyalty_Tiers (
    loyalty_tier_id INT PRIMARY KEY IDENTITY(1,1),
    tier_name		NVARCHAR(255)	NOT NULL,
    min_points		INT				NOT NULL
);

-- Create Services Table
CREATE TABLE Services (
    service_id		INT PRIMARY KEY IDENTITY(1,1),
    service_name	NVARCHAR(255)	NOT NULL,
    description		NVARCHAR(MAX)	NULL,		-- Using NVARCHAR(MAX) for potentially large text
    price_usd		SMALLMONEY		NOT NULL
);

-- Create Bed Types Table
CREATE TABLE bed_types (
    bed_type_id INT PRIMARY KEY IDENTITY(1,1),
    type_name	NVARCHAR(255)	NOT NULL,
    description NVARCHAR(MAX)	NULL,
    capacity	SMALLINT		NOT NULL

-- CONSTRAINT
	CONSTRAINT CK_capacity CHECK (capacity > 0)
);

-- Create Employee Types Table
CREATE TABLE Employee_Types (
    employee_type_id	INT PRIMARY KEY IDENTITY(1,1),
    type_name			NVARCHAR(255) NOT NULL,
    description			NVARCHAR(MAX) NULL
);

-- Create Room Status Table
CREATE TABLE room_status (
    room_status_id INT PRIMARY KEY IDENTITY(1,1),
    status NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);


-- Create Payment Methods Table
CREATE TABLE Payment_Methods (
    payment_method_id INT PRIMARY KEY IDENTITY(1,1),
    method_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);

-- Create Payment Status Table
CREATE TABLE Payment_Status (
    status_id INT PRIMARY KEY IDENTITY(1,1),
    status_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);

-- Create Card Types Table
CREATE TABLE Card_Types (
    card_type_id INT PRIMARY KEY IDENTITY(1,1),
    card_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);

-- Create Currencies Table
CREATE TABLE Currencies (
    currency_id INT PRIMARY KEY IDENTITY(1,1),
    currency_name NVARCHAR(255) NOT NULL,
    currency_code NVARCHAR(10) NOT NULL UNIQUE
);

--==================================================================================================
---------------------------[		Create People Table			]-----------------------------------
--==================================================================================================



-- Create people table
CREATE TABLE People (
    person_id	INT IDENTITY(1,1),
    first_name	NVARCHAR(255)	NOT NULL,
    second_name NVARCHAR(255)	NULL,
    third_name	NVARCHAR(255)	NULL,
    last_name	NVARCHAR(255)	NOT NULL,
    email		NVARCHAR(255)	NULL,		 
    date_of_birth		DATE	NULL,
    id_proof_type_id	INT		NOT NULL,
    id_proof_type_number NVARCHAR(255) UNIQUE NOT NULL,
    country_id			INT		NOT NULL,

--Constraints
    CONSTRAINT PK_Person				Primary Key (person_id),	 -- Clustered Index By Defualt
	CONSTRAINT FK_Person_Country		FOREIGN KEY (country_id)		REFERENCES Countries(country_id),
    CONSTRAINT FK_Person_IDProofType	FOREIGN KEY (id_proof_type_id)	REFERENCES id_proof_types(id_proof_type_id)
);

-- INDEXIES

-- Indexing email
-- Conditional index to be able to store multiple nullables in a unique field
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
    user_id			INT PRIMARY KEY IDENTITY(1,1),
    username		NVARCHAR(255)	NOT NULL UNIQUE,
    password_hash	NVARCHAR(255)	NOT NULL,			-- Will be hashed inside Business Logic Layer
    is_active		BIT				DEFAULT 1,			-- 1 Is true, 0 is false
    last_login		DATETIME		NULL,
    account_locked	BIT				DEFAULT 0,
    account_locked_until DATETIME	NULL,
    person_id		INT				NULL,
    user_type_id	INT				NOT NULL,

-- Constraints
    CONSTRAINT FK_Users_Person		FOREIGN KEY (person_id)		REFERENCES People(person_id),
    CONSTRAINT FK_Users_UserType	FOREIGN KEY (user_type_id)	REFERENCES User_Types(user_type_id)
);

-- Indexies
CREATE NONCLUSTERED INDEX idx_username
ON Users (username);


--------------------------------------------------------------------------------------------------

-- Create Room Types Table
CREATE TABLE Room_Types (
    room_type_id		INT PRIMARY KEY IDENTITY(1,1),
    bed_type_id			INT			NOT NULL,
    capacity			SMALLINT	NOT NULL,
    wifi				BIT DEFAULT 0,
    internet_speed_MB	FLOAT(24) NULL,
    tv					BIT DEFAULT 0,
    work_desk			BIT DEFAULT 0,
    balcony				BIT DEFAULT 0,
    refrigerator		BIT DEFAULT 0,
    coffee_maker		BIT DEFAULT 0,
    safe				BIT DEFAULT 0,
    room_orientation	NVARCHAR(255)	NULL,
    base_price_rate		SMALLMONEY		NOT NULL,

	-- CONSTRAINTs
	CONSTRAINT CK_Room_Types_Capacity			CHECK		(capacity > 0), --capacity cant be 0 or negative
    CONSTRAINT FK_RoomTypes_BedType FOREIGN KEY (bed_type_id) REFERENCES bed_types(bed_type_id)
);



------------------------------------------------------------------------------------------------

-- Create Guests Table
CREATE TABLE Guests (
    guest_id		INT PRIMARY KEY IDENTITY(1,1),	
    person_id		INT NOT NULL ,				-- Indexed For Joined Query Preformance
    loyalty_tier_id INT,
    loyalty_points	INT DEFAULT 0,				-- When creating a guest it's his first stay so he won't have loyalty points
    total_stays		INT DEFAULT 0,				-- When creating a guest it's his first stay
    preferred_room_type_id INT,
    last_stay_date	DATE,
    communication_preference_id INT,
    is_vip			BIT DEFAULT 0,				-- Using BIT for boolean values 0 is False
    user_id			INT NOT NULL,

-- FOREIGN KEY Constraints
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
CREATE TABLE Loyalty_Benefits (
    benefit_id		INT PRIMARY KEY IDENTITY(1,1),
    loyalty_tier_id INT NOT NULL,
    service_id		INT NOT NULL,
	
	-- float Precision
	-- 1-24		7  digits	4 bytes storage size
	-- 25-53	15 digits	4 bytes storage size
    discount_percentage		float(24) NOT NULL, 
    points			INT NOT NULL,

	-- Adding constraint for discount percentage and forign keys
	CONSTRAINT CK_discount_percentage			CHECK		(discount_percentage >= 0 AND discount_percentage <= 100), 
    CONSTRAINT FK_LoyaltyBenefits_LoyaltyTier	FOREIGN KEY (loyalty_tier_id)	REFERENCES Loyalty_Tiers(loyalty_tier_id),
    CONSTRAINT FK_LoyaltyBenefits_Service		FOREIGN KEY (service_id)		REFERENCES Services(service_id)
);



--------------------------------------------------------------------------------------------------


-- Create Rooms Table
CREATE TABLE Rooms (
    room_id			INT PRIMARY KEY IDENTITY(1,1),
    room_type_id	INT			NOT NULL, -- This will reference Room_Types
    capacity		SMALLINT	NOT NULL,
    floor			SMALLINT	NOT NULL,
    room_status_id	INT			NOT NULL,

-- CONSTRAINTS
	--Check
	CONSTRAINT CK_Rooms_capacity	CHECK (capacity > 0),	-- Capacity must be positive
	CONSTRAINT CK_Floor		CHECK (floor >= 0),		-- Floor must be non-negative
	-- FOREIGN KEYs
    CONSTRAINT FK_Rooms_RoomType		FOREIGN KEY (room_type_id)		REFERENCES Room_Types(room_type_id),
    CONSTRAINT FK_Rooms_CurrentStatus	FOREIGN KEY (room_status_id)	REFERENCES room_status(room_status_id)
);



----------------------------------------------------------------------------------------------------

-- Create Staff Table
CREATE TABLE Staff (
    staff_id				INT PRIMARY KEY IDENTITY(1,1),
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
    department_id	INT PRIMARY KEY IDENTITY(1,1),
    department_name NVARCHAR(255)	NOT NULL,
    department_head INT				NULL,
    email			NVARCHAR(255)	NULL,
    budget			MONEY			NOT NULL ,
    location		NVARCHAR(255)	NULL,

-- CONSTRAINTS
	CONSTRAINT CK_budget CHECK (budget >= 0), -- Budget must be non-negative
    CONSTRAINT FK_Departments_DepartmentHead FOREIGN KEY (department_head) REFERENCES Staff(staff_id)
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
    position_id		 INT PRIMARY KEY IDENTITY(1,1),
    title			 NVARCHAR(255)	NOT NULL,
    department_id	 INT			NOT NULL,
    salary_min		 MONEY			NOT NULL, 
    salary_max		 MONEY			NOT NULL, 
    qualifications	 NVARCHAR(MAX)	NULL,
    responsibilities NVARCHAR(MAX)	NULL,

-- CONSTRAINTS
	CONSTRAINT CK_salary_min			CHECK		(salary_min >= 0),			-- Minimum salary must be non-negative
	CONSTRAINT CK_salary_max			CHECK		(salary_max >= salary_min),	-- Maximum salary must be greater than or equal to minimum
    CONSTRAINT FK_Position_Department	FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

Alter Table Staff
Add CONSTRAINT FK_Staff_Position FOREIGN KEY (position_id) REFERENCES Position(position_id);


----------------------------------------------------------------------------------------------------


-- Create Phone Table
CREATE TABLE Phone (
    phone_id		INT PRIMARY KEY IDENTITY(1,1),
    phone_number	NVARCHAR(15)	NOT NULL,
    person_id		INT				NOT NULL,
    is_active		BIT				DEFAULT 1,

-- CONSTRAINTS
    CONSTRAINT FK_Phone_Person FOREIGN KEY (person_id) REFERENCES People(person_id)
);

-- indexing person_id
CREATE NONCLUSTERED INDEX idx_person_id
ON Phone (person_id);

----------------------------------------------------------------------------------------------------

-- Create Reservation Table
CREATE TABLE Reservation (
    reservation_id			INT PRIMARY KEY IDENTITY(1,1),
    guest_id				INT			NOT NULL,
    room_id					INT			NOT NULL,
    check_in_date			DATETIME	NOT NULL,
    check_out_date			DATETIME	NOT NULL,
    actual_check_out_date	DATETIME	NULL,
    payment_id				INT			NULL,

-- Constraints
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
    payment_id			INT PRIMARY KEY IDENTITY(1,1),
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
