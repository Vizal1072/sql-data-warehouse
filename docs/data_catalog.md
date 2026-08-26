
# Data Dictionary for Gold Layer

## Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension
tables** and **fact tables** for specific business metrics.

---

## 1.gold.dim_customers
* Purpose : Stores customer details enriched with demographic and geographic data.
* Columns:
  
| Column Name | Data Type |     Description      |
|-------------|-----------|----------------------|
| customer_key | INT       | Surrogate key uniquely identifying each customer record in the dimension table.|
| customer_id | INT |Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50)| Alphanumeric identifier repersenting the customer, used for tracking and referencing.|
| first_name | NVARCHAR(50) | The customer's first name.|
| last_name | NVARCHAR(50) | The customer's last name. |
| country | NVARCHAR(50) | The country of residence for the customer. |
| marital_status | NVARCHAR(50) | The marital status of the customer. |
| gender | NVARCHAR(50) | The gender of the customer. |
| birthdate | DATE | The date of the birth of customer. |
| create_date | DATE | The date and time when the customer record was created in the system. |

---

## 2.gold.dim_products
* Purpose : Provides information about the products and their attributes.
* Columns:

| Column Name | Data Type |     Description      |
|-------------|-----------|----------------------|
| product_key |  INT | Surrogate key uniquely each product record in product dimension table. |
| product_id | INT | Unique Identifier assigned to the product for internal tracking and referencing. |
| product_number |  NVARCHAR(50) | A structured alphanumeric code representing the product, often used for referencing. |
| product_name | NVARCHAR(50) | Descriptive name of product, including key details. |
| category_id |  NVARCHAR(50) | Unique Indentifier for product's category. |
| category |  NVARCHAR(50) | The broader classification of the product. |
| sub_category |  NVARCHAR(50) | A more detailed classification of the product. |
| maintenance |  NVARCHAR(50) | Indicates whether the product requires maintenance. |
| cost | INT | The cost or base price of the product. |
| product_line |  NVARCHAR(50) | The specific product line or series. |
| start_date | DATE |The date when the product became available for sale. |

---

## 3.gold.dim_products
* Purpose : Transactional events and sales data fro analytics purpose.
* Columns:

| Column Name | Data Type |     Description      |
|-------------|-----------|----------------------|
| order_number | NVARCHAR(50) | A unique alphanumeric identifier for sales order. |
| product_key |  INT | Surrogate key uniquely each product record in product dimension table. |
|  customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension table.|
| order_date | DATE | The date when the order was placed. |
| shipping_date | DATE | The date when the order was shipped to the customer. |
| due_date | DATE | The date when the order payment was due. |
| sales_amount | INT | The total monetary value of the sale for the line. |
| quantity | INT | The number of units of the product ordered for the line item. |
| price | INT | The price per unit of the product for the line item. |
