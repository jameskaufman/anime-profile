"""
Retrieves any type of information from a specific anime's page.
"""
import json
import requests
from bs4 import BeautifulSoup

"""
url = "https://myanimelist.net/anime/9989/Ano_Hi_Mita_Hana_no_Namae_wo_Bokutachi_wa_Mada_Shiranai"
html = requests.get(url)
soup = BeautifulSoup(html.text, "html.parser")
"""
"""
Searches through the HTML soup to find and return an anime's 
global score, given a valid BeautifulSoup of the page's HTML.
"""
def get_global_score(soup):
	tag = soup.find("span", text="Score:")
	if (tag == None):
		return "n/a"
	else:
		return tag.find_next_sibling("span").string.strip()

"""
Searches through the HTML soup to find and return an anime's 
global ranking, given a valid BeautifulSoup of the page's HTML.
"""
def get_global_rank(soup):
	tag = soup.find("span", text="Ranked:")

	# Retry in the case of an error from request
	if (tag == None):
		return "n/a"
	else:
		return tag.next_sibling.strip()

"""
Searches through the HTML soup to find and return an anime's 
popularity ranking, given a valid BeautifulSoup of the page's HTML.
"""
def get_popularity(soup):
	tag = soup.find("span", text="Popularity:")
	if (tag == None):
		return "n/a"
	else:
		return tag.next_sibling.strip()

"""
Searches through the HTML soup to find and return an anime's 
number of members, given a valid BeautifulSoup of the page's HTML.
"""
def get_members(soup):
	tag = soup.find("span", text="Members:")
	if (tag == None):
		return "n/a"
	else:
		return tag.next_sibling.strip()

"""
Searches through the HTML soup to find and return an anime's 
season premiered, given a valid BeautifulSoup of the page's HTML.
"""
def get_season(soup):
	tag = soup.find("span", text="Premiered:")
	if (tag == None):
		return "n/a"
	else:
		return tag.find_next_sibling("a").string.strip()

"""
Searches through the HTML soup to find and return an anime's 
studio, given a valid BeautifulSoup of the page's HTML.
"""
def get_studio(soup):
	tag = soup.find("span", text="Studios:")
	if (tag == None):
		return "n/a"
	else:
		return tag.find_next_sibling("a").string.strip()

"""
Searches through the HTML soup to find and return an anime's 
source material, given a valid BeautifulSoup of the page's HTML.
"""
def get_source(soup):
	tag = soup.find("span", text="Source:")
	if (tag == None):
		return "n/a"
	else:
		return tag.next_sibling.strip()

"""
Searches through the HTML soup to find and return a list of all
an anime's listed genres, given a valid BeautifulSoup of the 
page's HTML.
"""
def get_genres(soup):
	tag = soup.find("span", text="Genres:")
	i = 0
	genres = []
	if (tag == None):
		return "n/a"

	while tag.find_next_sibling("a") != None:
		genres.append(tag.find_next_sibling("a").string)
		tag = tag.find_next_sibling("a")
		i += 1

	return genres