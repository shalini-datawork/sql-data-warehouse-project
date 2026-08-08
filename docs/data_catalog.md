# Gold Layer — Data Catalog

## Overview

The Gold layer contains business-ready dimensional and fact tables designed for analytics and reporting.

| Object | Type | Purpose | Grain |
|---|---|---|---|
| `gold.dim_customer` | Dimension | Customer master information enriched with ERP location and demographic data | One row per customer |
| `gold.dim_products` | Dimension | Current product information enriched with ERP category data | One row per current product |
| `gold.fact_sales` | Fact | Sales transactions linked to customer and product dimensions | One row per sales transaction |

### Data Flow

```text
CRM Customer ─────┐
ERP Customer ─────┼──> gold.dim_customer
ERP Location ─────┘

CRM Product ──────┐
ERP Product Cat ──┴──> gold.dim_products

CRM Sales ─────────────┐
dim_customer ──────────┼──> gold.fact_sales
dim_products ──────────┘
```

---

# 1. `gold.dim_customer`
## Overview

Customer dimension containing **customer identity, personal information, location, and demographic attributes**.

- CRM is the **master source for gender** when available.
- ERP gender is used as a fallback.
- Customer location comes from ERP.
- `customer_key` is the surrogate key used by the Gold layer.

| Attribute | Description | Example / Values |
|---|---|---|
| `customer_key` | Surrogate key for the customer | `1`, `2`, `3` |
| `customer_id` | Original CRM customer ID | `101`, `102` |
| `customer_number` | Business/customer identifier | `AW00011000` |
| `first_name` | Customer first name | `John` |
| `last_name` | Customer last name | `Smith` |
| `country` | Customer country | `United States`, `Germany`, `n/a` |
| `marital_status` | Customer marital status | `Married`, `Single`, `n/a` |
| `gender` | Customer gender | `Male`, `Female`, `n/a` |
| `birthdate` | Customer date of birth | `1985-06-15` |
| `create_date` | Customer creation date | `2010-01-29` |

### Known Categorical Values

| Attribute | Unique Values |
|---|---|
| `marital_status` | `Married`, `Single`, `n/a` |
| `gender` | `Male`, `Female`, `n/a` |
| `country` | Dataset-dependent; e.g. `United States`, `Germany`, `n/a` |

### Key Relationships

```text
dim_customer.customer_key
        ↑
        │
fact_sales.customer_key
```

`customer_key` is used as the dimensional key in `fact_sales`.

---

# 2. `gold.dim_products`

## Overview

Product dimension containing **current product information and product category hierarchy**.

Historical product versions are excluded using:

```sql
WHERE pn.prd_end_dt IS NULL
```

The product dimension combines CRM product information with ERP category information.

| Attribute | Description | Example / Values |
|---|---|---|
| `product_key` | Surrogate key for the product | `1`, `2`, `3` |
| `product_id` | Original product ID | `101`, `102` |
| `product_number` | Business/product identifier | `BK-R19B-44` |
| `product_name` | Product name | `Road-150 Red` |
| `category_id` | Product category identifier | `AC_BR` |
| `category` | Product category | `Bikes`, `Components` |
| `subcategory` | Product subcategory | `Road Bikes`, `Brakes` |
| `maintenance` | Product maintenance category | `Yes`, `No` |
| `cost` | Product cost | `150` |
| `product_line` | Product business line | `Mountain`, `Road`, `Other Sales`, `Touring`, `n/a` |
| `start_date` | Date the current product version became active | `2012-05-30` |

### Known Categorical Values

| Attribute | Unique Values |
|---|---|
| `product_line` | `Mountain`, `Road`, `Other Sales`, `Touring`, `n/a` |
| `category` | Dataset-dependent |
| `subcategory` | Dataset-dependent |
| `maintenance` | Dataset-dependent |

### Key Relationships

```text
dim_products.product_key
        ↑
        │
fact_sales.product_key
```

`product_key` is used as the dimensional key in `fact_sales`.

---

# 3. `gold.fact_sales`

## Overview

Sales fact table containing **transaction-level sales measures and dates**, connected to the Customer and Product dimensions.

The table supports analysis of:

- Sales
- Quantity
- Price
- Customers
- Products
- Orders
- Shipping and due dates

### Grain

> **One row represents one sales transaction/order line.**

| Attribute | Description | Example / Values |
|---|---|---|
| `order_number` | Sales order identifier | `SO43659` |
| `product_key` | Foreign key to `dim_products` | `1`, `25`, `100` |
| `customer_key` | Foreign key to `dim_customer` | `1`, `50`, `250` |
| `order_date` | Date the order was placed | `2011-05-31` |
| `shipment_date` | Date the order was shipped | `2011-06-07` |
| `due_date` | Expected/due delivery date | `2011-06-12` |
| `sales_amount` | Total sales amount for the transaction | `3578` |
| `quantity` | Number of units sold | `2`, `5`, `10` |
| `price` | Price per unit | `1789` |

### Measures

| Measure | Description | Example |
|---|---|---|
| `sales_amount` | Total sales value for the transaction | `3578` |
| `quantity` | Number of units sold | `2` |
| `price` | Unit selling price | `1789` |

### Foreign Keys

| Column | References | Purpose |
|---|---|---|
| `product_key` | `gold.dim_products.product_key` | Identifies the product |
| `customer_key` | `gold.dim_customer.customer_key` | Identifies the customer |

---

# Gold Layer Relationship

```text
                    ┌──────────────────────┐
                    │   dim_customer       │
                    │──────────────────────│
                    │ customer_key (PK)    │
                    │ customer_id          │
                    │ customer_number      │
                    │ first_name           │
                    │ last_name            │
                    │ country              │
                    │ gender               │
                    │ birthdate            │
                    └──────────┬───────────┘
                               │
                               │ customer_key
                               │
                               ▼
                    ┌──────────────────────┐
                    │     fact_sales       │
                    │──────────────────────│
                    │ order_number         │
                    │ product_key (FK)     │
                    │ customer_key (FK)    │
                    │ order_date           │
                    │ shipment_date        │
                    │ due_date             │
                    │ sales_amount         │
                    │ quantity             │
                    │ price                │
                    └──────────┬───────────┘
                               │
                               │ product_key
                               │
                               ▼
                    ┌──────────────────────┐
                    │   dim_products       │
                    │──────────────────────│
                    │ product_key (PK)     │
                    │ product_id           │
                    │ product_number       │
                    │ product_name         │
                    │ category             │
                    │ subcategory          │
                    │ product_line         │
                    │ cost                 │
                    └──────────────────────┘
```

---

## Quick Reference

| Gold Object | Role | Main Business Question |
|---|---|---|
| `dim_customer` | Dimension | **Who** are our customers? |
| `dim_products` | Dimension | **What** are we selling? |
| `fact_sales` | Fact | **What was sold, to whom, when, and for how much?** |

The Gold layer follows a **star schema**, with `fact_sales` at the center and `dim_customer` and `dim_products` providing descriptive context for sales analysis.
