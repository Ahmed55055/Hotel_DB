# Hotel Database Project - SQL Server

This repository contains the SQL Server database creation script for a hotel management system.  The database design includes tables for guests, rooms, reservations, staff, payments, and other related entities.

## Project Overview

This project was developed as a college project. While the database design contains some imperfections that were realized late in the development process, it serves as a functional system for managing hotel operations.  The database is designed to handle various aspects of hotel management, including guest information, room availability, reservations, staff details, and payment processing.

## Database Design

The database schema is organized into several tables, including:

*   **Helper Tables:** These tables contain supporting data like countries, ID proof types, user types, communication methods, loyalty tiers, services, bed types, employee types, room status, payment methods, card types, and currencies.
*   **Main Tables:**  These tables represent core entities and their relationships. They include People, Users, Room Types, Guests, Loyalty Benefits, Rooms, Staff, Departments, Position, Phone, Reservation, and Payment.

The script includes the creation of these tables along with constraints (primary keys, foreign keys, unique constraints, check constraints), indexes, and sample data insertions.  Some foreign key constraints were added using `ALTER TABLE` after the initial table creation due to circular dependencies between tables (e.g., Staff and Departments).

## Script Structure

The SQL script is divided into the following sections:

*   **Tables With No Foreign Keys (Lines 1-156):**  Creation of helper tables that do not have foreign key dependencies.
*   **Tables With Foreign Keys (Lines 165-511):** Creation of main tables that have foreign key relationships with other tables.
*   **Normal Insert Statements (Lines 536-755):** Insertion of sample data into the created tables.
*   **Select Queries (Lines 736-858):** Example queries to retrieve data from the database.
*   **Insertion Query Extracted from Dataset (Lines 864-1380):** Insertion of country and currency data from external datasets.

## Database Design Notes

The script includes a comment acknowledging some database design shortcomings.  These were not addressed due to time constraints.

## Running the Script

The script can be executed in SQL Server Management Studio (SSMS) or any other SQL Server client.  Ensure that you have the necessary permissions to create a database and tables.  You may need to uncomment the `CREATE DATABASE` and `USE` statements at the beginning of the script if you are creating the database for the first time.
```
