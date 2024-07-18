import requests
from bs4 import BeautifulSoup
import pandas as pd

def fetch_roster_page(url):
    response = requests.get(url)
    if response.status_code != 200:
        raise Exception(f"Failed to load page {url}")
    return response.content

def parse_roster_page(content):
    soup = BeautifulSoup(content, 'html.parser')
    fighter_links = []
    table = soup.find('table', class_='b-statistics__table')
    for row in table.find_all('tr')[1:]:  # Skip the header row
        link = row.find('a')
        if link:
            fighter_links.append(link['href'])
    return fighter_links

def parse_fighter_profile(url):
    fighter_response = requests.get(url)
    if fighter_response.status_code != 200:
        print(f"Failed to load page {url}")
        return None

    fighter_soup = BeautifulSoup(fighter_response.content, 'html.parser')

    # Extracting desired data
    fighter_data = {}
    name_tag = fighter_soup.find('span', class_='b-content__title-highlight')
    if name_tag:
        fighter_data['name'] = name_tag.get_text(strip=True)
    else:
        fighter_data['name'] = 'N/A'
    
    # Extract detailed stats
    stats_section = fighter_soup.find_all('div', class_='b-list__info-box')
    for section in stats_section:
        stats = section.find_all('li', class_='b-list__box-list-item')
        for stat in stats:
            label_tag = stat.find('i', class_='b-list__box-item-title')
            value_tag = stat.find('span', class_='b-list__box-item-content')
            if label_tag and value_tag:
                label = label_tag.get_text(strip=True).replace(':', '')
                value = value_tag.get_text(strip=True)
                fighter_data[label] = value
            elif label_tag:
                label = label_tag.get_text(strip=True).replace(':', '')
                value = stat.get_text(strip=True).replace(label_tag.get_text(strip=True), '').strip()
                fighter_data[label] = value
            else:
                print(f"Missing data in stat: {stat}")
    
    return fighter_data

def scrape_fighter_stats(url, limit=None):
    content = fetch_roster_page(url)
    fighter_links = parse_roster_page(content)
    
    if limit:
        fighter_links = fighter_links[:limit]
    
    fighters_data = []
    for link in fighter_links:
        fighter_data = parse_fighter_profile(link)
        if fighter_data:
            fighters_data.append(fighter_data)
    
    return fighters_data

def save_to_csv(data, filename):
    df = pd.DataFrame(data)
    df.to_csv(filename, index=False)

if __name__ == "__main__":
    roster_url = 'http://ufcstats.com/statistics/fighters?char=a&page=all'
    fighters_data = scrape_fighter_stats(roster_url, limit=15)
    save_to_csv(fighters_data, 'ufc_fighters_data.csv')
    print("Data scraping completed and saved to ufc_fighters_data.csv")
