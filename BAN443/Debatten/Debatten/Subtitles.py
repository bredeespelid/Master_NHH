!pip install yt-dlp os

import yt_dlp
import os

def main():
    url = "https://tv.nrk.no/serie/debatten/sesong/202410/episode/NNFA51101724"
    
    download_path = os.path.join(os.getcwd(), "Debatten_Undertekster")
    os.makedirs(download_path, exist_ok=True)

    ydl_opts = {
        'writesubtitles': True,
        'subtitleslangs': ['nb-ttv'],  # Norsk bokmål TV-teksting
        'skip_download': True,  # Hopp over nedlasting av video
        'outtmpl': os.path.join(download_path, '%(title)s.%(ext)s'),
        'quiet': False,
        'no_warnings': True,
        'postprocessors': [{
            'key': 'FFmpegSubtitlesConvertor',
            'format': 'srt',
        }],
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
        print(f"Undertekster lastet ned til: {download_path}")
    except Exception as e:
        print(f"En feil oppstod: {e}")

if __name__ == "__main__":
    main()
