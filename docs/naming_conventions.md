# Data Warehouse Naming Conventions

This document defines the standard naming conventions for schemas, tables, views, columns, and other objects in the data warehouse. The goal is to keep everything consistent, readable, and easy to maintain.

---

## 1. General Principles

- Use **snake_case** (lowercase letters with underscores).
- Use **English** for all object names.
- Avoid **SQL reserved words**.
- Keep names **clear and descriptive** rather than abbreviated or vague.

---

## 2. Table Naming Conventions

### Bronze Layer

- **Format:**  
  `<source_system>_<entity>`

- **Rules:**
  - Must start with the source system name (e.g., `crm`, `erp`).
  - Table name must match the original source table exactly (no renaming).

- **Example:**
  - `crm_customer_info` → Customer data from the CRM system

---

### Silver Layer

- **Format:**  
  `<source_system>_<entity>`

- **Rules:**
  - Same structure as Bronze.
  - Table names remain unchanged from the source system.

- **Example:**
  - `crm_customer_info`

---

### Gold Layer

- **Format:**  
  `<category>_<entity>`

- **Rules:**
  - Use business-friendly, meaningful names.
  - Focus on how the data is used, not where it came from.

- **Examples:**
  - `dim_customers` → Customer dimension table  
  - `fact_sales` → Sales transactions fact table  

---

### Category Prefix Glossary

| Prefix    | Description        | Example                    |
|-----------|--------------------|----------------------------|
| `dim_`    | Dimension tables   | `dim_customer`, `dim_product` |
| `fact_`   | Fact tables        | `fact_sales`               |
| `report_` | Reporting tables   | `report_sales_monthly`     |

---

## 3. Column Naming Conventions

### Surrogate Keys

- **Format:**  
  `<entity>_key`

- **Rules:**
  - Used for primary keys in dimension tables.
  - Clearly identifies the column as a surrogate key.

- **Example:**
  - `customer_key`

---

### Technical Columns

- **Format:**  
  `dwh_<column_name>`

- **Rules:**
  - Reserved for system-generated metadata.
  - Should describe the purpose of the column.

- **Example:**
  - `dwh_load_date` → Date the record was loaded into the warehouse

---

## 4. Stored Procedures

- **Format:**  
  `load_<layer>`

- **Rules:**
  - Used for data loading processes.
  - `<layer>` refers to the target layer in the warehouse.

- **Examples:**
  - `load_bronze` → Loads data into the Bronze layer  
  - `load_silver` → Loads data into the Silver layer  
  - `load_gold` → Loads data into the Gold layer  

---

This structure keeps everything predictable. Once you understand the pattern, you can look at any table or column name and immediately know what it represents and where it fits.
