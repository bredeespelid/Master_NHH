# Installing the Anaconda Python distribution

- Anaconda is a package that distributes both Python and numerous packages
  required to perform scientific computing. 
- You should prefer Anaconda over a "bare minimum" Python installer
  such as the one distributed via [python.org](https://www.python.org/downloads/).
- You should prefer Anaconda over the Python distribution shipped with
  your operating system (macOS and Linux).

## Installation

1. Download the installer from the [Anaconda website](https://www.anaconda.com/download/success).
    - **No registration is required**, skip it if prompted.
    - You need to choose the correct installer for your platform.
    - For macOS, this depends on your hardware (*Apple Silicon* or *Intel*).
      If you are unsure which one you are using, consult 
      [this guide](https://support.apple.com/guide/mac-help/get-system-information-about-your-mac-syspr35536/mac).
2. Running the installed should be straightforward, but you can consult
    [this guide](https://docs.anaconda.com/anaconda/install/) 
    if needed.

## Create an Anaconda environment (optional)

- The Anaconda installation comes with a default environment called `base`
  which contains most if not all packages required for this course.
- Alternatively, you can create a course-specific environment
  from the environment definition file [`environment.yml`](../environment.yml).
- To do so, use the Anaconda Prompt (Windows) or the terminal (macOS)
  and copy the following code:
    ```bash
    conda env create -f environment.yml
    ```
   Note that this must be run from the directory where `environment.yml`
   is located and creates an environment called `FIE463`.
