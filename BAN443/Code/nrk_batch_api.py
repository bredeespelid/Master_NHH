import requests
import yt_dlp
import os

# Base URL for NRK's API
base_url = "https://psapi.nrk.no"
series_url = f"{base_url}/tv/catalog/series/debatten"

# Number of episodes to fetch, adjusted to ignore the first one
target_episodes = 9
episodes_needed = target_episodes + 1  # Fetch 10 episodes but ignore the first one
episodes_fetched = 0
page = 1

try:
    all_episodes = []

    # Fetch episodes from the API
    while len(all_episodes) < episodes_needed:
        response = requests.get(series_url, params={"page": page})
        response.raise_for_status()
        series_data = response.json()

        if '_embedded' in series_data and 'instalments' in series_data['_embedded']:
            instalment_data = series_data['_embedded']['instalments']
            if '_embedded' in instalment_data and 'instalments' in instalment_data['_embedded']:
                episodes = instalment_data['_embedded']['instalments']
                all_episodes.extend(episodes)

                # Check if there are more pages
                if '_links' in instalment_data and 'next' in instalment_data['_links']:
                    page += 1
                else:
                    break  # No more pages
            else:
                break  # No more episodes found
        else:
            break  # No more episodes found

    # Remove the first episode and collect the URLs for the rest
    all_episodes = all_episodes[1:episodes_needed]  # Ignore the first episode

    # Collect the URLs in a list called URL
    URL = [f'https://tv.nrk.no/se?v={episode["prfId"]}' for episode in all_episodes]

    # Print a message showing how many episodes were fetched
    print(f"Episodes of Debatten (total {len(URL)}):")

    # Function to download subtitles
    def download_subtitles(url, download_path):
        ydl_opts = {
            'writesubtitles': True,
            'subtitleslangs': ['nb-ttv'],  # Norwegian Bokmål TV subtitles
            'skip_download': True,  # Skip video download
            'outtmpl': os.path.join(download_path, '%(title)s.%(ext)s'),
            'quiet': True,  # Reduce output to a minimum
            'no_warnings': True,  # Suppress warnings
            'postprocessors': [{
                'key': 'FFmpegSubtitlesConvertor',
                'format': 'srt',
            }],
            'logger': None,  # Remove logger object for less noise
        }

        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
            print(f"Subtitles downloaded for URL: {url}")
            return True  # Return True if the download was successful
        except Exception as e:
            print(f"An error occurred for {url}: {e}")
            return False  # Return False if an error occurred

    # Create a folder for storing subtitles
    download_path = os.path.join(os.getcwd(), "Debatten_subtitles")
    os.makedirs(download_path, exist_ok=True)

    # Download subtitles for each URL in the list
    valid_urls = []
    for i, url in enumerate(URL):
        success = download_subtitles(url, download_path)
        if not success:
            print("Trying the next available episode...")
            continue  # Move to the next episode
        valid_urls.append(url)

    if len(valid_urls) < target_episodes:
        print(f"Only {len(valid_urls)} episodes were successfully downloaded.")
    else:
        print("All episodes fetched successfully.")

except requests.RequestException as e:
    print(f"An error occurred while fetching data: {e}")
