# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import time

# Start the browser and login with standard_user
user = "standard_user"
password = "secret_sauce"

print ('Starting the browser...')
# --uncomment when running in Azure DevOps.
options = ChromeOptions()
options.add_argument("--disable-extensions")
options.add_argument("--headless")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--remote-debugging-port=9222")
options.add_argument("start-maximized")
options.add_argument("disable-infobars")
options.add_argument("--no-sandbox") 
driver = webdriver.Chrome(options=options)
# driver = webdriver.Chrome()
print ('Browser started successfully. Navigating to the demo page to login.')

driver.get('https://www.saucedemo.com/')

driver.find_element(By.ID,'user-name').send_keys(user)
driver.find_element(By.ID,'password').send_keys(password)
driver.find_element(By.ID,'login-button').click()
print(f"{user} logged in succesfully!")

# find the items and add to the cart - verify we can find all 6
items = driver.find_elements(By.CLASS_NAME, "inventory_item")
assert len(items) == 6 

for i in items:
    name = i.find_element(By.CLASS_NAME, "inventory_item_name").text
    i.find_element(By.CLASS_NAME, "btn").click()
    print(f"{name} added to the cart.")

# find items in the cart - verify we have all 6
cart = driver.find_element(By.CLASS_NAME, "shopping_cart_container")
cart.click()
cart_content = driver.find_elements(By.CLASS_NAME, "cart_item")
assert len(cart_content) == 6
print("Added all items to the cart")

# remove the items from the cart
for i in cart_content:
    name = i.find_element(By.CLASS_NAME, "inventory_item_name").text
    i.find_element(By.CLASS_NAME, "btn").click()
    print(f"{name} removed from the cart.")
print("Removed all items from the cart")

time.sleep(5)

driver.quit


