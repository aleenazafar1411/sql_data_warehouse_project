# Data Catalog for Gold Layer

## Overview
The Gold Layer represents the finalized, business-ready data used for analytics, reporting, and decision-making. It is designed using **dimension tables** and **fact tables** to support key business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Contains cleaned and enriched customer master data used for customer analysis, segmentation, and demographic reporting.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | System-generated surrogate key that uniquely identifies each customer record.               |
| customer_id      | INT           | Unique numeric identifier assigned to each customer from the source system.                 |
| customer_number  | NVARCHAR(50)  | Business-friendly alphanumeric customer code used for tracking and reference.               |
| first_name       | NVARCHAR(50)  | First name of the customer as captured in the system.                                        |
| last_name        | NVARCHAR(50)  | Last or family name of the customer.                                                         |
| country          | NVARCHAR(50)  | Country of residence of the customer (e.g., 'Australia').                                    |
| marital_status   | NVARCHAR(50)  | Marital status of the customer (e.g., 'Married', 'Single').                                  |
| gender           | NVARCHAR(50)  | Gender of the customer (e.g., 'Male', 'Female', 'n/a').                                      |
| birthdate        | DATE          | Date of birth stored in YYYY-MM-DD format (e.g., 1971-10-06).                                |
| create_date      | DATE          | Date and time when the customer record was created in the system.                           |

---

### 2. **gold.dim_products**
- **Purpose:** Stores standardized product master data used for product analysis, pricing evaluation, and category-wise reporting.
- **Columns:**

| Column Name           | Data Type     | Description                                                                                   |
|-----------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key           | INT           | Unique surrogate key generated for each product record.                                      |
| product_id            | INT           | Internal numeric identifier assigned to each product.                                        |
| product_number        | NVARCHAR(50)  | Unique alphanumeric product code used for categorization and inventory (e.g., 'BK-1001').  |
| product_name          | NVARCHAR(50)  | Descriptive name of the product including key attributes like type, color, and size.       |
| category_id           | NVARCHAR(50)  | Identifier representing the main product category.                                          |
| category              | NVARCHAR(50)  | High-level classification of the product (e.g., Bikes, Components).                         |
| subcategory           | NVARCHAR(50)  | Detailed classification within the main product category.                                   |
| maintenance_required  | NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                    |
| cost                  | INT           | Base cost of the product in monetary units.                                                 |
| product_line          | NVARCHAR(50)  | Product series or line to which the product belongs (e.g., Road, Mountain).                |
| start_date            | DATE          | Date when the product became available for sale or use.                                     |

---

### 3. **gold.fact_sales**
- **Purpose:** Holds transactional sales records used for revenue analysis, trend reporting, and business performance monitoring.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | Unique sales order reference number (e.g., 'SO54496').                                        |
| product_key     | INT           | Surrogate key linking the order to the product dimension table.                              |
| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                             |
| order_date      | DATE          | Date when the customer placed the order.                                                     |
| shipping_date   | DATE          | Date when the order was shipped to the customer.                                             |
| due_date        | DATE          | Date when the payment for the order was due.                                                 |
| sales_amount    | INT           | Total monetary value of the sale in whole currency units (e.g., 25).                         |
| quantity        | INT           | Number of product units ordered in the transaction (e.g., 1).                               |
| price           | INT           | Price per single unit of the product in whole currency units (e.g., 25).                    |
