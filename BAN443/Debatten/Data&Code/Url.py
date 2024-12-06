import requests

# Base URL for NRK's API
base_url = "https://psapi.nrk.no"

# Direkte URL for "Debatten" serien
series_url = f"{base_url}/tv/catalog/series/debatten"

# Antall episoder vi ønsker å hente
target_episodes = 100
episodes_fetched = 0
page = 1

try:
    all_episodes = []

    while episodes_fetched < target_episodes:
        response = requests.get(series_url, params={"page": page})
        response.raise_for_status()
        series_data = response.json()

        if '_embedded' in series_data and 'instalments' in series_data['_embedded']:
            instalment_data = series_data['_embedded']['instalments']
            if '_embedded' in instalment_data and 'instalments' in instalment_data['_embedded']:
                episodes = instalment_data['_embedded']['instalments']
                all_episodes.extend(episodes)
                episodes_fetched += len(episodes)

                # Sjekk om det er flere sider
                if '_links' in instalment_data and 'next' in instalment_data['_links']:
                    page += 1
                else:
                    break  # Ingen flere sider
            else:
                break  # Ingen flere episoder funnet
        else:
            break  # Ingen flere episoder funnet

    print(f"Episoder av Debatten (totalt {len(all_episodes)}):")
    for episode in all_episodes[:target_episodes]:
        episode_id = episode['prfId']
        episode_title = episode['titles']['title']
        episode_date = episode['usageRights']['from']['displayValue']
        episode_url = f'https://tv.nrk.no/se?v={episode_id}'
        print(f"Dato: {episode_date}")
        print(f"Tittel: {episode_title}")
        print(f"URL: {episode_url}")
        print("---")

except requests.RequestException as e:
    print(f"En feil oppstod ved henting av data: {e}")
