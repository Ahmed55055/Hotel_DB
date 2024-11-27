# Hotel Management System Database Documentation

## Overview
This database is designed to manage a comprehensive hotel management system. It encompasses various entities such as guests, staff, rooms, services, and payments, facilitating functionalities like reservations, loyalty programs, and staff management.

## Table of Contents
- [1. Counties](#1-counties)
- [2. IDProofTypes](#2-idprooftypes)
- [3. Person](#3-person)
- [4. Users](#4-users)
- [5. User_Types](#5-user_types)
- [6. Communication_Ways](#6-communication_ways)
- [7. Loyalty_Tiers](#7-loyalty_tiers)
- [8. Loyalty_Benefits](#8-loyalty_benefits)
- [9. Services](#9-services)
- [10. Rooms](#10-rooms)
- [11. Room_Types](#11-room_types)
- [12. Bed_Types](#12-bed_types)
- [13. Room_Status](#13-room_status)
- [14. Staff](#14-staff)
- [15. Employee_Types](#15-employee_types)
- [16. Departments](#16-departments)
- [17. Position](#17-position)
- [18. Phone](#18-phone)
- [19. Guests](#19-guests)
- [20. Reservations](#20-reservations)
- [21. Payment_Methods](#21-payment_methods)
- [22. Payment_Status](#22-payment_status)
- [23. Payment](#23-payment)
- [24. Card_Types](#24-card_types)
- [25. Currencies](#25-currencies)
- [26. Relationships](#26-relationships)
- [27. Conclusion](#27-conclusion)

## 1. Counties
**Purpose**: Stores information about countries.

| Field            | Type     | Description                                |
|------------------|----------|--------------------------------------------|
| `ID`             | INT      | Unique identifier for the country (PK).   |
| `name`           | VARCHAR  | Name of the country.                       |
| `COUNTRY_CODE`   | VARCHAR  | ISO country code.                          |
| `ISO_CODE`       | VARCHAR  | International Organization for Standardization code. |

## 2. IDProofTypes
**Purpose**: Contains types of identification proofs.

| Field            | Type     | Description                                |
|------------------|----------|--------------------------------------------|
| `ID`             | INT      | Unique identifier for the ID proof type (PK). |
| `ProofTypeName`  | VARCHAR  | Name of the ID proof type (e.g., Passport). |

## 3. Person
**Purpose**: Represents individuals (guests and staff) in the system.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for a person (PK).      |
| `FirstName`              | VARCHAR  | First name of the person.                  |
| `SecondName`             | VARCHAR  | Second name of the person (nullable).      |
| `ThirdName`              | VARCHAR  | Third name of the person (nullable).       |
| `LastName`               | VARCHAR  | Last name of the person.                   |
| `Email`                  | VARCHAR  | Unique email address (nullable).           |
| `DateOfBirth`           | DATE     | Date of birth (nullable).                  |
| `IDProofType_ID`        | INT      | Foreign key referencing IDProofTypes.      |
| `IDProofType_Number`     | VARCHAR  | Unique number of the ID proof (nullable).  |
| `countryID`              | INT      | Foreign key referencing Counties.           |

## 4. Users
**Purpose**: Manages user accounts for guests and staff.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for a user (PK).        |
| `Username`               | VARCHAR  | User's login name.                         |
| `Password_hash`          | VARCHAR  | Hashed password for security.              |
| `IsActive`               | BIT      | Indicates if the account is active.       |
| `LastLogin`              | DATETIME | Timestamp of the last login (nullable).    |
| `account_locked`         | BIT      | Indicates if the account is locked.       |
| `account_locked_until`   | DATETIME | Timestamp until the account remains locked (nullable). |
| `personID`               | INT      | Foreign key referencing Person. |
| `user_type_id`            | INT      | Foreign key referencing User_Types.     |

## 5. User_Types
**Purpose**: Defines different types of users (e.g., guest, staff).

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `user_type_id`          | INT      | Unique identifier for the user type (PK). |
| `type_name`             | VARCHAR  | Name of the user type.                    |
| `description`           | TEXT     | Description of the user type.             |
| `permissions`            | TEXT     | Permissions associated with the user type. |

## 6. Communication_Ways
**Purpose**: Stores different communication preferences.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the communication method (PK). |
| `communication_name`     | VARCHAR  | Name of the communication method (e.g., Email, SMS). |

## 7. Loyalty_Tiers
**Purpose**: Defines loyalty tiers for guests.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `loyalty_tier_id`       | INT      | Unique identifier for the loyalty tier (PK). |
| `tier_name`             | VARCHAR  | Name of the loyalty tier.                  |
| `min_points`            | INT      | Minimum points required for this tier.     |

## 8. Loyalty_Benefits
**Purpose**: Links loyalty tiers to benefits (services).

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the loyalty benefit (PK). |
| `loyalty_tier_id`       | INT      | Foreign key referencing Loyalty_Tiers.     |
| `service_id`            | INT      | Foreign key referencing Services.          |
| `discount`              | DECIMAL  | Discount associated with the benefit.      |
| `points`                | INT      | Points required to redeem the benefit.     |

## 9. Services
**Purpose**: Lists services offered by the hotel.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the service (PK).   |
| `service_name`          | VARCHAR  | Name of the service.                       |
| `description`           | TEXT     | Description of the service.                |
| `price`                 | DECIMAL  | Price of the service.                      |

## 10. Rooms
**Purpose**: Represents rooms available in the hotel.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the room (PK).      |
| `room_type`             | INT      | Foreign key referencing Room_Types.       |
| `Capacity`              | INT      | Maximum number of occupants.               |
| `floor`                 | INT      | Floor number where the room is located.   |
| `current_status`        | INT      | Foreign key referencing Room_Status.       |

## 11. Room_Types
**Purpose**: Defines different types of rooms.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the room type (PK). |
| `bed_type_id`           | INT      | Foreign key referencing Bed_Types.        |
| `capacity`              | INT      | Maximum capacity of the room.              |
| `WiFi`                  | BIT      | Indicates if WiFi is available (boolean).  |
| `Internet_speed_MB`     | INT      | Speed of the internet in megabytes.       |
| `TV`                    | BIT      | Indicates if a TV is available (boolean).  |
| `work_desk`             | BIT      | Indicates if a work desk is available (boolean). |
| `balcony`               | BIT      | Indicates if a balcony is available (boolean). |
| `refrigerator`          | BIT      | Indicates if a refrigerator is available (boolean). |
| `coffee_maker`          | BIT      | Indicates if a coffee maker is available (boolean). |
| `safe`                  | BIT      | Indicates if a safe is available (boolean). |
| `room_orientation`      | VARCHAR  | Orientation of the room (e.g., sea view). |
| `base_price_rate`       | DECIMAL  | Base price rate for the room.             |

## 12. Bed_Types
**Purpose **Purpose**: Lists different types of beds available in rooms.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the bed type (PK).  |
| `type_name`             | VARCHAR  | Name of the bed type (e.g., King, Queen). |
| `description`           | TEXT     | Description of the bed type.               |
| `capacity`              | INT      | Maximum number of occupants for the bed type. |

## 13. Room_Status
**Purpose**: Represents the status of rooms (e.g., available, occupied).

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `room_status_id`        | INT      | Unique identifier for the room status (PK). |
| `status`                 | VARCHAR  | Current status of the room.                |
| `description`           | TEXT     | Description of the status.                 |

## 14. Staff
**Purpose**: Manages staff information.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `Id`                     | INT      | Unique identifier for the staff member (PK). |
| `PersonID`               | INT      | Foreign key referencing Person.            |
| `DepartmentID`           | INT      | Foreign key referencing Departments (nullable). |
| `PositionID`             | INT      | Foreign key referencing Position.          |
| `ManagerID`              | INT      | Foreign key referencing Staff (nullable).  |
| `Salary`                 | DECIMAL  | Salary of the staff member.                |
| `employee_type_id`       | INT      | Foreign key referencing Employee_Types.    |
| `emergency_contact_phone` | VARCHAR  | Emergency contact phone number.            |
| `bank_account_number`     | VARCHAR  | Bank account number for salary deposits.   |
| `performance_rating`      | DECIMAL  | Rating of the staff member's performance.  |
| `employment_status`       | INT      | Foreign key referencing employment status.  |
| `hire_date`              | DATE     | Date of hiring.                            |
| `departure_date`         | DATE     | Date of departure (nullable).              |
| `user_id`                | INT      | Foreign key referencing Users.             |

## 15. Employee_Types
**Purpose**: Defines types of employment (e.g., full-time, part-time).

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the employee type (PK). |
| `type_name`             | VARCHAR  | Name of the employee type.                 |
| `description`           | TEXT     | Description of the employee type.          |

## 16. Departments
**Purpose**: Represents different departments within the hotel.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the department (PK). |
| `DepartmentName`        | VARCHAR  | Name of the department.                    |
| `DepartmentHead`        | INT      | Foreign key referencing Staff.             |
| `Email`                 | VARCHAR  | Contact email for the department.          |
| `Budget`                | DECIMAL  | Budget allocated to the department.        |
| `location`              | VARCHAR  | Physical location of the department.       |

## 17. Position
**Purpose**: Defines positions within departments.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the position (PK).  |
| `Title`                  | VARCHAR  | Title of the position.                     |
| `DepartmentID`          | INT      | Foreign key referencing Departments.       |
| `Salary_min`            | DECIMAL  | Minimum salary for the position.          |
| `Salary_max`            | DECIMAL  | Maximum salary for the position.          |
| `qualifications`        | TEXT     | Required qualifications for the position.  |
| `responsibilities`      | TEXT     | Responsibilities associated with the position. |

## 18. Phone
**Purpose**: Stores phone numbers associated with persons.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the phone record (PK). |
| `phoneNumber`           | VARCHAR  | Phone number.                             |
| `personID`              | INT      | Foreign key referencing Person.           |
| `isActive`              | BIT      | Indicates if the phone number is active. |

## 19. Guests
**Purpose**: Represents guests staying at the hotel.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `ID`                     | INT      | Unique identifier for the guest (PK).     |
| `personID`              | INT      | Foreign key referencing Person.            |
| `loyalty_tier_id`       | INT      | Foreign key referencing Loyalty_Tiers.     |
| `loyalty_points`        | INT      | Points accumulated by the guest.           |
| `total_stays`           | INT      | Total number of stays by the guest.       |
| `preferred_room_type_id` | INT      | Foreign key referencing Room_Types.        |
| `last_stay_date`        | DATE     | Date of the last stay.                     |
| `communication_preference_id` | INT | Foreign key referencing Communication_Ways. |
| `is_vip`                | BIT      | Indicates if the guest is a VIP.          |
| `user_id`               | INT      | Foreign key referencing Users.             |

## 20. Reservations
**Purpose**: Manages room reservations made by guests.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `reservation_id`        | INT      | Unique identifier for the reservation (PK). |
| `guest_id`              | INT      | Foreign key referencing Guests.            |
| `room_id`               | INT      | Foreign key referencing Rooms.             |
| `check_in_date`         | DATETIME | Date and time of check-in.                |
| `check_out_date`        | DATETIME | Date and time of check-out.               |
| `actual_check_out_date` | DATETIME | Date and time of actual check-out (nullable). |
| `payment`               | INT      | Foreign key referencing Payment (nullable). |

## 21. Payment_Methods
**Purpose**: Lists available payment methods.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `payment_method_id`      | INT      | Unique identifier for the payment method (PK). |
| `method_name`           | VARCHAR  | Name of the payment method.                |
| `description`           | TEXT     | Description of the payment method.         |

## 22. Payment_Status
**Purpose**: Represents the status of payments.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `status_id`             | INT      | Unique identifier for the payment status (PK). |
| `status_name`           | VARCHAR  | Name of the payment status.                |
| `description`           | TEXT     | Description of the payment status.         |

## 23. Payment
**Purpose**: Manages payment transactions related to reservations.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `payment_id`            | INT      | Unique identifier for the payment (PK).   |
| `reservation_id`        | INT      | Foreign key referencing Reservations.      |
| `guest_id`              | INT      | Foreign key referencing Guests.            |
| `amount`                | DECIMAL  | Amount paid.                               |
| `payment_method_id`     | INT      | Foreign key referencing Payment_Methods.   |
| `payment_status_id`     | INT      | Foreign key referencing Payment_Status.    |
| `card_type_id`          | INT      | Foreign key referencing Card_Types.       |
| `payment_date`          | DATETIME | Date and time of the payment.             |
| `currency_id`           | INT      | Foreign key referencing Currencies.       |
| `note`                  | TEXT     | Additional notes regarding the payment.    |

## 24. Card_Types
**Purpose**: Lists types of payment cards.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `card_type_id`          | INT      | Unique identifier for the card type (PK). |
| `card_name`             | VARCHAR  | Name of the card type (e.g., Visa, MasterCard). |
| `description`           | TEXT     | Description of the card type.             |

## 25. Currencies
**Purpose**: Stores information about different currencies.

| Field                    | Type     | Description                                |
|--------------------------|----------|--------------------------------------------|
| `currency_id`           | INT      | Unique identifier for the currency (PK).  |
| `currency_name`         | VARCHAR  | Name of the currency.                      |
| `currency_code`         | VARCHAR  | Code of the currency (e.g., USD, EUR ). |

## 26. Relationships
### One-to-Many
- A **User ** can have multiple **Guests**.
- A **Guest** can have multiple **Reservations**.
- A **Room_Type** can have multiple **Rooms**.
- A **Loyalty_Tier** can have multiple **Loyalty_Benefits**.
- A **Department** can have multiple **Staff**.
- A **Position** can have multiple **Staff**.

### Many-to-One
- Multiple **Guests** can reference a single **Person**.
- Multiple **Staff** can reference a single **Person**.
- Multiple **Rooms** can reference a single **Room_Type**.
- Multiple **Payments** can reference a single **Reservation**.

### One-to-One
- Each **Staff** member can have one **User ** account.
- Each **Guest** can have one **User ** account.

## 27. Conclusion
This documentation provides a comprehensive overview of the database schema for the hotel management system. It outlines the purpose of each table, the fields contained within them, and the relationships between the tables. This structure is designed to facilitate efficient data management and retrieval for various hotel operations, ensuring a seamless experience for both guests and staff.
