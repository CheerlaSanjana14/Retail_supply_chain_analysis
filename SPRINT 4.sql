-- Sprint 4: Objective-Based Analysis

-- 4.1 Understand Purchase Order Demand
-- 1.How many purchase orders does each warehouse receive, and which warehouses handle the highest order volume?
SELECT warehouse_id, COUNT(*) AS total_orders
FROM purchase_orders
GROUP BY warehouse_id
ORDER BY total_orders DESC;

-- 2.Which supplier categories generate the highest purchase order demand?
SELECT supplier_category, COUNT(*) AS total_orders
FROM purchase_orders
GROUP BY supplier_category
ORDER BY total_orders DESC;

-- 3.Which suppliers have the highest average purchase order value?
SELECT supplier_id, ROUND(AVG(order_value), 2) AS avg_order_value
FROM purchase_orders
GROUP BY supplier_id
ORDER BY avg_order_value DESC;

-- 4.How is purchase order demand distributed across different order priorities?
SELECT order_priority, COUNT(*) AS total_orders
FROM purchase_orders
GROUP BY order_priority
ORDER BY total_orders DESC;

-- 5.Which warehouses receive the highest number of high-priority orders?
SELECT warehouse_id, COUNT(*) AS high_priority_orders
FROM purchase_orders
WHERE order_priority = 'High'
GROUP BY warehouse_id
ORDER BY high_priority_orders DESC;

-- 6.Which year recorded the highest purchase order demand?
SELECT YEAR(order_date) AS order_year,COUNT(*) AS total_orders FROM purchase_orders
GROUP BY YEAR(order_date)
ORDER BY total_orders DESC;

-- 7.What is the average quantity ordered for each product category and order priority?
SELECT product_category,order_priority,COUNT(*) AS total_orders,ROUND(AVG(quantity_ordered), 2) AS avg_quantity_ordered
FROM purchase_orders
GROUP BY product_category, order_priority
ORDER BY product_category, avg_quantity_ordered DESC;

-- 4.2 Understand Warehouse Ordering Behaviour
-- 1.Which warehouses raise the highest number of purchase orders?
SELECT warehouse_id, COUNT(*) AS total_orders FROM purchase_orders 
GROUP BY warehouse_id
ORDER BY total_orders DESC;
-- 2.Which warehouses have the highest total purchase order cost?
SELECT warehouse_id,ROUND(SUM(order_value), 2) AS total_order_cost FROM purchase_orders
GROUP BY warehouse_id
ORDER BY total_order_cost DESC;
-- 3.Which regions have the highest number of purchase orders?
SELECT w.region,COUNT(*) AS total_orders
FROM purchase_orders p
JOIN warehouses w
ON p.warehouse_id = w.warehouse_id
GROUP BY w.region
ORDER BY total_orders DESC;
-- 4.Do Regional, Local, and Distribution Center warehouses differ in their ordering activity?
SELECT warehouse_type,COUNT(*) AS total_orders,ROUND(AVG(order_value), 2) AS avg_order_value
FROM purchase_orders p
JOIN warehouses w
ON p.warehouse_id = w.warehouse_id
GROUP BY warehouse_type
ORDER BY total_orders DESC;
-- 5.How does the number of purchase orders from each warehouse change over time?
SELECT warehouse_id,YEAR(order_date) AS order_year,MONTH(order_date) AS order_month,COUNT(*) AS total_orders
FROM purchase_orders
GROUP BY warehouse_id, YEAR(order_date), MONTH(order_date)
ORDER BY warehouse_id, order_year, order_month;
-- 6.Which warehouses have the highest average cost per purchase order?
SELECT warehouse_id,ROUND(AVG(order_value), 2) AS avg_order_cost
FROM purchase_orders
GROUP BY warehouse_id
ORDER BY avg_order_cost DESC;

-- 4.3 Evaluate Shipment Performance
-- 1.Which suppliers have the highest number of shipments?
SELECT supplier_id,COUNT(*) AS total_shipments FROM shipments
GROUP BY supplier_id
ORDER BY total_shipments DESC;
-- 2.What is the average transit time for shipments?
SELECT ROUND(AVG(transit_days), 2) AS avg_transit_time FROM shipments;
-- 3.How many shipments are Delivered, Delayed, Damaged, or In-Transit?
SELECT shipment_status,COUNT(*) AS total_shipments FROM shipments
GROUP BY shipment_status
ORDER BY total_shipments DESC;
-- 4.Which warehouses have the highest number of delayed or damaged shipments?
SELECT warehouse_id,COUNT(*) AS delayed_damaged_shipments FROM shipments
WHERE shipment_status IN ('Delayed', 'Damaged')
GROUP BY warehouse_id
ORDER BY delayed_damaged_shipments DESC;
-- 5.Which suppliers have the highest number of delayed or damaged shipments?
SELECT supplier_id,COUNT(*) AS delayed_damaged_shipments FROM shipments
WHERE shipment_status IN ('Delayed', 'Damaged')
GROUP BY supplier_id
ORDER BY delayed_damaged_shipments DESC;
-- 6.Which shipments take the longest time to arrive?
SELECT shipment_id,supplier_id,warehouse_id,transit_days FROM shipments
ORDER BY transit_days DESC;

-- 4.4 Understand Staff and Vehicle Performance
-- 1.Which staff members handle the highest number of shipments?
SELECT staff_id,COUNT(*) AS total_shipments FROM shipments
GROUP BY staff_id
ORDER BY total_shipments DESC;
-- 2.How many shipments handled by each staff member are Delivered, Delayed, or Damaged?
SELECT staff_id,shipment_status,COUNT(*) AS total_shipments FROM shipments
GROUP BY staff_id, shipment_status
ORDER BY staff_id, total_shipments DESC;
-- 3.Which staff members have the longest average transit duration?
SELECT staff_id,ROUND(AVG(transit_days), 2) AS avg_transit_duration FROM shipments
GROUP BY staff_id
ORDER BY avg_transit_duration DESC;
-- 4.Which vehicle types are used for the highest number of shipments?
SELECT v.vehicle_type,COUNT(*) AS total_shipments
FROM shipments s
JOIN vehicles v
ON s.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_type
ORDER BY total_shipments DESC;
-- 5.Which vehicles handle the highest number of shipments?
SELECT vehicle_id,COUNT(*) AS total_shipments
FROM shipments
GROUP BY vehicle_id
ORDER BY total_shipments DESC;
-- 6.Which vehicles have the highest average transit duration?
SELECT vehicle_id,ROUND(AVG(transit_days), 2) AS avg_transit_duration
FROM shipments
GROUP BY vehicle_id
ORDER BY avg_transit_duration DESC;

-- 4.5 Identify Shipment Problems
-- 1.How many purchase orders required multiple shipment attempts?
SELECT COUNT(*) AS multiple_attempt_orders
FROM (
    SELECT purchase_order_id,
           COUNT(*) AS total_attempts
    FROM shipments
    GROUP BY purchase_order_id
    HAVING COUNT(*) > 1
) AS multiple_shipments;
-- 2.Which purchase orders required the highest number of shipment attempts?
SELECT purchase_order_id,COUNT(*) AS total_attempts
FROM shipments
GROUP BY purchase_order_id
HAVING COUNT(*) > 1
ORDER BY total_attempts DESC;
-- 3.What are the most common shipment statuses?
SELECT shipment_status,COUNT(*) AS total_shipments
FROM shipments
GROUP BY shipment_status
ORDER BY total_shipments DESC;
-- 4.Which suppliers have the highest number of shipments requiring multiple attempts?
SELECT p.supplier_id,COUNT(*) AS multiple_attempt_orders
FROM purchase_orders p
JOIN shipments s
ON p.purchase_order_id = s.purchase_order_id
GROUP BY p.supplier_id, p.purchase_order_id
HAVING COUNT(*) > 1
ORDER BY multiple_attempt_orders DESC;
-- 5.Which suppliers have the highest number of damaged shipments?
SELECT supplier_id,COUNT(*) AS damaged_shipments
FROM shipments
WHERE shipment_status = 'Damaged'
GROUP BY supplier_id
ORDER BY damaged_shipments DESC;
-- 6.Which shipments have not yet arrived despite being dispatched?
SELECT YEAR(shipment_date) AS shipment_year,MONTH(shipment_date) AS shipment_month,COUNT(*) AS shipment_problems
FROM shipments
WHERE shipment_status IN ('Delayed', 'Damaged')
GROUP BY YEAR(shipment_date), MONTH(shipment_date)
ORDER BY shipment_year, shipment_month;
