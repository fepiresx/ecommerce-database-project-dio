# 🛒 E-commerce Database Project

## 📌 Project Description

This project implements a relational database for an e-commerce scenario, developed as part of the **Klabin - Excel and Power BI Dashboards 2026 bootcamp**, offered by DIO (Digital Innovation One).

The project applies data modeling and SQL concepts in a real-world business context, focusing on data analysis and decision support.

The model was based on the structure presented in class, with refinements applied to:

* fix inconsistencies from the original model
* improve data integrity
* ensure compatibility with MySQL 8
* meet all challenge requirements

---

## 🎓 About the Bootcamp

The **Klabin - Excel and Power BI Dashboards 2026 bootcamp** focuses on developing skills in:

* SQL and data modeling
* Excel and Power Query
* Power BI and data visualization
* ETL and data processing
* Data storytelling

The goal is to prepare professionals to transform data into **strategic insights**, enabling work in areas such as:

* Data Analysis
* Business Intelligence (BI)
* Management Information Systems (MIS)

This project is part of the **Project Challenge**, where all concepts are applied in a complete real-world scenario.

---

## 🧠 Business Scenario

The system includes:

* individual (PF) and corporate (PJ) customers
* multiple addresses per customer
* product catalog and categories
* suppliers and third-party sellers
* inventory control by location
* orders with multiple items
* multiple payments per order
* delivery tracking with status and tracking code

---

## 🧱 Relational Model

### 🔹 Main entities

* `customer`
* `customer_pf`
* `customer_pj`
* `address`
* `category`
* `product`
* `supplier`
* `third_party_seller`
* `inventory`
* `order`
* `payment`
* `delivery`

### 🔹 Associative tables

* `supplier_product`
* `seller_product`
* `product_inventory`
* `order_item`

---

## ⚙️ Applied Refinements

### 1. PF vs PJ Customers (Specialization)

The model implements specialization:

* `customer` → common data
* `customer_pf` → individual customer (CPF)
* `customer_pj` → corporate customer (CNPJ)

Triggers ensure that a customer cannot be both PF and PJ.

---

### 2. Multiple Payments

An order can have multiple payments:

* 1:N relationship (`order → payment`)
* supports:

  * payment splitting
  * multiple payment methods
  * transaction tracking

---

### 3. Delivery Tracking

The `delivery` table includes:

* delivery status
* tracking code
* carrier
* shipping and delivery dates

---

### 4. Data Integrity (Order and Address)

The model ensures that the delivery address belongs to the customer who placed the order using a composite foreign key.

---

### 5. Normalization

The database was structured up to the **Third Normal Form (3NF)**, avoiding:

* data redundancy
* transitive dependencies
* inconsistencies

---

## 🧾 Insert Strategy

Test data uses **explicit IDs** instead of relying only on `AUTO_INCREMENT`.

### Reasons:

* improves readability
* enhances traceability
* ensures consistency across tables
* simplifies query validation

---

## 📊 SQL Queries

Queries are organized into two levels:

### 🔹 Basic queries

* simple SELECT
* WHERE filters

---

### 🔹 Analytical queries

Includes:

* JOIN
* GROUP BY
* HAVING
* ORDER BY
* aggregate functions (SUM, COUNT, AVG)
* derived attributes
* subqueries

---

## 📌 Business Questions Answered

* How many orders were made by each customer?
* What is the total amount spent per customer?
* Which orders have multiple payments?
* Are there sellers who are also suppliers?
* Which products are low in stock?
* What is the average ticket per customer?
* Which products are above the average price?

---

## ▶️ How to Run

1. Run `schema.sql`
2. Run `inserts.sql`
3. Run `queries.sql`

---

## 📂 Project Structure

```text id="5js3jt"
ecommerce-database-model/
├── schema.sql
├── inserts.sql
├── queries.sql
├── ecommerce_model.mwb
├── relational_model.png
└── README.md
```

---

## 🚀 Final Considerations

This project demonstrates practical application of:

* relational database modeling
* normalization techniques
* referential integrity
* analytical SQL queries

It is part of a portfolio focused on data analysis and business intelligence, showcasing both technical and analytical skills.

---
