#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
import json

RESOURCES = u""
CURRENT_DRAW = 2061
OUTPUT_FILE = u"megasena.lua"

def fetch_web_page(url):
  return requests.get(url, allow_redirects=True)

def get_winning_bet(draw):
  url = RESOURCES.format(draw)
  page = fetch_web_page(url)
  return json.loads(page.text).get(u"resultado")

def extract_golden_numbers(winning_bet):
  numbers = winning_bet.split(u"-") if winning_bet else []
  golden_numbers = map(lambda s: int(s), numbers)
  golden_numbers.sort()
  return golden_numbers

def download_lottery_history():
  lottery_history = {}
  for draw in range(1, CURRENT_DRAW):
    try:
      winning_bet = get_winning_bet(draw)
      golden_numbers = extract_golden_numbers(winning_bet)
    except Exception as e:
      print u"Impossible to download draw #{}".format(draw)
      golden_numbers = []
    finally:
      lottery_history[draw] = golden_numbers
  return lottery_history

def __main__():
  lottery_history = download_lottery_history()
  with open(OUTPUT_FILE, u"w") as file:
    file.write(u"return {\n")
    for numbers in lottery_history.values():
      file.write(u"\t")
      lua_table = repr(numbers).replace(u"[", u"{").replace(u"]", u"}")
      file.write(lua_table)
      file.write(u",\n")
    file.write(u"}")


__main__()