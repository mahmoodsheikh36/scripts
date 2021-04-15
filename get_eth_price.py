#!/usr/bin/python3
import requests
import json

price_bought_at = 1700

response = requests.get('https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD')
data = json.loads(response.text)
current_price = data["USD"]
change_in_price = (data["USD"] - price_bought_at) / price_bought_at * 100
print("{}$ {:.2f}%".format(current_price, change_in_price))
