-- RETAIL SUPPLY CHAIN AND WAREHOUSING ANALYTICS

-- Sprint 1: Business Understanding and Data Understanding
-- 1. Company Background: Understand the company's business, retail supply chain, and warehouse operations.
-- 2. Role: Work as a Data Analyst to analyse data and support operational decisions.
-- 3. Understanding the ER Diagram: Identify tables, columns, primary keys, foreign keys, and relationships.
-- 4. Analytical Thinking from the ER Diagram: Identify the required tables and columns, understand their 
-- relationships, and plan the logical approach to answer business questions without writing SQL queries.


-- SPRINT 2
CREATE DATABASE retail_supply_chain;
USE retail_supply_chain;

CREATE TABLE suppliers(
supplier_id VARCHAR(10) PRIMARY KEY,
supplier_name VARCHAR(100) NOT NULL,
city VARCHAR(50),
supplier_cateory VARCHAR(20),
reliability_rating DECIMAL(3,2),
contract_since DATE
);

CREATE TABLE warehouses(
warehouse_id VARCHAR(10) PRIMARY KEY,
warehouse_name VARCHAR(100) NOT NULL,
city VARCHAR(50),
warehouse_type VARCHAR(20),
storage_capacity_units INT,
region VARCHAR(20),
opened_date DATE);

CREATE TABLE staff(
staff_id VARCHAR(10)PRIMARY KEY,
staff_name VARCHAR(100) NOT NULL,
hire_date DATE,
rating DECIMAL(3,2),
employment_type VARCHAR(20),
is_active VARCHAR(3));

CREATE TABLE purchase_orders(
po_id VARCHAR(20) PRIMARY KEY,
warehouse_id VARCHAR(10),
supplier_id VARCHAR(10),
order_date DATE,
product_category VARCHAR(30),
order_priority VARCHAR(10),
quantity_ordered INT,
total_cost DECIMAL(12,2),
FOREIGN KEY (warehouse_id)
REFERENCES warehouses(warehouse_id),
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id));

CREATE TABLE vehicles(
vehicle_id VARCHAR(10) PRIMARY KEY,
vehicle_type VARCHAR(20),
fuel_type VARCHAR(20),
max_payload_kg DECIMAL(8,2),
depot_warehouse_id VARCHAR(10),
last_service_date DATE,
is_active VARCHAR(3),
FOREIGN KEY (depot_warehouse_id)
REFERENCES warehouses(warehouse_id));

CREATE TABLE shipments(
shipment_id VARCHAR(20) PRIMARY KEY,
po_id VARCHAR(20),
staff_id VARCHAR(10),
vehicle_id VARCHAR(10),
dispatch_date DATE,
arrival_date DATE,
status VARCHAR(20),
shipment_attempt TINYINT,
distance_km DECIMAL(6,2),
transit_duration_hrs INT,
FOREIGN KEY(po_id)
REFERENCES purchase_orders(po_id),
FOREIGN KEY (staff_id)
REFERENCES staff(staff_id),
FOREIGN KEY (vehicle_id)
REFERENCES vehicles(vehicle_id));