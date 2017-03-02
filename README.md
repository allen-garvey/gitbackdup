# Gitbackdup

Back up your public GitHub repositories by cloning or pulling them to a local directory.


## Dependencies

* POSIX compatible operating system
* BSD or GNU Make
* dmd v2.071.1 or higher
* git

## Getting Started

* clone or download this repository
* `cd` into project directory
* Run `make release`

## Back up public GitHub repositories

* Run `./bin/gitbackdup --source=github --username=github_username --destination=destination_directory`

## Back up public and private Bitbucket repositories

* Setup ssh key access to your Bitbucket account
* Go into your account settings and generate an app secret
* Run `./bin/gitbackdup --source=bitbucket --username=bitbucket_username --app_secret=your_app_secret --destination=destination_directory`


## License

Gitbackdup is released under the MIT License. See license.txt for more details.