# Installing the required packages
!pip install -U openai pydantic
!pip install yt-dlp

import yt_dlp
import os

##---------------------------------------Test for subtitles download**


def main():
    url = "https://tv.nrk.no/serie/debatten/sesong/202409/episode/NNFA51092624"

    download_path = os.path.join(os.getcwd(), "Debatten_subtitles")
    os.makedirs(download_path, exist_ok=True)

    ydl_opts = {
        'writesubtitles': True,
        'subtitleslangs': ['nb-ttv'],  # Norsk bokmål TV-teksting
        'skip_download': True,  # Skip downloading of episodes
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
        print(f"Subtitles downloaded to -> : {download_path}")
    except Exception as e:
        print(f"En feil oppstod: {e}")

if __name__ == "__main__":
    main()
