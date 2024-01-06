# admin

There is a [Makefile](./Makefile) that has a few useful commands for the demo environment.

## GitHub as code

This repository contains the configuration of the organization and repositories of the organization.

### How to change the configuration

- Go to `./github/organization.yml` file to change the settings for the organization.
- Go to `./github/settings.yml` file to change the default settings for all repositories (or not excluded) y the organization.
- Go to `./github/repos/<repo-name>.yml` file to change the settings for a specific repository.
- The code is located in `./apps/github-as-code` folder. Go to this folder to know more about how to "deploy" the configuration.
