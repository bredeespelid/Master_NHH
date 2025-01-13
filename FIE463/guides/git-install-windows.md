# Installing & configuring git on Windows

## Installing git

1. Download the installer [here](https://git-scm.com/download/win).
2. The installer allows you to tweak various things, just accept the defaults.
3. One setting you should change is the editor used for commit messages.
  A sensible choice is [nano](https://www.howtogeek.com/42980/the-beginners-guide-to-nano-the-linux-command-line-text-editor/) 
  (a simple command-line editor).
4. Once installed, git can be used via the command line by 
    launching `Git Bash` from the start menu.


## Configuration

Before using git, you need to set your name and email address. 
Open the `Git Bash` terminal
and type the following (you can use another email address, but if 
you plan to use GitHub, use the same email address for both):

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@student.nhh.no
```


## GitHub integration (optional)


### Cloning from GitHub

If you want to clone an existing repository hosted in GitHub (for example the [course 
repository](https://github.com/richardfoltyn/FIE463-V25)), process as follows:
```bash
git clone https://github.com/richardfoltyn/FIE463-V25.git
```

### Adding a GitHub remote to your existing repository

1.  Create a new repository on GitHub by clicking, either by clicking 
    on the `+` in the top-right corner or use [this link](https://github.com/new).
2.  Pick a name, say `test`.
3.  Change to your local repository in the terminal and type the following:
```bash
git remote add origin https://github.com/yourname/test.git
git branch -M main
git push -u origin main
```

- The first time you interact with GitHub via git on the command line, 
    you will see a authentication pop-up. Select "Sign in with your browser"
    and follow the instructions.
- The authentication token is stored locally so you don't have to do this every time.