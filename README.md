# Motorcycle Parts Sales Analysis - SQL Project

## 📊 Project Overview
This repository contains a comprehensive SQL analysis of motorcycle parts sales data. The project demonstrates advanced SQL techniques to extract valuable business insights, optimize sales strategies, and understand customer purchasing patterns in the motorcycle parts industry.

## 🎯 Objectives
- Analyze sales trends and patterns over time
- Identify top-selling products and categories
- Evaluate customer purchasing behavior
- Calculate key performance indicators (KPIs)
- Provide data-driven recommendations for business growth

## 🗂️ Database Schema
The analysis is performed on a relational database with the following structure:

### Tables:
- **Customers**: Customer demographic and contact information
- **Products**: Product details including categories, prices, and specifications
- **Orders**: Order headers with dates, customer references, and order status
- **OrderDetails**: Line items with product quantities, prices, and discounts
- **Suppliers**: Vendor information for parts sourcing

## 🔍 Key Analysis Areas

### 1. Sales Performance
- Monthly/quarterly sales trends
- Year-over-year growth analysis
- Top-performing product categories
- Regional sales distribution

### 2. Customer Analysis
- Customer segmentation by purchase behavior
- Repeat customer rate analysis
- Customer lifetime value calculation
- Geographic distribution of customers

### 3. Product Analysis
- Best-selling products by volume and revenue
- Profit margin analysis across categories
- Seasonal demand patterns for different parts
- Inventory turnover rates

### 4. Operational Efficiency
- Order fulfillment timelines
- Supplier performance metrics
- Discount impact on sales volume and revenue

## 🛠️ Technical Skills Demonstrated

### SQL Techniques:
- Complex JOIN operations across multiple tables
- Advanced window functions (RANK, PARTITION, LEAD/LAG)
- Common Table Expressions (CTEs) for modular query design
- Aggregate functions with GROUP BY and HAVING clauses
- Date/time functions for temporal analysis
- Conditional logic with CASE statements

### Data Analysis:
- Trend analysis and seasonality detection
- Cohort analysis for customer retention
- RFM (Recency, Frequency, Monetary) analysis
- Correlation analysis between promotions and sales

## 📈 Sample Insights

1. **Top 3 product categories** by revenue in the last fiscal year
2. **15% increase** in online sales compared to the previous year
3. **25% of total revenue** comes from returning customers
4. **Engine parts** show the highest profit margin at 42%
5. **November** is the peak sales month due to holiday promotions

## 🚀 How to Use This Repository

### Prerequisites
- SQL database management system (MySQL, PostgreSQL, SQL Server, etc.)
- Basic understanding of SQL syntax and relational databases

### Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/tanvirhasan010/Motorcycle-Parts-Sale-Analyze-in-SQL.git
   ```

2. Set up the database by executing the schema and sample data scripts

3. Explore the SQL queries in the `/queries` directory:
   - Start with the basic analysis scripts
   - Progress to more complex analytical queries
   - Review the insights and recommendations document

### File Structure
```
├── database_setup/
│   ├── schema.sql          # Database schema definition
│   └── sample_data.sql     # Sample data insertion
├── queries/
│   ├── sales_analysis/     # Sales-related queries
│   ├── customer_analysis/  # Customer-focused queries
│   ├── product_analysis/   # Product performance queries
│   └── operational_analysis/ # Business operations queries
├── results/                # Sample output and visualizations
└── documentation/          # Additional documentation
```

## 📋 Future Enhancements
- Integration with BI tools for visualization
- Predictive analytics for sales forecasting
- Customer churn prediction model
- Real-time inventory management system

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📄 License
This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author
**Tanvir Hasan**
- GitHub: [@tanvirhasan010](https://github.com/tanvirhasan010)

## 🙏 Acknowledgments
- Inspired by real-world business intelligence challenges
- Thanks to the SQL community for best practices and techniques

