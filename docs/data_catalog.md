# Data Catalog for Gold Layer

## Overview
The Gold Layer represents business-ready data designed for analytics and reporting. It is organized into **dimension tables** (descriptive data) and **fact tables** (measurable events).

---

## 1. gold.dim_customers

- **Purpose:**  
  Stores customer information enriched with demographic and geographic attributes.

### Columns

| Column Name     | Data Type     | Description |
|-----------------|--------------|-------------|
| customer_key    | INT          | Surrogate key uniquely identifying each customer record. |
| customer_id     | INT          | Unique numeric identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier used for tracking and referencing customers. |
| first_name      | NVARCHAR(50) | Customer’s first name. |
| last_name       | NVARCHAR(50) | Customer’s last name or family name. |
| country         | NVARCHAR(50) | Country of residence (e.g., 'United States'). |
| marital_status  | NVARCHAR(50) | Customer’s marital status (e.g., 'Married', 'Single'). |
| gender          | NVARCHAR(50) | Customer’s gender (e.g., 'Male', 'Female', 'Unknown'). |
| birthdate       | DATE         | Customer’s date of birth (YYYY-MM-DD). |
| create_date     | DATE         | Date the customer record was created. |

---

## 2. gold.dim_products

- **Purpose:**  
  Contains product details and classification attributes.

### Columns

| Column Name          | Data Type     | Description |
|----------------------|--------------|-------------|
| product_key          | INT          | Surrogate key uniquely identifying each product record. |
| product_id           | INT          | Unique identifier for internal tracking of products. |
| product_number       | NVARCHAR(50) | Alphanumeric product code used for identification. |
| category_id          | NVARCHAR(50) | Identifier for the product category. |
| product_name         | NVARCHAR(50) | Descriptive name of the product. |
| product_line         | NVARCHAR(50) | Product line or series (e.g., Road, Mountain). |
| category             | NVARCHAR(50) | High-level product classification (e.g., Clothing, Components). |
| subcategory          | NVARCHAR(50) | More detailed classification within a category. |
| maintenance          | NVARCHAR(50) | Indicates if maintenance is required (e.g., 'Yes', 'No'). |
| cost                 | INT          | Base cost of the product in monetary units. |
| start_date           | DATE         | Date the product became available. |

---

## 3. gold.fact_sales

- **Purpose:**  
  Stores transactional sales data for analysis and reporting.

### Columns

| Column Name   | Data Type     | Description |
|---------------|--------------|-------------|
| order_number  | NVARCHAR(50) | Unique identifier for each sales order (e.g., 'SO43699'). |
| product_key   | INT          | Surrogate key linking the order to the product dimension table. |
| customer_key  | INT          | Surrogate key linking the order to the customer dimension table. |
| order_date    | DATE         | Date the order was placed. |
| shipping_date | DATE         | Date the order was shipped to the customer. |
| due_date      | DATE         | Payment due date for the order. |
| sales_amount  | INT          | Total monetary value of the sale for the line item, in whole currency units(e.g, 3578). |
| quantity      | INT          | Number of units ordered(e.g, 1). |
| price         | INT          | Price per unit for the product, in whole currency units(e.g, 699). |

---

## Summary

- **Dimension tables** (`dim_*`) provide descriptive context (who, what, where).
- **Fact tables** (`fact_*`) capture measurable business events (sales, transactions).
- Surrogate keys (`*_key`) ensure consistent relationships across tables.

This structure supports efficient querying, reporting, and business intelligence use cases.
