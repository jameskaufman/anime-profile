"""
Retrieves information about a given user's animelists and
returns a python object.

Capable of getting all anime data out of 'completed' list
or the 'plan to watch' list
"""
import time
import json
import requests
from anime import *
from bs4 import BeautifulSoup

"""
Purpose: 
Returns a python object representing one of a user's animelists.

Parameters:
profile, a string of the user's profile name on myanimelist
list, "completed" or "plan", indicating which list to pull data from

Return value:
A python object representing the specified animelist
"""
def get_user_list(profile, list):
	if list == "completed":
		return scrape_list("https://myanimelist.net/animelist/" + profile + "?status=2")
	elif list == "plan":
		return scrape_list("https://myanimelist.net/animelist/" + profile + "?status=6")
	else:
		print("Input must be \"completed\" or \"plan\"")

"""
Purpose:
Helper function for get_user_list that performs the get request, data
scraping, and parsing in order to return a valid python representation
of an animelist.

Parameters:
url, the url to get the user's animelist data from

Return value:
A python object representing the specified myanimelist
"""
def scrape_list(url):
	html = requests.get(url)
	soup = BeautifulSoup(html.text, "html.parser")
	tag = soup.table
	basic_list = json.loads(tag["data-items"])
	return get_advanced_data(basic_list)

def get_advanced_data(basic_list):
	adv_list = []

	for i in range(len(basic_list)):
		url = "https://myanimelist.net/anime/" + str(basic_list[i]["anime_id"]) + "/" + basic_list[i]["anime_title"].replace(" ", "_")
		html = requests.get(url)
		soup = BeautifulSoup(html.text, "html.parser")

		currAnime = {}
		currAnime["title"] = basic_list[i]["anime_title"]

		print(currAnime["title"])

		currAnime["global_rank"] = get_global_rank(soup)
		currAnime["global_score"] = get_global_score(soup)
		currAnime["local_score"] = basic_list[i]["score"]
		currAnime["type"] = basic_list[i]["anime_media_type_string"]
		currAnime["num_episodes"] = basic_list[i]["anime_num_episodes"]
		currAnime["members"] = get_members(soup)
		currAnime["popularity"] = get_popularity(soup)
		currAnime["season"] = get_season(soup)
		currAnime["studio"] = get_studio(soup)
		currAnime["age_rating"] = basic_list[i]["anime_mpaa_rating_string"]
		currAnime["source"] = get_source(soup)
		currAnime["genres"] = str(get_genres(soup)).strip("[]")

		adv_list.append(currAnime)
		time.sleep(1)

	return adv_list