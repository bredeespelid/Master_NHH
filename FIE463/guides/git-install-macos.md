# Installing & configuring git on macOS (Apple)

## Checking whether git is already installed

Git may already be installed on your machine. To check this, open the
[Terminal](https://support.apple.com/en-gb/guide/terminal/apd5265185d-f365-44cb-8b09-71a064a42125/mac) 
and type
```bash
git --version
```
If this returns without an error message, you already have git installed
and can skip the next step.


## Installing git

### Alternative 1

Git is shipped as part of the Apple Developer Command Line Tools. You 
can installed these by typing the following in the terminal.
```bash
xcode-select --install
```
and follow the instructions. See [this guide](https://mac.install.guide/commandlinetools/4) for details.
      
### Alternative 2

You can alternatively install git from from [homebrew](https://brew.sh/). 
Homebrew is not part of macOS and needs to be installed first, see 
[this video guide](https://youtu.be/B4qsvQ5IqWk).


## Configuration

Before using git, you need to set your name and email address. Open the terminal
and type the following (you can use another email address, but if 
you plan to use GitHub, use the same email address for both):

```bash
git config --global user.name "John Doe"
git config --global user.email johndoe@student.nhh.no
```

## SSH keys for GitHub (optional)

In order to seamlessly access your remote repositories on GitHub, 
you need to create a so-called SSH key on your local computer and 
add it to your GitHub account.

To create the SSH key, **copy** the following commands into the terminal:

```bash
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519_gh
cat ~/.ssh/id_ed25519_gh.pub
```
If everything worked, the last line of the output is your public 
key which needs to be added to your GitHub account. It should look
something like this:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjhZ7rUTC3ldXmp+dBOShXU8907YVHVWV3T7ciJ3xoW
```
See [these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account) 
on how to add the key to your GitHub account.

## GitHub integration (optional)


### Cloning from GitHub

If you want to clone an existing repository hosted in GitHub (for example the [course 
repository](https://github.com/richardfoltyn/FIE463-V25)), process as follows:
```bash
git clone git@github.com:richardfoltyn/FIE463-V25.git
```

### Adding a GitHub remote to your existing repository

1.  Create a new repository on GitHub by clicking, either by clicking 
    on the `+` in the top-right corner or use [this link](https://github.com/new).
2.  Pick a name, say `test`.
3.  Change to your local repository in the terminal and type the following:
```bash
git remote add origin git@github.com:yourname/test.git
git branch -M main
git push -u origin main
```
For this to work, you need to have the SSH keys configured as described above.