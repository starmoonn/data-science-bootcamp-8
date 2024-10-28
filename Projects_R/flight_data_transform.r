library(tidyverse)
library(RSQLite)
library(glue)
library(lubridate)
library(sqldf)
library(googlesheets4)
library(nycflights13)
library(RSQLite)
library(RPostgreSQL)


# 1 In the 7th month, which airline had the most delays? (TOP 5)
flights %>%
  filter(month == 7) %>%
  select(month, carrier, dep_delay) %>%
  arrange(desc(dep_delay)) %>%
  head(5) %>%
  inner_join(airlines, by = "carrier")

#2 In the fourth month, which airline spends the most air time? (TOP 5)
flights %>%
  filter(month == 4) %>%
  select(month,carrier,air_time) %>%
  arrange(desc(air_time)) %>%
  head(5) %>%
  inner_join(airlines, by = "carrier")


#3 On the 5th day of the 1st month from the departure station to the destination station, from where to where does it take the least time?
flights %>%
  filter(day == 5 & month == 1) %>%
  select(day,month,origin, dest,air_time) %>%
  arrange(air_time) %>%
  head(5) 
  
#4  Airlines have the lowest number of hour in September ? (TOP 5)
flights %>%
  filter(month == 9) %>%
  group_by(carrier) %>%
  summarise(Total_hours = sum(hour)) %>%
  arrange(Total_hours) %>%
  head(5)

#5 Months 1-6, which month takes the longest scheduled departure to SEA station, broken down in hours and minutes? (TOP 10)
flights %>%
  filter(month <= 6 & dest == "SEA") %>%
  select(carrier,day,month,dest,hour,minute) %>%
  arrange(desc(hour),desc(minute)) %>%
  head(10) %>%
  inner_join(airlines, by = "carrier")



# section 2
library(RPostgreSQL)
library(tidyverse)

con <- dbConnect(PostgreSQL(),
                 host = "arjuna.db.elephantsql.com",
                 port = 5432,
                 user = "txsewzte",
                 password = "6EkAKTlxCTDv1YlHYqN1w1niRryLh84b",
                 dbname = "txsewzte")
dbListTables(con)

pizza_menu <- data.frame(pizza_id = 1:10,
                         name = c("Hawaiian",
                                  "Seafood",
                                  "Pepperoni",
                                  "Pasta",
                                  "Chicken",
                                  "Cheese",
                                  "French fries",
                                  "Tex Mex",
                                  "Margharita",
                                  "Salad"),
                         price = c(420,
                                   650,
                                   450,
                                   230,
                                   150,
                                   50,
                                   100,
                                   480,
                                   700,
                                   120))

dbWriteTable(con,"pizza_menu",pizza_menu)

customer <- data.frame(cus_id = 1:8,
                       name = c("IU",
                                "Lisa",
                                "Jisoo",
                                "Rose",
                                "Jennie",
                                "Suzy",
                                "Messi",
                                "Ronaldo"),
                       country = c(rep("Korea",6),
                                   "Argentina",
                                   "Potugal"))
dbWriteTable(con,"customer",customer)

orders <- data.frame(order_id = 1:4,
                   pizza_id = c(2,5,9,10),
                   cus_id = c(2,6,8,1),
                   pizza_quantity = c(1,3,2,4),
                   Total_price = c(650,450,1400,480))
dbWriteTable(con,"orders",orders)

dbListTables(con)

dbGetQuery(con,"select * from pizza_menu")
dbGetQuery(con,"select * from customer")
dbGetQuery(con,"select * from orders")

dbGetQuery(con,"select a.order_id, a.pizza_id, b.name from 
                orders AS a JOIN pizza_menu AS b 
                ON a.pizza_id = b.pizza_id")

dbGetQuery(con,"select a.order_id, b.name, a.pizza_quantity from 
                orders AS a JOIN customer AS b
                ON a.cus_id = b.cus_id")


dbGetQuery(con,"select b.order_id ,b.cus_id ,c.name ,b.pizza_id ,a.name ,b.pizza_quantity from 
                pizza_menu AS a JOIN orders AS b
                ON a.pizza_id = b.pizza_id
                JOIN customer AS c
                ON c.cus_id = b.cus_id")
