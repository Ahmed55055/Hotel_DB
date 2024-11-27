-- here is SQL script
CREATE TABLE Counties (
    ID INT PRIMARY KEY,
    name VARCHAR(255),
    COUNTRY_CODE VARCHAR(10),
    ISO_CODE VARCHAR(10)
);

CREATE TABLE IDProofTypes (
    ID INT PRIMARY KEY,
    ProofTypeName VARCHAR(255)
);

CREATE TABLE Person (
    ID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    SecondName VARCHAR(255) NULL,
    ThirdName VARCHAR(255) NULL,
    LastName VARCHAR(255),
    Email VARCHAR(255) NULL UNIQUE,
    DateOfBirth DATE NULL,
    IDProofType_ID INT,
    IDProofType_Number VARCHAR(255) UNIQUE,
    countryID INT,
    FOREIGN KEY (IDProofType_ID) REFERENCES IDProofTypes(ID),
    FOREIGN KEY (countryID) REFERENCES Counties(ID)
);

CREATE TABLE Users (
    ID INT PRIMARY KEY,
    Username VARCHAR(255),
    Password_hash VARCHAR(255),
    IsActive BIT,
    LastLogin DATETIME NULL,
    account_locked BIT,
    account_locked_until DATETIME NULL,
    personID INT NULL,
    user_type_id INT,
    FOREIGN KEY (personID) REFERENCES Person(ID),
    FOREIGN KEY (user_type_id) REFERENCES User_Types(user_type_id)
);

CREATE TABLE User_Types (
    user_type_id INT PRIMARY KEY,
    type_name VARCHAR(255),
    description TEXT,
    permitions INT
);

CREATE TABLE Communication_Ways (
    ID INT PRIMARY KEY,
    communication_name VARCHAR(255)
);

CREATE TABLE Loyalty_Tiers (
    loyalty_tier_id INT PRIMARY KEY,
    tier_name VARCHAR(255),
    min_points INT
);

CREATE TABLE Loyalty_Benefits (
    ID INT PRIMARY KEY,
    loyalty_tier_id INT,
    service_id INT,
    discount DECIMAL(10, 2),
    points INT,
    FOREIGN KEY (loyalty_tier_id) REFERENCES Loyalty_Tiers(loyalty_tier_id),
    FOREIGN KEY (service_id) REFERENCES Services(ID)
);

CREATE TABLE Services (
    ID INT PRIMARY KEY,
    service_name VARCHAR(255),
    description TEXT,
    price SMALLMONEY
);

CREATE TABLE Rooms (
    ID INT PRIMARY KEY,
    room_type INT,
    Capacity SMALLINT,
    floor SMALLINT,
    current_status INT,
    FOREIGN KEY (room_type) REFERENCES Room_Types(ID),
    FOREIGN KEY (current_status) REFERENCES Room_Status(room_status_id)
);

CREATE TABLE Room_Types (
    ID INT PRIMARY KEY,
    bed_type_id INT,
    capacity SMALLINT,
    WiFi BIT,
    Internet_speed_MB DECIMAL(10, 2),
    TV BIT,
    work_desk BIT,
    balcony BIT,
    refrigerator BIT,
    coffee_maker BIT,
    safe BIT,
    room_orientation VARCHAR(255),
    base_price_rate SMALLMONEY,
    FOREIGN KEY (bed_type_id) REFERENCES Bed_Types(ID)
);

CREATE TABLE Bed_Types (
    ID INT PRIMARY KEY,
    type_name VARCHAR(255),
    description TEXT,
    capacity SMALLINT
);

CREATE TABLE Room_Status (
    room_status_id INT PRIMARY KEY,
    status VARCHAR(255),
    description TEXT
);

CREATE TABLE Staff (
    Id INT PRIMARY KEY,
    PersonID INT,
    DepartmentID INT NULL,
    PositionID INT,
    ManagerID INT,
    Salary SMALLMONEY,
    employee_type_id INT,
    emergency_contact_phone VARCHAR(255),
    bank_account_number VARCHAR(255),
    performance_rating DECIMAL(10, 2),
    employment_status INT,
    hire_date DATETIME,
    departure_date DATE NULL,
    user_id INT,
    FOREIGN KEY (PersonID) REFERENCES Person(ID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
    FOREIGN KEY (PositionID) REFERENCES Position(ID),
    FOREIGN KEY (user_id) REFERENCES Users(ID)
);

CREATE TABLE Employee_Types (
    ID INT PRIMARY KEY,
    type_name VARCHAR(255),
    description TEXT
);

CREATE TABLE Departments (
    ID INT PRIMARY KEY,
    DepartmentName VARCHAR(255),
    DepartmentHead INT,
    Email VARCHAR(255),
    Budget MONEY,
    location VARCHAR(255),
    FOREIGN KEY (DepartmentHead) REFERENCES Staff(Id)
);

CREATE TABLE Position (
    ID INT PRIMARY KEY,
    Title VARCHAR(255),
    DepartmentID INT,
    Salary_min MONEY,
    Salary_max MONEY,
    qualifications TEXT,
    responsibilities TEXT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(ID)
);

CREATE TABLE Phone (
    ID INT PRIMARY KEY,
    phoneNumber VARCHAR(20),
    personID INT,
    isActive BIT,
    FOREIGN KEY (personID) REFERENCES Person(ID)
);

CREATE TABLE Guests (
    ID INT PRIMARY KEY,
    personID INT,
    loyalty_tier_id INT,
    loyalty_points INT,
    total_stays INT,
    preferred _room_type_id INT,
    last_stay_date DATE,
    communication_preference_id INT,
    is_vip BIT,
    user_id INT,
    FOREIGN KEY (personID) REFERENCES Person(ID),
    FOREIGN KEY (loyalty_tier_id) REFERENCES Loyalty_Tiers(loyalty_tier_id),
    FOREIGN KEY (preferred_room_type_id) REFERENCES Room_Types(ID),
    FOREIGN KEY (communication_preference_id) REFERENCES Communication_Ways(ID),
    FOREIGN KEY (user_id) REFERENCES Users(ID)
);

CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in_date DATETIME,
    check_out_date DATETIME,
    actual_check_out_date DATETIME NULL,
    payment INT NULL,
    FOREIGN KEY (guest_id) REFERENCES Guests(ID),
    FOREIGN KEY (room_id) REFERENCES Rooms(ID),
    FOREIGN KEY (payment) REFERENCES Payment(payment_id)
);

CREATE TABLE Payment_Methods (
    payment_method_id INT PRIMARY KEY,
    method_name VARCHAR(255),
    description TEXT
);

CREATE TABLE Payment_Status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(255),
    description TEXT
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    reservation_id INT,
    guest_id INT,
    amount MONEY,
    payment_method_id INT,
    payment_status_id INT,
    card_type_id INT,
    payment_date DATETIME,
    currency_id INT,
    note TEXT,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    FOREIGN KEY (guest_id) REFERENCES Guests(ID),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id),
    FOREIGN KEY (payment_status_id) REFERENCES Payment_Status(status_id),
    FOREIGN KEY (card_type_id) REFERENCES Card_Types(card_type_id),
    FOREIGN KEY (currency_id) REFERENCES Currencies(currency_id)
);

CREATE TABLE Card_Types (
    card_type_id INT PRIMARY KEY,
    card_name VARCHAR(255),
    description TEXT
);

CREATE TABLE Currencies (
    currency_id INT PRIMARY KEY,
    currency_name VARCHAR(255),
    currency_code VARCHAR(10)
);
