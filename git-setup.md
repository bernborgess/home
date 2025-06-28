# Setting up Git for development
- Setup username and email
```
git config --global user.name "bernborgess"
git config --global user.email "bernborgesse@outlook.com"
```
- Tell git to store credentials
```
git config --global credential.helper store
```
- Tell git to use vim as editor
```
git config --global core.editor "vim"
```
- Merge instead of rebasing on pull conflicts
```
git config --global pull.rebase false
```
