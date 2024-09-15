> This document assumes that there is a folder named `backend` in the home directory. And the `backend` folder contains your project folder. e.g., `apiato`, `laravel`, etc...

1. create a folder named anything, e.g. apiato (this step is crucial because we need a folder with the correct permission)
   > If you share a directory with a container, and the directory did not exist before running the docker command,
   docker creates the directory as the user running the daemon (usually root).
2. docker-compose run --rm composer create-project apiato/apiato ./
3. composer update
4. npm install
5. generate docs docs
6. remove storage/logs/laravel.log if it causes any access permission problems. or sudo chown melkor:melkor laravel.log
7. set up the database
```dotenv
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=mysql
# or
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=postgres
# credentials (same for both setup)
DB_USERNAME=homestead
DB_PASSWORD=secret
```

## Bash Aliases
### tl;dr
Add this to your ~/.profile, ~/.bashrc or ~/.zshrc
```bash
set_aliases_based_on_dir() {
    # Update the `/$HOME/backend` to the path where you cloned this repository.
    project_dir="$HOME/backend"

    if [[ "$PWD" == "$project_dir/"* ]]; then
        # Source set_work_dir.sh and .bash_aliases
        [ -f "$project_dir/set_work_dir.sh" ] && . "$project_dir/set_work_dir.sh"
        [ -f "$project_dir/.bash_aliases" ] && . "$project_dir/.bash_aliases"
    else
        # Unalias everything from the .bash_aliases file
        [ -f "$project_dir/.bash_aliases" ] && while IFS= read -r line || [ -n "$line" ]; do
            alias_name=$(echo "$line" | cut -d'=' -f1 | sed "s/alias //g")
            unalias $alias_name 2>/dev/null
        done < "$project_dir/.bash_aliases"
    fi
}

# Hook the function to run before each prompt
PROMPT_COMMAND=set_aliases_based_on_dir
```
Then reopen the terminal. Now list the aliases with the command:
```bash
alias
```
### Explanation
This script dynamically sets or removes aliases based on the current working directory.
#### Directory-Based Alias Handling
If the terminal is opened or navigated into any subdirectory under ~/backend, the script sources two files: 
  - set_work_dir.sh: Configures environment variables or other settings specific to the project. 
  - .bash_aliases: Loads custom aliases relevant to the project.
### Unalias When Outside the Directory
When the terminal is outside the ~/backend directory, the script unaliases all aliases defined in .bash_aliases.
### Triggered on Every Prompt
The function runs before every prompt via the PROMPT_COMMAND to ensure
the aliases are always updated based on the current directory.
If you see the `composer` alias, then you are good to go.

## Changing the PHP version
You can change the PHP version by changing the `PHP_SERVICE` variable in the `.env.docker` file in your project root.
```dotenv
PHP_SERVICE=php82
```
PHP_SERVICE can be `php81`, `php82`, or `php83`. It corresponds to the service name in the `compose.yaml` file.

## Building the Docker Images
You can build new PHP images with different versions using the following command.
But first, you have to update it according to the new version.
1. Tag it to whatever version. e.g., `--tag=masmikh/php-8.1.0:latest`, `--tag=masmikh/php-8.2.0:latest`, etc...
2. Change the `--build-arg 'PHP_VER=8.1.0'` to the new version. e.g., `--build-arg 'PHP_VER=8.2.0'`

### Build it: 
1. cd into `~/backend` folder
2. run the following command:
```bash
docker build -f docker/php.dockerfile --tag=masmikh/php-8.1.0:latest --platform linux/amd64,linux/arm64 --target=php . --build-arg 'PHP_VER=8.1.0'
````
Note: You don't need to change the `--target=php` because it is the same for all versions.

### Build the debug image:
```bash
docker build -f docker/php.dockerfile --tag=masmikh/php-8.1.0-debug:latest --platform linux/amd64,linux/arm64 --target=php-debug . --build-arg 'PHP_VER=8.1.0'
```

## Troubleshooting
### DeadlineExceeded 
```bash
ERROR: failed to solve: DeadlineExceeded: DeadlineExceeded: DeadlineExceeded: php:8.1.0-fpm-alpine: failed to authorize: DeadlineExceeded: failed to fetch oauth token: Post "https://auth.docker.io/token": dial tcp 34.226.69.105:443: i/o timeout
```
It means you have to pull in all required/used images first:  
```bash
docker pull php:8.1.0-fpm-alpine # this is for amd64
docker pull php:8.1.0-fpm-alpine --platform=linux/arm64
docker pull composer:latest
docker pull mlocati/php-extension-installer:latest
```
etc...

### Multi-platform build is not supported
```bash
ERROR: Multi-platform build is not supported for the docker driver.
```
You need to enable `containered image store` in Docker settings.  
https://docs.docker.com/desktop/containerd/

### Failed to compute cache key
Probably the docker image build context is causing the problem.  
In short: _wrong file path relative to build context._  
Check the build context and file paths in the dockerfiles.

### Permission errors
https://stackoverflow.com/questions/74197633/phpstorm-can-not-save-files-unable-to-open-the-file-for-writing

use this link to set permissions:  
https://stackoverflow.com/questions/73672857/how-to-run-postgres-in-docker-as-non-root-user

https://www.baeldung.com/linux/check-user-group-privileges  
remove all volumes and docker-compose down/up  
groups  
if docker is not in the list, then:  
sudo groupadd docker  
groups melkor  
id melkor  
> Here is what we have:  
uid=1000 shows the user’s unique identifier (UID)
gid=1000 indicates the user’s primary group identifier (GID)
groups=1000(eric),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),116(lpadmin) displays all the groups that the user belongs to. Each group is represented by its GID, and its name is shown in parentheses. As we can see, the user eric belongs to several groups, including adm, cdrom, sudo, dip, plugdev, and lpadmin.

sudo usermod -aG docker melkor

sudo chmod g+rw filename  
sudo chmod -R g+rw mydirectory/ 

## Production
You have to copy the source code files into the container.
You can uncomment the copy codes in the nginx and php dockerfiles.

## TL;DR
1. Pull in this repository into your home directory and rename it to `backend`.
2. Create a folder named `apiato` (or any other name) in the `backend` folder.
3. Build the images.
4. Run the containers.

## Tips
### #1
If you want to be able to have local aliases in your project, you can add the following code to your `~/.bashrc` or `~/.zshrc` file.
This code will source the `.aliases` file (if exists) in your project folder when you open a terminal in your project folder.
```bash
function cd () { 
  builtin cd "$@" && [[ -f .aliases ]] && . .aliases
  return 0
}
```

## For macOS

### Outdated bash
MacOS bash version is old and it uses `zsh` by default now.  
Follow this guide to update your bash to the latest version.  
https://stackoverflow.com/questions/77052638/changing-default-shell-from-zsh-to-bash-on-macos-catalina-and-beyond

### ERROR: failed to solve: process "/bin/sh ...
Run this command:
```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```
Here you can find a more detailed explanation.
https://docs.docker.com/build/building/multi-platform/
