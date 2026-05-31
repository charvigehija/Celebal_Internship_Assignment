# Basic Data Exploration and Cleaning using Pandas

## Project Overview

This project demonstrates basic data exploration and data cleaning techniques using the Pandas library in Python.

The dataset used is an Ecommerce Dataset containing information about products, pricing, ratings, sellers, categories, discounts, and customer reviews.

The primary goal of this project is to prepare raw data for further analysis by handling missing values, removing duplicate records, cleaning price columns, and creating derived features.

---

## Objectives

* Load a CSV dataset into a Pandas DataFrame
* Explore dataset structure and contents
* Analyze column names and data types
* Identify and handle missing values
* Remove duplicate records
* Clean price-related columns
* Create a derived column
* Perform basic data analysis
* Save the cleaned dataset

---

## Dataset Information

The dataset contains ecommerce product information with the following attributes:

* Product ID
* Product Title
* Product Description
* Rating
* Ratings Count
* Initial Price
* Discount
* Final Price
* Currency
* Images
* Delivery Options
* Product Details
* Product Specifications
* Seller Information
* Category
* Customer Reviews
* Sizes
* Product Variations
* Offers

### Dataset Shape

* Rows: 1000
* Columns: 24

---

## Technologies Used

* Python
* Pandas
* NumPy
* Matplotlib
* Jupyter Notebook

---

## Project Workflow

### 1. Import Libraries

Imported the required libraries:

* Pandas
* NumPy
* Matplotlib

### 2. Load Dataset

Loaded the Ecommerce dataset into a Pandas DataFrame.

### 3. Data Exploration

Performed basic exploration using:

* head()
* tail()
* shape
* columns
* info()
* describe()

### 4. Missing Value Analysis

Checked missing values in all columns using:

```python
df.isnull().sum()
```

### 5. Missing Value Handling

Applied the following strategy:

* Text columns → Filled with "Unknown"
* Numerical columns → Filled with median values

### 6. Duplicate Removal

Detected duplicate rows and removed them using:

```python
df.drop_duplicates()
```

### 7. Category Analysis

Analyzed product distribution across categories.

Top categories included:

* Tops
* Dresses
* Shirts
* Jeans
* Sports Shoes

### 8. Seller Analysis

Identified sellers with the highest number of listed products.

### 9. Rating Analysis

Analyzed customer ratings and identified highly rated products.

### 10. Price Cleaning

The `final_price` column contained values such as:

```text
₹3,995.00
₹2,899.00
```

Cleaning steps performed:

* Removed quotation marks
* Removed currency symbols
* Removed commas
* Converted values to numeric format

### 11. Create Derived Column

Created a new column:

```python
discount_amount = initial_price - final_price
```

This represents the actual discount provided on a product.

### 12. Save Cleaned Dataset

Saved the cleaned dataset as:

```text
cleaned_ecommerce_dataset.csv
```

---

## Results

### Data Cleaning Results

* Missing Values Removed: Yes
* Duplicate Records Removed: Yes
* Price Columns Cleaned: Yes
* Derived Column Created: Yes
* Cleaned Dataset Saved: Yes

### Validation Results

```text
Missing Values: 0
Duplicate Rows: 0
Discount Column Exists: True
Saved File Exists: True
```

---

## Files Included

```text
Basic_Data_Cleaning_Project/
│
├── archive/
│   └── Combined_dataset.csv
│
├── Basic_Data_Cleaning.ipynb
├── cleaned_ecommerce_dataset.csv
└── README.md
```

---

## Output

The final output of this project is:

* Cleaned Ecommerce Dataset
* Jupyter Notebook containing all cleaning steps
* Project Documentation

---

## Conclusion

The Ecommerce Dataset was successfully explored, cleaned, and analyzed using Pandas.

The project demonstrates essential data preprocessing techniques such as handling missing values, removing duplicates, cleaning numerical fields, creating derived features, and performing exploratory data analysis.

The cleaned dataset is now ready for visualization, business analysis, and machine learning applications.
