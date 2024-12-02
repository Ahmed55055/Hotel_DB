# Database Design Documentation

## Overview

This documentation provides a comprehensive overview of the database design for a hotel management system. It details the purpose, structure, and constraints of each table, including field names, data types, and foreign key relationships. The design aims to efficiently manage various aspects of hotel operations, including user accounts, guest information, room management, services, payments, and staff administration.

## Table of Contents

1. [Countries Table](#1-countries-table)
2. [ID Proof Types Table](#2-id-proof-types-table)
3. [User  Types Table](#3-user-types-table)
4. [Communication Ways Table](#4-communication-ways-table)
5. [Loyalty Tiers Table](#5-loyalty-tiers-table)
6. [Services Table](#6-services-table)
7. [Bed Types Table](#7-bed-types-table)
8. [Employee Types Table](#8-employee-types-table)
9. [Room Status Table](#9-room-status-table)
10. [Payment Methods Table](#10-payment-methods-table)
11. [Payment Status Table](#11-payment-status-table)
12. [Card Types Table](#12-card-types-table)
13. [Currencies Table](#13-currencies-table)
14. [People Table](#14-people-table)
15. [Users Table](#15-users-table)
16. [Room Types Table](#16-room-types-table)
17. [Guests Table](#17-guests-table)
18. [Loyalty Benefits Table](#18-loyalty-benefits-table)
19. [Rooms Table](#19-rooms-table)
20. [Staff Table](#20-staff-table)
21. [Departments Table](#21-departments-table)
22. [Position Table](#22-position-table)
23. [Phone Table](#23-phone-table)
24. [Reservation Table](#24-reservation-table)
25. [Payment Table](#25-payment-table)
26. [Indexing in the Database](#indexing-in-the-database)

---

## 1. Countries Table

### Purpose
The `Countries` table stores information about different countries, which can be referenced in other tables.

### Fields
| Field Name     | Data Type     | Purpose                                        |
|----------------|----------------|------------------------------------------------|
| country_id     | INT            | Unique identifier for each country (Primary Key) |
| name           | NVARCHAR(255)  | Name of the country (Cannot be NULL)         |
| country_code   | NVARCHAR(10)   | Short code representing the country (Cannot be NULL) |
| iso_code       | NVARCHAR(10)   | ISO code for the country (Cannot be NULL)    |

### Constraints
- `country_id` is the primary key.

---

## 2. ID Proof Types Table

### Purpose
The `id_proof_types` table stores different types of identification proofs that can be associated with people.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| id_proof_type_id   | INT            | Unique identifier for each proof type (Primary Key) |
| proof_type_name     | NVARCHAR(255)  | Name of the proof type (Cannot be NULL)      |

### Constraints
- `id_proof_type_id` is the primary key.

---

## 3. User Types Table

### Purpose
The `User _Types` table defines different user roles within the system, including their permissions.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| user_type_id       | INT            | Unique identifier for each user type (Primary Key) |
| type_name          | NVARCHAR(255)  | Name of the user type (Cannot be NULL)       |
| description        | NVARCHAR(MAX)   | Description of the user type (Nullable)      |
| permissions        | BIGINT         | Bitwise representation of permissions (Cannot be NULL) |

### Constraints
- `user_type_id` is the primary key.

---

## 4. Communication Ways Table

### Purpose
The `Communication_Ways` table stores different methods of communication that can be preferred by guests.

### Fields
| Field Name               | Data Type     | Purpose                                       |
|--------------------------|----------------|-----------------------------------------------|
| communication_way_id     | INT            | Unique identifier for each communication method (Primary Key) |
| communication_name       | NVARCHAR(255)  | Name of the communication method (Cannot be NULL, Unique) |

### Constraints
- `communication_way_id` is the primary key.
- `communication_name` must be unique.

---

## 5. Loyalty Tiers Table

### Purpose
The `Loyalty_Tiers` table defines different loyalty tiers for guests based on their points.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| loyalty_tier_id    | INT            | Unique identifier for each loyalty tier (Primary Key) |
| tier_name          | NVARCHAR(255)  | Name of the loyalty tier (Cannot be NULL)    |
| min_points         | INT            | Minimum points required to qualify for the tier (Cannot be NULL) |

### Constraints
- `loyalty_tier_id` is the primary key.

---

## 6. Services Table

### Purpose
The `Services` table stores information about various services offered by the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| service_id         | INT            | Unique identifier for each service (Primary Key) |
| service_name       | NVARCHAR(255)  | Name of the service (Cannot be NULL)         |
| description        | NVARCHAR(MAX)   | Description of the service (Nullable)        |
| price_usd          | SMALLMONEY      | Price of the service in USD (Cannot be NULL) |

### Constraints
- `service_id` is the primary key.

---

## 7. Bed Types Table

### Purpose
The `bed_types` table defines different types of beds available in the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| bed_type_id        | INT            | Unique identifier for each bed type (Primary Key) |
| type_name          | NVARCHAR(255)  | Name of the bed type (Cannot be NULL) |
| description        | NVARCHAR(MAX)   | Description of the bed type (Nullable)       |
| capacity           | SMALLINT        | Maximum number of guests the bed can accommodate (Cannot be NULL) |

### Constraints
- `bed_type_id` is the primary key.
- `capacity` must be greater than 0.

---

## 8. Employee Types Table

### Purpose
The `Employee_Types` table categorizes different types of employees within the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| employee_type_id   | INT            | Unique identifier for each employee type (Primary Key) |
| type_name          | NVARCHAR(255)  | Name of the employee type (Cannot be NULL)   |
| description        | NVARCHAR(MAX)   | Description of the employee type (Nullable)  |

### Constraints
- `employee_type_id` is the primary key.

---

## 9. Room Status Table

### Purpose
The `room_status` table tracks the current status of each room in the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| room_status_id     | INT            | Unique identifier for each room status (Primary Key) |
| status             | NVARCHAR(255)  | Current status of the room (Cannot be NULL)  |
| description        | NVARCHAR(MAX)   | Description of the room status (Nullable)    |

### Constraints
- `room_status_id` is the primary key.

---

## 10. Payment Methods Table

### Purpose
The `Payment_Methods` table stores various methods of payment accepted by the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| payment_method_id   | INT            | Unique identifier for each payment method (Primary Key) |
| method_name        | NVARCHAR(255)  | Name of the payment method (Cannot be NULL)  |
| description        | NVARCHAR(MAX)   | Description of the payment method (Nullable)  |

### Constraints
- `payment_method_id` is the primary key.

---

## 11. Payment Status Table

### Purpose
The `Payment_Status` table defines the various statuses a payment can have.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| status_id          | INT            | Unique identifier for each payment status (Primary Key) |
| status_name        | NVARCHAR(255)  | Name of the payment status (Cannot be NULL)  |
| description        | NVARCHAR(MAX)   | Description of the payment status (Nullable)  |

### Constraints
- `status_id` is the primary key.

---

## 12. Card Types Table

### Purpose
The `Card_Types` table stores information about different types of credit/debit cards accepted.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| card_type_id       | INT            | Unique identifier for each card type (Primary Key) |
| card_name          | NVARCHAR(255)  | Name of the card type (Cannot be NULL)       |
| description        | NVARCHAR(MAX)   | Description of the card type (Nullable)      |

### Constraints
- `card_type_id` is the primary key.

---

## 13. Currencies Table

### Purpose
The `Currencies` table defines the various currencies accepted by the hotel.

### Fields
| Field Name         | Data Type     | Purpose                                       |
|--------------------|----------------|-----------------------------------------------|
| currency_id        | INT            | Unique identifier for each currency (Primary Key) |
| currency_name      | NVARCHAR(255)  | Name of the currency (Cannot be NULL)        |
| currency_code      | NVARCHAR(10)   | Short code representing the currency (Cannot be NULL, Unique) |

### Constraints
- `currency_id` is the primary key.

---

## 14. People Table

### Purpose
The `People` table stores personal information about individuals associated with the hotel, including guests and staff.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| person_id                 | INT            | Unique identifier for each person (Primary Key) |
| first_name                | NVARCHAR(255)  | First name of the person (Cannot be NULL)   |
| second_name               | NVARCHAR(255)  | Second name of the person (Nullable)         |
| third_name                | NVARCHAR(255)  | Third name of the person (Nullable)          |
| last_name | NVARCHAR(255)  | Last name of the person (Cannot be NULL) |
| email                     | NVARCHAR(255)  | Email address of the person (Nullable)      |
| date_of_birth             | DATE           | Date of birth of the person (Nullable)      |
| id_proof_type_id         | INT            | Identifier for the type of ID proof (Cannot be NULL) |
| id_proof_type_number      | NVARCHAR(255)  | Unique ID proof number (Cannot be NULL, Unique) |
| country_id                | INT            | Identifier for the country (Cannot be NULL) |

### Constraints
- `person_id` is the primary key.
- `id_proof_type_id` is a foreign key referencing `id_proof_types(id_proof_type_id)`.
- `country_id` is a foreign key referencing `Countries(country_id)`.

---

## 15. Users Table

### Purpose
The `Users` table manages user accounts for the hotel management system.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| user_id                   | INT            | Unique identifier for each user (Primary Key) |
| username                  | NVARCHAR(255)  | Unique username for the user (Cannot be NULL) |
| password_hash             | NVARCHAR(255)  | Hashed password for the user (Cannot be NULL) |
| is_active                 | BIT            | Indicates if the account is active (Default: 1) |
| last_login                | DATETIME       | Timestamp of the last login (Nullable)      |
| account_locked            | BIT            | Indicates if the account is locked (Default: 0) |
| account_locked_until      | DATETIME       | Timestamp until which the account is locked (Nullable) |
| person_id                 | INT            | Identifier for the associated person (Nullable) |
| user_type_id              | INT            | Identifier for the user type (Cannot be NULL) |

### Constraints
- `user_id` is the primary key.
- `person_id` is a foreign key referencing `People(person_id)`.
- `user_type_id` is a foreign key referencing `User _Types(user_type_id)`.

---

## 16. Room Types Table

### Purpose
The `Room_Types` table defines the various types of rooms available in the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| room_type_id              | INT            | Unique identifier for each room type (Primary Key) |
| bed_type_id               | INT            | Identifier for the type of bed (Cannot be NULL) |
| capacity                  | SMALLINT       | Maximum number of guests the room can accommodate (Cannot be NULL) |
| wifi                      | BIT            | Indicates if Wi-Fi is available (Default: 0) |
| internet_speed_MB         | FLOAT(24)      | Internet speed in MB (Nullable)              |
| tv                        | BIT            | Indicates if a TV is available (Default: 0) |
| work_desk                 | BIT            | Indicates if a work desk is available (Default: 0) |
| balcony                   | BIT            | Indicates if a balcony is available (Default: 0) |
| refrigerator              | BIT            | Indicates if a refrigerator is available (Default: 0) |
| coffee_maker              | BIT            | Indicates if a coffee maker is available (Default: 0) |
| safe                      | BIT            | Indicates if a safe is available (Default: 0) |
| room_orientation          | NVARCHAR(255)  | Orientation of the room (Nullable)          |
| base_price_rate           | SMALLMONEY      | Base price rate for the room (Cannot be NULL) |

### Constraints
- `room_type_id` is the primary key.
- `bed_type_id` is a foreign key referencing `bed_types(bed_type_id)`.
- `capacity` must be greater than 0.

---

## 17. Guests Table

### Purpose
The `Guests` table stores information about guests staying at the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| guest_id                  | INT            | Unique identifier for each guest (Primary Key) |
| person_id                 | INT            | Identifier for the associated person (Cannot be NULL) |
| loyalty_tier_id           | INT            | Identifier for the loyalty tier (Nullable)   |
| loyalty_points             | INT            | Points accumulated by the guest (Default: 0) |
| total_stays               | INT            | Total number of stays by the guest (Default: 0) |
| preferred_room_type_id    | INT            | Identifier for the preferred room type (Nullable) |
| last_stay_date            | DATE           | Date of the last stay (Nullable)              |
| communication_preference_id| INT            | Identifier for the preferred communication method (Nullable) |
| is_vip                    | BIT            | Indicates if the guest is a VIP (Default: 0) |
| user_id                   | INT            | Identifier for the associated user (Cannot be NULL) |

### Denormalization Explained 
### Why
Based on my requirements, the information regarding the `last_stay_date` is essential for the receptionist, while `total_stays` is beneficial for both the receptionist and the guest, particularly when guests access their data online.

### How will we address this?
Once the reservation is finalized and the guest is checked into their room, we can update the `last_stay_date` to the current date and increment the `total_stays` by one. Additionally, a query will be scheduled to run weekly, or at regular intervals, to verify that all guest records are consistent by counting each guest's stays and making updates if discrepancies are identified.


### Constraints
- `guest_id` is the primary key.
- `person_id` is a foreign key referencing `People(person_id)`.
- `loyalty_tier_id` is a foreign key referencing `Loyalty_Tiers(loyalty_tier_id)`.
- `preferred_room_type_id` is a foreign key referencing `Room_Types(room_type_id)`.
- `communication_preference_id` is a foreign key referencing `Communication_Ways(communication_way_id)`.
- `user_id` is a foreign key referencing `Users(user_id)`.

---

## 18. Loyalty Benefits Table

### Purpose
The `Loyalty_Benefits` table defines the benefits associated with different loyalty tiers.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| benefit_id                | INT            | Unique identifier for each benefit (Primary Key) |
| loyalty_tier_id           | INT            | Identifier for the associated loyalty tier (Cannot be NULL) |
| service_id                | INT            | Identifier for the associated service (Cannot be NULL) |
| discount_percentage        | FLOAT(24)      | Discount percentage offered (Cannot be NULL) |
| points                    | INT            | Points required to avail the benefit (Cannot be NULL) |

### Constraints
- `benefit_id` is the primary key.
- `loyalty_tier_id` is a foreign key referencing `Loyalty_Tiers(loyalty_tier_id)`.
- `service_id` is a foreign key referencing `Services(service_id)`.
- `discount_percentage` must be between 0 and 100.

---

## 19. Rooms Table

### Purpose
The `Rooms` table stores information about the individual rooms available in the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| room_id                   | INT            | Unique identifier for each room (Primary Key) |
| room_type_id              | INT            | Identifier for the type of room (Cannot be NULL) |
| capacity                  | SMALLINT       | Maximum number of guests the room can accommodate (Cannot be NULL) |
| floor                     | SMALLINT       | Floor number where the room is located (Cannot be NULL) |
| room_status_id            | INT            | Identifier for the current status of the room (Cannot be NULL) |

### Constraints
- `room_id` is the primary key.
- `room_type_id` is a foreign key referencing `Room_Types(room_type_id)`.
- `room_status_id` is a foreign key referencing `room_status(room_status_id)`.
- `capacity` must be greater than 0.
- `floor` must be non-negative.

---

## 20. Staff Table

### Purpose
The `Staff` table stores information about hotel staff members.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| staff_id                  | INT            | Unique identifier for each staff member (Primary Key) |
| person_id                 | INT            | Identifier for the associated person (Cannot be NULL) |
| department_id             | INT            | Identifier for the department (Nullable)     |
| position_id               | INT            | Identifier for the position (Cannot be NULL) |
| manager_id                | INT            | Identifier for the manager (Nullable)        |
| salary                    | SMALLMONEY      | Salary of the staff member (Cannot be NULL)  |
| employee_type_id          | INT            | Identifier for the employee type (Cannot be NULL) |
| emergency_contact_phone    | NVARCHAR(15)   | Emergency contact phone number (Nullable)    |
| bank_account_number        | NVARCHAR(20)   | Bank account number (Nullable)                |
| performance_rating         | FLOAT(24)      | Performance rating (Default: 5)               |
| employment_status          | INT            | Employment status (Cannot be NULL)            |
| hire_date                 | DATETIME       | Date of hiring (Cannot be NULL)               |
| departure_date            | DATE           | Date of departure (Nullable)                  |
| user_id                   | INT            | Identifier for the associated user (Cannot be NULL) |

### Constraints
- `staff_id` is the primary key.
- `person_id` is a foreign key referencing `People(person_id)`.
- ` department_id` is a foreign key referencing `Departments(department_id)`.
- `position_id` is a foreign key referencing `Position(position_id)`.
- `manager_id` is a foreign key referencing `Staff(staff_id)`.
- `user_id` is a foreign key referencing `Users(user_id)`.

---

## 21. Departments Table

### Purpose
The `Departments` table categorizes different departments within the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| department_id             | INT            | Unique identifier for each department (Primary Key) |
| department_name           | NVARCHAR(255)  | Name of the department (Cannot be NULL)      |
| department_head           | INT            | Identifier for the head of the department (Nullable) |
| email                     | NVARCHAR(255)  | Email address for the department (Nullable)  |
| budget                    | MONEY          | Budget allocated for the department (Cannot be NULL) |
| location                  | NVARCHAR(255)  | Location of the department (Nullable)        |

### Constraints
- `department_id` is the primary key.
- `department_head` is a foreign key referencing `Staff(staff_id)`.

---

## 22. Position Table

### Purpose
The `Position` table defines various job positions available within the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| position_id               | INT            | Unique identifier for each position (Primary Key) |
| title                     | NVARCHAR(255)  | Title of the position (Cannot be NULL)       |
| department_id             | INT            | Identifier for the associated department (Cannot be NULL) |
| salary_min                | MONEY          | Minimum salary for the position (Cannot be NULL) |
| salary_max                | MONEY          | Maximum salary for the position (Cannot be NULL) |
| qualifications            | NVARCHAR(MAX)   | Qualifications required for the position (Nullable) |
| responsibilities          | NVARCHAR(MAX)   | Responsibilities associated with the position (Nullable) |

### Constraints
- `position_id` is the primary key.
- `department_id` is a foreign key referencing `Departments(department_id)`.

---

## 23. Phone Table

### Purpose
The `Phone` table stores phone numbers associated with individuals in the hotel.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| phone_id                  | INT            | Unique identifier for each phone entry (Primary Key) |
| phone_number              | NVARCHAR(15)   | Phone number (Cannot be NULL)                |
| person_id                 | INT            | Identifier for the associated person (Cannot be NULL) |
| is_active                 | BIT            | Indicates if the phone number is active (Default: 1) |

### Constraints
- `phone_id` is the primary key.
- `person_id` is a foreign key referencing `People(person_id)`.

---

## 24. Reservation Table

### Purpose
The `Reservation` table manages room reservations made by guests.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| reservation_id            | INT            | Unique identifier for each reservation (Primary Key) |
| guest_id                  | INT            | Identifier for the associated guest (Cannot be NULL) |
| room_id                   | INT            | Identifier for the reserved room (Cannot be NULL) |
| check_in_date             | DATETIME       | Check-in date for the reservation (Cannot be NULL) |
| check_out_date            | DATETIME       | Check-out date for the reservation (Cannot be NULL) |
| actual_check_out_date     | DATETIME       | Actual check-out date (Nullable)             |
| payment_id                | INT            | Identifier for the associated payment (Nullable) |

### Constraints
- `reservation_id` is the primary key.
- `guest_id` is a foreign key referencing `Guests(guest_id)`.
- `room_id` is a foreign key referencing `Rooms(room_id)`.
- `payment_id` is a foreign key referencing `Payment(payment_id)`.

---

## 25. Payment Table

### Purpose
The `Payment` table records payment transactions made by guests.

### Fields
| Field Name                | Data Type     | Purpose                                       |
|---------------------------|----------------|-----------------------------------------------|
| payment_id                | INT            | Unique identifier for each payment (Primary Key) |
| reservation_id            | INT            | Identifier for the associated reservation (Cannot be NULL) |
| guest_id                  | INT            | Identifier for the associated guest (Cannot be NULL) |
| amount                    | MONEY          | Amount paid (Cannot be NULL)                 |
 | payment_method_id        | INT            | Identifier for the payment method (Cannot be NULL) |
| payment_status_id        | INT            | Identifier for the payment status (Cannot be NULL) |
| card_type_id             | INT            | Identifier for the card type used (Cannot be NULL) |
| payment_date             | DATETIME       | Date of the payment (Cannot be NULL)           |
| currency_id              | INT            | Identifier for the currency used (Cannot be NULL) |
| note                     | NVARCHAR(MAX)   | Additional notes regarding the payment (Nullable) |

### Constraints
- `payment_id` is the primary key.
- `reservation_id` is a foreign key referencing `Reservation(reservation_id)`.
- `guest_id` is a foreign key referencing `Guests(guest_id)`.
- `payment_method_id` is a foreign key referencing `Payment_Methods(payment_method_id)`.
- `payment_status_id` is a foreign key referencing `Payment_Status(status_id)`.
- `card_type_id` is a foreign key referencing `Card_Types(card_type_id)`.
- `currency_id` is a foreign key referencing `Currencies(currency_id)`.
- `amount` must be non-negative.

---

## Indexing in the Database

Indexing is a crucial aspect of database design that enhances the performance of queries by allowing the database management system to find and retrieve data more efficiently. In this database schema, several indexes have been created to optimize query performance, particularly for fields that are frequently used in search conditions or join operations.

### Key Indexes
- **People Table**: 
  - `idx_people_email`: A unique non-clustered index on the `email` field to ensure that email addresses are unique and to speed up lookups by email.
  - `idx_first_name`: A non-clustered index on the `first_name` field to improve search performance for first names.
  - `idx_last_name`: A non-clustered index on the `last_name` field to enhance search performance for last names.

- **Users Table**: 
  - `idx_username`: A non-clustered index on the `username` field to ensure quick access to user accounts by username.

- **Guests Table**: 
  - `idx_person_id`: A non-clustered index on the `person_id` field to optimize join operations with the `People` table.

- **Staff Table**: 
  - `idx_person_id`: A non-clustered index on the `person_id` field to improve performance for queries involving staff members.

- **Phone Table**: 
  - `idx_person_id`: A non-clustered index on the `person_id` field to facilitate quick lookups of phone numbers associated with individuals.

- **Reservation Table**: 
  - `idx_person_id`: A non-clustered index on the `person_id` field to enhance performance for queries related to reservations.

By implementing these indexes, the database can handle larger datasets and more complex queries efficiently, ensuring a responsive experience for users interacting with the hotel management system. ```markdown
