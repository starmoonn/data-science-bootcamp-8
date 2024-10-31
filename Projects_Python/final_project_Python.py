import pandas as pd

df = pd.read_csv('sample-store.csv')
df

df.head()

df.shape

df.info()

pd.to_datetime(df['Order Date'].head(), format = '%m/%d/%Y')

# convert order date and ship date to datetime in the original dataframe
df['Order Date'] = pd.to_datetime(df['Order Date'], format = '%m/%d/%Y')
df['Ship Date'] = pd.to_datetime(df['Ship Date'], format = '%m/%d/%Y')

# count nan in postal code column
df['Postal Code'].isna().sum()

# count nan in each column
df.isna().sum()

# filter rows with missing values
df[df['Postal Code'].isna()]

# Explore this dataset on your owns, ask your own questions

"""## Data Analysis"""

# how many columns, rows in this dataset
df.shape

# is there any missing values?, if there is, which colunm? how many nan values?
df.isna().sum()

# your friend ask for `California` data, filter it and export csv for him
df[df['State'] == 'California'].to_csv('california_data.csv')

# your friend ask for all order data in `California` and `Texas` in 2017 (look at Order Date)
df['Order Date'] = pd.to_datetime(df['Order Date'], format='%m/%d/%Y')
filtered_data = df[
    (df['State'].isin(['California', 'Texas'])) &
    (df['Order Date'].dt.year == 2017)
]
filtered_data

# which Segment has the highest profit in 2018
df[df["Order Date"].dt.year == 2018].groupby("Segment")["Profit"].sum().sort_values(ascending=False).index[0]

# which top 5 States have the least total sales between 15 April 2019 - 31 December 2019
df[(df['Order Date'] >= pd.to_datetime('2019-04-15')) &
 (df['Order Date'] <= pd.to_datetime('2019-12-31'))].groupby('State')['Sales'].sum().sort_values().head(5)

# what is the proportion of total sales (%) in West + Central in 2019 e.g. 25%

# Calculate the total sales for West and Central regions in 2019
west_central_sales_2019 = df[
    (df['Region'].isin(['West', 'Central'])) &
    (df['Order Date'].dt.year == 2019)
]['Sales'].sum()

# Calculate the total sales for all regions in 2019
total_sales_2019 = df[df['Order Date'].dt.year == 2019]['Sales'].sum()

# Calculate the proportion of sales
proportion_west_central = (west_central_sales_2019 / total_sales_2019) * 100

print(f"{proportion_west_central:.2f}%")

# find top 10 popular products in terms of number of orders vs. total sales during 2019-2020
filtered_df = df[(df['Order Date'].dt.year >= 2019) & (df['Order Date'].dt.year <= 2020)]
product_rank = filtered_df.groupby('Product Name').agg(
    total_orders=('Order ID', 'nunique'),  # 'nunique' counts unique orders
    total_sales=('Sales', 'sum')
)
top_10_orders = product_rank.sort_values(by=['total_orders', 'total_sales'], ascending=False).head(10)
top_10_sales = product_rank.sort_values(by=['total_sales', 'total_orders'], ascending=False).head(10)
print("Top 10 products by number of orders:\n", top_10_orders)
print("\nTop 10 products by total sales:\n", top_10_sales)

# plot at least 2 plots, any plot you think interesting
import matplotlib.pyplot as plt

# Plot 1: Sales by Region
sales_by_region = df.groupby('Region')['Sales'].sum()
plt.figure(figsize=(8, 6))
plt.bar(sales_by_region.index, sales_by_region.values)
plt.xlabel("Region")
plt.ylabel("Total Sales")
plt.title("Total Sales by Region")
plt.show()


# Plot 2: Sales Trend over Time
df['Order Month'] = df['Order Date'].dt.to_period('M')
sales_by_month = df.groupby('Order Month')['Sales'].sum()
plt.figure(figsize=(10, 6))
plt.plot(sales_by_month.index.astype(str), sales_by_month.values)
plt.xlabel("Order Month")
plt.ylabel("Total Sales")
plt.title("Sales Trend over Time")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

#  use np.where() to create new column in dataframe to help you answer your own questions
import numpy as np
import matplotlib.pyplot as plt
# Create a new column 'High_Profit_Margin'
df['High_Profit_Margin'] = np.where(df['Profit'] > df['Sales'] * 0.2, 'Yes', 'No')
high_profit_orders = df[df['High_Profit_Margin'] == 'Yes']
high_profit_segments = high_profit_orders.groupby('Segment')['Profit'].sum()


plt.bar(high_profit_orders['Product Name'].value_counts().index[:10], high_profit_orders['Product Name'].value_counts().values[:10])
plt.xlabel("Product Name")
plt.ylabel("Number of Orders")
plt.title("Top 10 High-Profit Products")
plt.xticks(rotation=90)
plt.show()
