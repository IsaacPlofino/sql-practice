#BLOCK 1: Variables and Data Types
print("Block 1: Variables and Data Types")

#String — text data
customer_name = "Alice Reyes"
country = "Philippines"
status = "Completed"

#Integer — whole numbers
order_id = 1001
quantity = 5

#Float — decimal numbers
price = 1500.00

#Boolean — True or False
is_valid = True

#Basic Operations
revenue = quantity * price  # Calculate total revenue
discount = revenue * 0.1  # Calculate a 10% discount
final_amount = revenue - discount  # Calculate final amount after discount

#Print results to verify
print("Customer Name:", customer_name)
print("Order ID:", order_id)
print("Revenue:", revenue)
print("Discount:", discount)
print("Final Amount:", final_amount)

#BLOCK 2: Lists and Dictionaries
print("\nBlock 2: List and Dictionaries")

#List — like a single column of data
customer_name = ["Alice Reyes", "Bob Santos", "Clara Mendoza", "Eva Torres"]
quantities = [5, 3, 8, 0]

#Accessing items by position (starts at 0, not 1)
print("First customer:", customer_name[0])
print("Third customer:", customer_name[2])

#Looping through a list
print("\nAll customers:")
for name in customer_name:
    print(" -",name)
    
#Dictionarty — like one row of data
orders = {
    "order_id": 1001,
    "customer_name": "Alice Reyes",
    "quantity": 5,
    "price": 1500.00,
    "status": "Completed"
}

#Accessing dictionary values by key
print("\nOrder ID:", orders["order_id"])
print("Status:", orders["status"])

#List of dictionaries like a full table
orders = [
    {"order_id": 1001, "customer_name": "Alice Reyes", "quantity": 5, "price":1500.00, "status": "completed"},
    {"order_id": 1002, "customer_name": "Bob Santos", "quantity": 3, "price":12000.00, "status": "pending"},
    {"order_id": 1003, "customer_name": "Clara Mendoza", "quantity": 8, "price":150.00, "status": "completed"},
    {"order_id": 1004, "customer_name": "Eva Torres", "quantity": 0, "price":1500.00, "status": "cancelled"} 
]

#Loop through the table and print each order
print("\nAll orders:")
for order in orders:
    print(f" Order {order['order_id']} - {order['customer_name']} - {order['status']}")
    

#BLOCK 3: Loops and Conditionals
print("\nBlock 3: Loops and Conditionals")

orders = [
    {"order_id": 1001, "customer_name": "Alice Reyes", "quantity": 5, "price": 1500.00, "status": "completed"},
    {"order_id": 1002, "customer_name": "Bob Santos", "quantity": 3, "price": 12000.00, "status": "pending"},
    {"order_id": 1003, "customer_name": "Clara Mendoza", "quantity": 8, "price": 150.00, "status": "completed"},
    {"order_id": 1004, "customer_name": "Eva Torres", "quantity": 0, "price": 1500.00, "status": "Cancelled"}
]

#Loop through every order and calculate revenue
print("Revenue per order:")
for order in orders:
    revenue = order["quantity"] * order["price"]
    print(f" Order {order['order_id']}: {revenue}php")
    
#Conditional - filter only completed orders
print("\nCompleted orders only:")
for order in orders:
    if order['status'] == "completed":
        print(f" {order['customer_name']} - {order['quantity'] * order['price']}php")

#if/elif/else - categorize orders by revenue
print("\nOrder Categories:")
for order in orders:
    revenue = order["quantity"] * order["price"]
    if revenue == 0:
        category = "Zero Revenue"
    elif revenue < 2000:
        category = "Low"
    elif revenue <= 10000:
        category = "Mid"
    else:
        category = "High"
    print(f" Order {order['order_id']}: {category} ({revenue}php)")
    
    
#Block 4 - Functions
print("\nBlock 4: Functions")
    
#Define a function to calculate revenue
def calculate_revenue(quantity, price):
        return quantity * price
    
#Define a function to categorize revenue
def categorize_revenue(revenue):
    if revenue == 0:
        return "Zero Revenue"
    elif revenue < 2000:
        return "Low"
    elif revenue <= 10000:
        return "Mid"
    else:
        return "High"
        
#Define a funtion to validate an order
def is_valid_order(order):
    if order["quantity"] <= 0:
        return False
    if order["status"] == "cancelled":
        return False
    return True

#Now apply all the three functions to every order
orders = [
    {"order_id": 1001, "customer_name": "Alice Reyes", "quantity": 5,"price": 1500.00, "status": "completed"},
    {"order_id": 1002, "customer_name": "Bob Santos", "quantity": 3,"price": 12000.00, "status": "pending"},
    {"order_id": 1003, "customer_name": "Clara Mendoza", "quantity": 8,"price": 150.00, "status": "completed"},
    {"order_id": 1004, "customer_name": "Eva Torres", "quantity": 0,"price": 1500.00, "status": "cancelled"}
]

print("Order Summary:")
for order in orders:
    revenue = calculate_revenue(order["quantity"], order["price"])
    category = categorize_revenue(revenue)
    valid = is_valid_order(order)
    print(f" Order: {order['order_id']} | Revenue: {revenue} | Category: {category} | Valid: {valid}")
    

# BLOCK 5 - Reading and Writing CSV Files
print("\nBlock 5: Reading and Writing CSV Files")

import csv

# EXTRACT: Read from source CSV
print("\nBlock 5: CSV Files")
print("Extracting from orders.csv...")

raw_orders = []

with open("orders.csv", "r") as file:
    reader = csv.DictReader(file)
    for row in reader:
        raw_orders.append(row)

print(f" {len(raw_orders)} records extracted")

#TRANSFORM: Clean and calculate
print("Transforming records...")

transformed_orders = []

for order in raw_orders:
    #CSV reads everything as strings and convert type first
    order_id = int(order["order_id"])
    quantity = int(order["quantity"])
    price = float(order["price"])
    status = order["status"].strip().lower()
    
    #Apply transformation logic
    revenue = calculate_revenue(quantity, price)
    category = categorize_revenue(revenue)
    valid = is_valid_order({"quantity": quantity, "status": status})
    
    #Build the transformed record
    transformed_orders.append({
        "order_id": order_id,
        "customer_name": order["customer_name"],
        "quantity": quantity,
        "price": price,
        "status": status,
        "revenue": revenue,
        "category": category,
        "is_valid": valid
    })
    
print(f" {len(transformed_orders)} records transformed")

#LOAD: Write to output CSV
print("Loading to output_orders.csv...")

with open("output_orders.csv", "w", newline="") as file:
    fieldnames = ["order_id", "customer_name", "quantity",
                  "price", "status", "revenue", "category", "is_valid"]
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(transformed_orders)

print(" Done. output_orders.csv created.")
print("\nFinal output:")
for order in transformed_orders:
    print(f" Order {order['order_id']} | {order['customer_name']} | "
          f"Revenue: {order['revenue']} | Category: {order['category']} | "
          f"Valid: {order['is_valid']}")
    
#BLOCK 6: Pandas Basics
import pandas as pd

print("\nBLOCK 6: Pandas Basics")

#Load CSV into a DataFrame
df = pd.read_csv("orders.csv")

print("Raw data:")
print(df)

#Basic inspection
print(f"\nShape: {df.shape[0]} rows, {df.shape[1]} columns")
print(f"\nColumn names: {list(df.columns)}")
print(f"\nData types:\n{df.dtypes}")

#Ass a calculated colum
df["revenue"] = df["quantity"] * df["price"]

#Filter rows like WHERE in SQL
completed = df[df["status"] == "completed"]
print(f"\nCompleted orders only:")
print(completed[["order_id", "customer_name","revenue"]])

#Aggregate like GROUP BY in SQL
print(f"\nTotal revenue by status:")
print(df.groupby("status")["revenue"].sum())

#Save transformed DataFrame to CSV
df.to_csv("output_pandas.csv", index=False)
print("\noutput_pandas.csv saved.")
