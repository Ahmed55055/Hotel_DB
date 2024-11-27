Database Documentation
Overview
This database is designed to manage a hotel management system. It includes entities related to guests, staff, rooms, services, payments, and more. The schema supports various functionalities such as reservations, loyalty programs, and staff management.

Tables and Descriptions
1. Counties
Purpose: Stores information about countries.
Fields:
ID: Unique identifier for the country (Primary Key).
name: Name of the country.
COUNTRY_CODE: ISO country code.
ISO_CODE: International Organization for Standardization code.
2. IDProofTypes
Purpose: Contains types of identification proofs.
Fields:
ID: Unique identifier for the ID proof type (Primary Key).
ProofTypeName: Name of the ID proof type (e.g., Passport, Driver's License).
3. Person
Purpose: Represents individuals (guests and staff) in the system.
Fields:
ID: Unique identifier for a person (Primary Key).
FirstName, SecondName, ThirdName, LastName: Names of the person.
Email: Unique email address of the person (nullable).
DateOfBirth: Date of birth of the person (nullable).
IDProofType_ID: Foreign key referencing IDProofTypes.
IDProofType_Number: Unique number of the ID proof (nullable).
countryID: Foreign key referencing Counties.
4. Users
Purpose: Manages user accounts for guests and staff.
Fields:
ID: Unique identifier for a user (Primary Key).
Username: User's login name.
Password_hash: Hashed password for security.
IsActive: Indicates if the account is active.
LastLogin: Timestamp of the last login (nullable).
account_locked: Indicates if the account is locked.
account_locked_until: Timestamp until the account remains locked (nullable).
personID: Foreign key referencing Person.
user_type_id: Foreign key referencing User_Types.
5. User_Types
Purpose: Defines different types of users (e.g., guest, staff).
Fields:
user_type_id: Unique identifier for the user type (Primary Key).
type_name: Name of the user type.
description: Description of the user type.
permitions: Permissions associated with the user type.
6. Communication_Ways
Purpose: Stores different communication preferences.
Fields:
ID: Unique identifier for the communication method (Primary Key).
communication_name: Name of the communication method (e.g., Email, SMS).
7. Loyalty_Tiers
Purpose: Defines loyalty tiers for guests.
Fields:
loyalty_tier_id: Unique identifier for the loyalty tier (Primary Key).
tier_name: Name of the loyalty tier.
min_points: Minimum points required for this tier.
8. Loyalty_Benefits
Purpose: Links loyalty tiers to benefits (services).
Fields:
ID: Unique identifier for the loyalty benefit (Primary Key).
loyalty_tier_id: Foreign key referencing Loyalty_Tiers.
service_id: Foreign key referencing Services.
discount: Discount associated with the benefit.
points: Points required to redeem the benefit.
9. Services
Purpose: Lists services offered by the hotel.
Fields:
ID: Unique identifier for the service (Primary Key).
service_name: Name of the service.
description: Description of the service.
price: Price of the service.
10. Rooms
Purpose: Represents rooms available in the hotel.
Fields:
ID: Unique identifier for the room (Primary Key).
room_type: Foreign key referencing Room_Types.
Capacity: Maximum number of occupants.
floor: Floor number where the room is located.
current_status: Foreign key referencing Room_Status.
11. Room_Types
Purpose: Defines different types of rooms.
Fields:
ID: Unique identifier for the room type (Primary Key).
bed_type_id: Foreign key referencing Bed_Types.
capacity: Maximum capacity of the room.
WiFi: Indicates if WiFi is available (boolean).
Internet_speed_MB: Speed of the internet in megabytes.
TV: Indicates if a TV is available (boolean).
work_desk: Indicates if a work desk is available (boolean).
balcony: Indicates if a balcony is available (boolean).
refrigerator: Indicates if a refrigerator is available (boolean).
coffee_maker: Indicates if a coffee maker is available (boolean).
safe: Indicates if a safe is available (boolean).
room_orientation: Orientation of the room (e.g., sea view).
base_price_rate: Base price rate for the room.
12. Bed_Types
Purpose: Lists different types of beds available in rooms.
Fields:
ID: Unique identifier for the bed type (Primary Key).
type_name: Name of the bed type (e.g., King, Queen).
description: Description of the bed type.
capacity: Maximum number of occupants for the bed type.
13. Room_Status
Purpose: Represents the status of rooms (e.g., available, occupied).
Fields:
room_status_id: Unique identifier for the room status (Primary Key).
status: Current status of the room.
description: Description of the status.
14. Staff
Purpose: Manages staff information.
Fields:
Id: Unique identifier for the staff member (Primary Key).
PersonID: Foreign key referencing Person.
DepartmentID: Foreign key referencing Departments (nullable).
PositionID: Foreign key referencing Position.
ManagerID: Foreign key referencing Staff (nullable).
Salary: Salary of the staff member.
employee_type_id: Foreign key referencing Employee_Types.
emergency_contact_phone: Emergency contact phone number.
bank_account_number: Bank account number for salary deposits.
performance_rating: Rating of the staff member's performance.
employment_status: Foreign key referencing employment status.
hire_date: Date of hiring.
departure_date: Date of departure (nullable).
user_id: Foreign key referencing Users.
15. Employee_Types
Purpose: Defines types of employment (e.g., full-time, part-time).
Fields:
ID: Unique identifier for the employee type (Primary Key).
type_name: Name of the employee type.
description: Description of the employee type.
16. Departments
Purpose: Represents different departments within the hotel.
Fields:
ID: Unique identifier for the department (Primary Key).
DepartmentName: Name of the department.
DepartmentHead: Foreign key referencing Staff.
Email: Contact email for the department.
Budget: Budget allocated to the department.
location: Physical location of the department.
17. Position
Purpose: Defines positions within departments.
Fields:
ID: Unique identifier for the position (Primary Key).
Title: Title of the position.
DepartmentID: Foreign key referencing Departments.
Salary_min: Minimum salary for the position.
Salary_max: Maximum salary for the position.
qualifications: Required qualifications for the position.
responsibilities: Responsibilities associated with the position.
18. Phone
Purpose: Stores phone numbers associated with persons.
Fields:
ID: Unique identifier for the phone record (Primary Key).
phoneNumber: Phone number.
personID: Foreign key referencing Person.
isActive: Indicates if the phone number is active.
19. Guests
Purpose: Represents guests staying at the hotel.
Fields:
ID: Unique identifier for the guest (Primary Key).
personID: Foreign key referencing Person.
loyalty_tier_id: Foreign key referencing Loyalty_Tiers.
loyalty_points: Points accumulated by the guest.
total_stays: Total number of stays by the guest.
preferred_room_type_id: Foreign key referencing Room_Types.
last_stay_date: Date of the last stay.
communication_preference_id: Foreign key referencing Communication_Ways.
is_vip: Indicates if the guest is a VIP.
user_id: Foreign key referencing Users.
20. Reservations
Purpose: Manages room reservations made by guests.
Fields:
reservation_id: Unique identifier for the reservation (Primary Key).
guest_id: Foreign key referencing Guests.
room_id: Foreign key referencing Rooms.
check_in_date: Date and time of check-in.
check_out_date: Date and time of check-out.
actual_check_out_date: Date and time of actual check-out (nullable).
payment: Foreign key referencing Payment (nullable).
21. Payment_Methods
Purpose: Lists available payment methods.
Fields:
payment_method_id: Unique identifier for the payment method (Primary Key).
method_name: Name of the payment method.
description: Description of the payment method.
22. Payment_Status
Purpose: Represents the status of payments.
Fields:
status_id: Unique identifier for the payment status (Primary Key).
status_name: Name of the payment status.
description: Description of the payment status.
23. Payment
Purpose: Manages payment transactions related to reservations.
Fields:
payment_id: Unique identifier for the payment (Primary Key).
reservation_id: Foreign key referencing Reservations.
guest_id: Foreign key referencing Guests.
amount: Amount paid.
payment_method_id: Foreign key referencing Payment_Methods.
payment_status_id: Foreign key referencing Payment_Status.
card_type_id: Foreign key referencing Card_Types.
payment_date: Date and time of the payment.
currency_id: Foreign key referencing Currencies.
note: Additional notes regarding the payment.
24. Card_Types
Purpose: Lists types of payment cards.
Fields:
card_type_id: Unique identifier for the card type (Primary Key).
card_name: Name of the card type (e.g., Visa, MasterCard).
description: Description of the card type.
25. Currencies
Purpose: Stores information about different currencies.
Fields:
currency_id: Unique identifier for the currency (Primary Key).
currency_name: Name of the currency.
currency_code: Code of the currency (e.g., USD, EUR).
Relationships
One-to-Many:

A User  can have multiple Guests.
A Guest can have multiple Reservations.
A Room_Type can have multiple Rooms.
A Loyalty_Tier can have multiple Loyalty_Benefits.
A Department can have multiple Staff.
A Position can have multiple Staff.
Many-to-One:

Multiple Guests can reference a single Person.
Multiple Staff can reference a single Person.
Multiple Rooms can reference a single Room_Type.
Multiple Payments can reference a single Reservation.
One-to-One:

Each Staff member can have one User  account.
Each Guest can have one User  account.
Conclusion
This documentation provides a comprehensive overview of the database schema for the hotel management system. It outlines the purpose of each table, the fields contained within them, and the relationships between the tables. This structure is designed to facilitate efficient data management and retrieval for various hotel operations.
