-- SPRINT 3 - Basic Analysis / Data Exploration

USE retail_supply_chain;
select * from purchase_orders;
select * from staff;
select * from warehouses;
select * from suppliers;
select * from staff;
select * from vehicles;
select * from shipments;
-- 1. What is the total number of warehouses?
select count(*) from warehouses;
-- 2. What is the total number of purchase orders?
select count(*) from purchase_orders;
-- 3. What is the total number of shipments?
select count(*) from shipments;
-- 4. What are the different product categories ordered?
SELECT DISTINCT product_category from purchase_orders;
-- 5. How many staff members are currently active?
select count(is_active) from staff
where is_active="Yes";
-- 6. What are the different vehicle types in the fleet?
SELECT DISTINCT vehicle_type from vehicles;
-- 7. What is the total cost of all purchase orders?
SELECT sum(total_cost) from purchase_orders;
-- 8. What is the average quantity ordered per purchase order?
SELECT avg(quantity_ordered) from purchase_orders;