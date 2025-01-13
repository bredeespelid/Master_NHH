
# FIE463: Numerical Methods in Macroeconomics and Finance using Python

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

Course material for spring term 2025 (V25)

Author: Richard Foltyn


## Course outline (preliminary and incomplete)

The course material for _Part 1: Introduction to Python_ is listed below. The material for parts 2 and 3 will be added later.

`L` = Lecture, `W` = Workshop


| Week | Day | L/W | Topic | Notes & Exercises | Solutions |
|------|-----|-----|-------|----------------------|------------------------------------------|
|  0   | Thu, Jan 9 | `L` | Introduction | [Slides](lectures/lecture00/lecture00.pdf) | N/A  |
|  1   | Tue, Jan 14 | `L` | Python basics | [Notebook](lectures/lecture01/lecture01.ipynb), [PDF](lectures/lecture01/lecture01.pdf) | N/A  |
|      | Thu, Jan 16 | `W` | Python basics | [Notebook](workshops/workshop01/workshop01.ipynb), [PDF](workshops/workshop01/workshop01.pdf) | TBA |
|  2   | Tue, Jan 21 | `L` | Control flow & loops | [Notebook](lectures/lecture02/lecture02.ipynb), [PDF](lectures/lecture02/lecture02.pdf) | N/A  |
|      | Thu, Jan 23 | `W` | Control flow & loops | [Notebook](workshops/workshop02/workshop02.ipynb), [PDF](workshops/workshop02/workshop02.pdf) | TBA |
|  3   | Tue, Jan 28 | `L` | Functions & modules | [Notebook](lectures/lecture03/lecture03.ipynb), [PDF](lectures/lecture03/lecture03.pdf) | N/A  |
|      | Thu, Jan 30 | `W` | Functions & modules | [Notebook](workshops/workshop03/workshop03.ipynb), [PDF](workshops/workshop03/workshop03.pdf) | TBA |
|  4   | Tue, Feb 4 | `L` | Random numbers & plotting | [Notebook](lectures/lecture04/lecture04.ipynb), [PDF](lectures/lecture04/lecture04.pdf) | N/A  |
|      | Thu, Feb 6 | `W` | Random numbers & plotting | [Notebook](workshops/workshop04/workshop04.ipynb), [PDF](workshops/workshop04/workshop04.pdf) | TBA |
|  5   | Tue, Feb 11 | `L` | Numerical optimization | [Notebook](lectures/lecture05/lecture05.ipynb), [PDF](lectures/lecture05/lecture05.pdf) | N/A  |
|      | Thu, Feb 13 | `W` | Numerical optimization | [Notebook](workshops/workshop05/workshop05.ipynb), [PDF](workshops/workshop05/workshop05.pdf) | TBA |

## Guides

See the [guides/](guides/README.md) folder for instructions on how to 
install Anaconda (Python), Visual Studio Code, and git version control.


## Forking & Cloning

### Forking

- Click on the `Fork` icon to fork this repository (create your own personal copy)
- In the future, you need to click on `Sync Fork` to get new commits made to this repository into your forked version.

### Cloning

1. Click on the green `Code` icon to clone the repository to your computer
2. Select HTTPS or SSH depending on your authentication method (HTTPS for Windows, SSH for Mac) and copy the URL.
3. You can clone the repository directly in Visual Studio Code, or use the command line:

    _Windows:_
    ```bash
    git clone https://github.com/richardfoltyn/FIE463-V25.git
    ```
    _Mac (using SSH keys):_
    ```bash
    git clone git@github.com:richardfoltyn/FIE463-V25.git
    ```


## Creating a Conda environment

Using the Anaconda Prompt (Windows) or Terminal (Mac), you can use 
the environment definition file ([environment.yml](environment.yml)) provided in this repository to create 
a conda environment called `FIE463`:
```bash
conda env create -f environment.yml
```


## Additional resources

1. [Think Python](https://allendowney.github.io/ThinkPython/index.html) by Allen B. Downey:
   general intro to Python, chapters are available as Jupyter notebooks.
2. [Everybody](https://www.py4e.com/book) by Charles R. Severance:
   general intro to Python with a focus on data analysis, available as PDF.
3. [QuantEcon](https://quantecon.org/lectures/): Python programming for economics & finance
    (beginners & advanced)
3. [Introduction to Programming and Numerical Analysis](https://sites.google.com/view/numeconcph-introprog/home): 
    Python for macroeconomics, taught at the University of Copenhagen

## License

This material is licensed under a 
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/),
except for the data files contained in the `data/` folder, which
fall under the terms imposed by the original content creators.
