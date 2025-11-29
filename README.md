# 🏗️ SQL Data Warehouse Project (Medallion Architecture)

This project demonstrates the complete implementation of a **modern SQL-based Data Warehouse** using the **Medallion Architecture (Bronze, Silver, Gold layers)**. It covers raw data ingestion, data cleaning, transformation, and building business-ready analytical models.

The goal of this project is to showcase strong practical skills in **SQL, Data Modeling, ETL Pipelines, and Analytics**.

---

## 🎯 Project Objectives

- Build a complete **end-to-end data warehouse**
- Apply **Bronze, Silver, and Gold** layered architecture
- Clean and standardize raw data
- Create **dimension and fact tables**
- Enable **business-ready reporting and analytics**
- Follow proper **naming conventions and documentation**

---

## 🧱 Architecture Overview

### 🔹 Bronze Layer (Raw Data)
- Stores raw ingested CSV data  
- No transformations applied  
- Acts as the **single source of truth**

### 🔸 Silver Layer (Cleaned Data)
- Data cleaning & validation  
- Null handling, data type fixes  
- Duplicate and error removal  

### ⭐ Gold Layer (Business Models)
- Final analytical tables  
- Fact & dimension tables  
- Ready for dashboards & reporting  

---

## 📂 Project Folder Structure

sql-data-warehouse-project/
│
├── datasets/ # Raw CSV files
├── scripts/
│ ├── bronze/ # Raw data ingestion
│ ├── silver/ # Data cleaning & transformation
│ └── gold/ # Final analytics models
├── docs/ # Architecture diagrams & data catalog
├── tests/ # Data quality checks
└── README.md


---

## 🛠️ Tools & Technologies

- SQL (T-SQL)  
- Microsoft SQL Server  
- CSV Data Sources  
- Draw.io (for diagrams)  
- Git & GitHub  

---

## 🚀 How To Run This Project

1. Create a database in SQL Server  
2. Upload the CSV files from the `datasets` folder  
3. Execute scripts in the following order:
   - `scripts/bronze`
   - `scripts/silver`
   - `scripts/gold`
4. Verify final tables in the **Gold Layer**

---

## 📊 Data Modeling

- **Dimension Tables:** Customers, Products, Dates  
- **Fact Table:** Sales  

### Supported KPIs:
- Total Sales  
- Quantity Sold  
- Revenue by Customer  
- Product Performance  

---

## ✅ Data Quality Features

- Null value handling  
- Data type validation  
- Duplicate record checks  
- Business rule validations  

---

## 📌 Key Learnings from This Project

- Real-world Data Warehousing workflow  
- Hands-on experience with ETL pipelines  
- Strong understanding of dimensional modeling  
- SQL performance optimization  
- Professional documentation practices  

---

## 👩‍💻 Author

**Your Name Here**  
Data Engineering Intern | SQL Developer  
Pakistan 🇵🇰  

---

## 📜 License

This project is licensed for learning and portfolio use.
