# Hooks README

This repo is configured to validate Pull Requests. See `.github/workflows`
for configurations settings.  We validate that:

- commit messages comply with Conventional Commits standard
- all code is formatted (with `mix format`) 
- all tests pass 

To perform checks locally before making a commit:  

1. Use the pre-commit script `commit-msg`, and the setup
   script `.github/hooks/GitHooksEnable.sh`.
2. Or use the tooling found in [pre-commit.com](https://pre-commit.com).
3. Or use your own favorite pre-commit solution

| Resource             | URL                                                             |
|----------------------|-----------------------------------------------------------------|
| Conventional Commits | https://www.conventionalcommits.org/en/v1.0.0/#summary          |
| ConvCom Cheatsheet   | https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13 |
| Githooks             | https://git-scm.com/docs/githooks                               |
