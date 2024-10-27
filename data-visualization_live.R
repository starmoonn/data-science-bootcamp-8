library(tidyverse)

# intro to data viz
## grammar of graphic

# How to select chart
# มีหลักการ 2 แบบหลักๆ คือ
# 1.จำนวนตัวแปร ถ้าเรารู้ว่าจำนวนแปรเรามีกี่ตัวเราจะเลือกกราฟได้ดีขึ้น
# 2.เป็นตัวแปรประเภทไหนบ้าง
# ไปดูในpdf ที่โหลดมาได้ว่า 1 variable ควรใช้แบบไหน 2 variable ควรใช้แบบไหน
# dis crete จะไม่มีทศนิยม แต่ continus มีทศนิยมได้

mtcars <- tibble(mtcars)

# syntax (grammar)
# ggplot will get 3 things is data mapping chartที่ต้องการจะพอต
# ตรง mapping มี aes มาจากคำว่าความสวยงาม
ggplot(data = mtcars,
       mapping = aes(x = mpg,y = hp)) + 
  geom_point()

ggplot(data = mtcars,
       mapping = aes(x = mpg)) + 
  geom_histogram()

ggplot(data = mtcars,
       mapping = aes(x = mpg)) +
  geom_boxplot()

#one variables - continuous
# no parameter name
# ตัวแรกที่อยู่ใน aes มันจะเป็นแกน x อยูแล้ว
# bins ก็คือจำนวน bar
ggplot(mtcars,aes(mpg)) + 
  geom_histogram(bins=10)

ggplot(mtcars,aes(mpg)) + 
  geom_density()

#base layer
base <- ggplot(data = mtcars,
       mapping = aes(x = mpg))

base + geom_boxplot()
base + geom_histogram(bins = 5)
base + geom_freqpoly(bins = 8)
# ใส่สี
base + geom_histogram(bins =10,fill = "gold")
base + geom_histogram(bins = 5,fill = "#03fcc2")

# one variables - discrete
student <- data.frame(id = 1:5, 
                      gender =c("M","M","M","F","F"))

ggplot(data = student,
       mapping = aes(x = gender)) +
  geom_bar()

## two variables , both continuous
base2 <- ggplot(mtcars,aes(x = hp,y = mpg))
base2 + geom_point()
base2 + geom_smooth()

# can ซ้อน layer ได้
base2 + 
  geom_point() +
  geom_smooth() +
  geom_rug()

# we can ปรับ size color alpha(ความจางของชาร์จ)
# ค่ายิ่งน้อยสียิ่งจาง
# geom_rug เส้นประข้างๆ เส้นไหนที่มีเส้นประ เยอะๆ ตรงนั้นมีการกระจุกตัวมาก
base2 + geom_point(size = 5,col = "red",alpha = 0.5) +
        geom_rug()

# linear model (lm)
base2 +
  geom_smooth(method = "lm",
              col = "brown",
              fill = "gold") +
  geom_point() +
  theme_minimal() # มันจะทำให้พื้นหลังสีเทาหายไป ชาร์จจะเด่นขึ้นมาเลย
  # ทำ theme minimal มันจะทำให้พื้นหลังเป็นสีขาว chart มันจะเด่นขึ้น

## two variables , one discrete
## one continuous
glimpse(diamonds) #glimpse คือการส่อง dataframe
# เราจะเห็น data type ord คือมันจะเป็นตัวที่เรียงสูงกลางต่ำได้
diamonds$cut %>% head
diamonds$color %>% head
diamonds$clarity %>% head

# cut,color,clarity ก็เป็น dimension
# ตัวแปร cut ในที่นี้เหมือนเหมือนเป็น Dimension ส่วน price เป็น matrix
# หน้าที่ของ Dimension ก็จะคือ ซอยย่อยmatrix แบ่งตามกลุ่ม
# ถ้าเราดูเราจะรู้ว่า ข้อมูลใน premium กระจายตัวเยอะที่สุด
ggplot(diamonds,
       aes(x = cut, y = price)) +
  geom_boxplot() # จุดเยอะๆ in chart นี้ คือ outlier

ggplot(diamonds,
       aes(x = clarity, y = carat)) +
  geom_boxplot()
  
ggplot(diamonds,
       aes(x = clarity, y = price)) +
  geom_boxplot()

ggplot(diamonds,
       aes(price)) + # แบบนี้มันจะเอาจุดทุกอันของทั้ง Fair good บลาๆมาหมดเลย
  geom_boxplot()

# ทำเป็นแกนตั้ง
ggplot(diamonds,
       aes(price)) + 
  geom_boxplot() +
  coord_flip()

# boxplot เราจะไม่เห็นค่า distribute เราจะรู้พวกค่า outlier median

# ส่วนแบบนี้ violin plot มันจะเห็น distribution
ggplot(diamonds,
       aes(x = cut, y = price)) +
  geom_violin()

# summarize data => build geom_col
agg_price_by_cut <- diamonds %>%
  group_by(cut) %>%
  summarise(
    med_price = median(price)
  )
# ค่ากลางข้อมูลจัดกลุ่มตามตัวแปร cut
# มันเป็นการเอาค่าmed หรือ ไอเส้นทึบๆตรงกลาง ใน boxplot มาสร้าง chart
# อันด้านบนจะเป็นการ aggregate มาก่อน แล้วอันด้านล่างจะเป็นการ build พวก chart ขึ้นมา
ggplot(agg_price_by_cut,
       aes(cut,med_price)) +
  geom_col()

# หรือเราจะทำแบบนี้ก็ได้
p1 <- diamonds %>%
  group_by(cut) %>%
  summarise(
    med_price = median(price)
  ) %>%
  ggplot(aes(cut,med_price)) + 
  geom_col() + 
  theme_minimal()

# qplot  => quick plot
##ggplot2
qplot(data = diamonds,
      x = price,
      geom = "histogram")
# or (follow adtoy)
# default of bins it will = 30
p2 <- qplot(x = price,
      data = diamonds,
      geom = "histogram",
      bins = 100)

# y = f(x) ,f(x=ตัวแปรต้น) ส่วน , y = ตัวแปรตาม
# ในข้อนี้carat จะเป็นตัวแปรต้น ส่วน price เป็นตัวแปรตาม
# because carat เป็นตัวกำหนด price ยิ่ง carat เยอะ price ก็จะยิ่งสูง
# เวลา plot chart ตัวแปรต้นจะอยู่แกนนอน ส่วนแกนตั้งจะเป็นตัวแปรตาม
# independent variable => x
# dependent variable => y

p3 <- qplot(x = carat,
      y = price,
      data = diamonds,
      geom = "point")

p4 <- qplot(x = cut,
      data = diamonds,
      geom = "bar")

# plot หลายๆ chart มาเรียงต่อกันเลย
library(patchwork)

p1+p2+p3
# or จะเอา p1,p2 อยู่ด้านบน และ p3 อยู่ด้านล่าง
(p1 + p2) / p3

p1/p2/p3

# qplot นี้ใช้ไม่ค่อยบ่อย

nrow(diamonds)
## ggplot()
## overplotting
# วิธีแก้เวลา plot เยอะมาก
ggplot(diamonds, aes(carat,price)) +
  geom_point(alpha = 0.5)

ggplot(diamonds, aes(carat,price)) +
  geom_point(shape = ".") # ตรง . จริงเราใส่เป็นตัวอะไรก็ได้

ggplot(sample_n(diamonds , 500), #การสุ่มแบบ random
       aes(carat,price)) +
  geom_point(alpha = 0.5)

set.seed(42) # lock วิธีเดี๋ยวที่จะเปลี่ยนchart ได้คือ ต้องเปลี่ยนเลขใน set.seed()
ggplot(sample_frac(diamonds , 0.05), #การสุ่มเป็นเปอร์เซนต์
       aes(carat,price)) +
  geom_point(alpha = 0.5)

# ใส่สีไปในข้อมูลแต่ละอัน
set.seed(42) 
ggplot(sample_frac(diamonds , 0.05), 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5)

# ทำแบบนี้ก็ได้จะได้อ่านโค้ดง่ายขึ้น
set.seed(42) 
mini_diamonds <- sample_frac(diamonds , 0.05)
ggplot(mini_diamonds, 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5) +
  theme_minimal() # ทำให้ไม่มีพื้นหลัง

# we will set color by myself
ggplot(mini_diamonds, 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  scale_color_manual(
    values = c("pink","red","gold","green","blue")
  )

# แบบนี้จะเป็นการไปเอาสีใน colorbrewer
# type คือ มันจะอยู่ใน เว็บจะมี sequential diverging qualitative

# sequential
ggplot(mini_diamonds, 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  scale_color_brewer(
    type = "seq",
    palette = 1 
  )
# or จะเอา diverging
ggplot(mini_diamonds, 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  scale_color_brewer(
    type = "div",
    palette = 5 # มีในเว็บว่าจะเอาอันที่เท่าไหร่
  )

# or จะเอา qualitative
ggplot(mini_diamonds, 
       aes(carat,price , col = cut)) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  scale_color_brewer(
    type = "qual",
    palette = 1 # มีในเว็บว่าจะเอาอันที่เท่าไหร่
  )

# map สีของจุดเป็น price (map(col))
# ถ้าตัวแปร ที่เรา map ไปที่ col เป็นตัวแปรที่เป็น continous chart ทางด้านขวามันจะมี color bar โผล่ขึ้นมา
ggplot(mini_diamonds, 
       aes(carat,price , col = price)) +
  geom_point(alpha = 0.5) +
  theme_minimal() + 
  scale_color_gradient(low = "gold", #ราคาน้อยให้เป็นสีทอง ราคาน้อยเป็นสี น้ำเงิน
                       high = "blue") #ใช้กรณีที่ ทางด้านขวาเป็นแบบ color bar หรือ เป็น continuous

# NOTE การที่เราจะเลือก scale_color_....อยู่ที่ col ว่าเป็นตัวแปรประเภทแบบไหน เช่น ตัวอย่างนี้ เป็นแบบ continuous เลยใช้ gredient

## facet 
# เป็นการแบ่ง chart ใหญ่ เป็น chart ย่อยๆ
#segment our charts into groups
# Example facet wrap
ggplot(mini_diamonds, 
       aes(carat,price , col = price)) +
  geom_point(alpha = 0.5) +
  theme_minimal() + 
  scale_color_gradient(low = "gold", 
                       high = "blue") +
  facet_wrap(~cut) # หรือมันจะเป็นการแบ่ง chart เป็นอันๆไปเลย เช่นอันนี้ มันจะแบ่ง เป็น chart ของ fair 1 อัน ของ good 1 อัน เป็นต้น

# กำหนด จำนวน column 
ggplot(mini_diamonds, 
       aes(carat,price , col = price)) +
  geom_point(alpha = 0.5) +
  theme_minimal() + 
  scale_color_gradient(low = "gold", 
                       high = "blue") +
  facet_wrap(~cut, ncol=3) # เช่นอันนี้ เรียง fair good very good เป็น 3 col ด้านบน แต่ด้านล่างมันมีไม่ครบ 3 เฉยๆ

# Example facet grid
ggplot(mini_diamonds, 
       aes(carat,price , col = price)) +
  geom_point(alpha = 0.5) +
  theme_minimal() + 
  scale_color_gradient(low = "gold", 
                       high = "blue") +
  facet_grid(cut ~ clarity) # มันจะรับ 2 ตัวแปร ตัวแปร 1 เป็นแกนนอน อีกตัวแปร เป็นแกนตั้ง
  # เช่น ตัวอย่างนี้ตัวแปรนอนเป็น cut ตัวแปรตั้งเป็น clarity
  # หรือ facet_grid(ตัวแปรนอน ~ ตัวแปรตั้ง)

# เพิ่ม geom_smooth()
ggplot(mini_diamonds, 
       aes(carat,price , col = price)) +
  geom_point(alpha = 0.5) +
  geom_smooth() +
  theme_minimal() + 
  scale_color_gradient(low = "gold", 
                       high = "blue") +
  facet_grid(cut ~ clarity)

## labels
ggplot(mtcars , aes(hp,mpg)) +
  geom_point() +
  theme_minimal() +
  labs(
    title = "My first scatter plot",
    subtitle = "Awesome work !",
    x = "Horse Power",
    y = "Miles per Gallon",
    caption = "Source R studio"
  ) # นี้คือการกำหนด labels โดยการใช้ ฟังก์ชั่นที่ชื่อว่า labs

# simple bar chart
ggplot(diamonds,aes(cut,fill = color)) +
  geom_bar() +
  theme_minimal()

ggplot(diamonds,aes(cut,fill = color)) +
  geom_bar(position = "dodge") + # ใน position ที่เราใช้บ่อยๆ จะมี fill คือ เป็น 100% ,dodge,stack เป็นต้น
  theme_minimal()

## install more themes for ggplot charts
library(ggthemes)

ggplot(diamonds,aes(cut,fill = color)) +
  geom_bar(position = "dodge") + 
  theme_economist() # themes เพิ่มเติมได้ให้ดูสวยๆเก๋ๆ

ggplot(diamonds,aes(cut,fill = color)) +
  geom_bar(position = "dodge") + 
  theme_economist_white() # เข้าไปดูในเว็บggthemes ได้ มีหลายแบบเลย

# HOMEWORK 1
# ส่งเป็น pdf
# ทำ chart อย่างน้อย 5 chart by use data diamonds
# use diamonds dataset to create 5 charts. knit pdf and submit in discord
# แต่ละchart พยายามตอบคำถาม 1 ข้อที่เราอยากรู้ เช่น ราคากับกะรัต มีความสัมพันธืกันแบบไหนนะ
# กะรัต กับ ไพรซ์ กระจายตัวแบบไหนนะ เป็นต้น
# หรือจะวิเคราะห์เรื่องอื่นก็ได้


# HOMEWORK 2
# วิเคราะห์ skooldio facebook โดยเราจะกวาดโพสตั้งแต่ต้นปีแล้วมาดูว่า content ประเภทไหนที่ได้ เอนเกรทเมนต์เยอะๆ
# content ไหนที่ได้ เอนเกรทเมนต์เยอะกว่ากัน เช่น content รูปภาพ content วิดีโอ REELS เป็นต้น
# สรุปย่อ เราจะวิเคราะห์ data จากpage skooldio ที่แอดทอยให้มาแล้วก็ build visualization ขึ้นมา











