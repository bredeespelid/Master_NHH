# NRK Custom API and GPT-4 Analysis Scripts

This project includes four Python scripts designed to retrieve episodes from NRK's series *Debatten* and analyze their subtitles using GPT-4 via Azure OpenAI. It supports both single-file and batch processing for maximum flexibility.

## Features

### 1. **Custom API for NRK**
Two Python scripts handle episode retrieval and subtitle downloads:
- **`nrk_single_api.py`**: Fetches a single episode from NRK's API and downloads its subtitle file.
- **`nrk_batch_api.py`**: Retrieves multiple episodes from NRK's API based on the desired count and downloads their subtitles in one batch.

### 2. **GPT-4 Powered Analysis**
Two Python scripts for analyzing subtitles:
- **`analyze_single_file.py`**: Performs a detailed analysis of a single `.vtt` file, identifying debaters, analyzing interactions, and generating a JSON report.
- **`analyze_multiple_files.py`**: Processes multiple `.vtt` files in a batch, generates JSON reports for each file, and summarizes results.
