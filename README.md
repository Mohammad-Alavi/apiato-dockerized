1. create a folder named anything, e.g. apiato (this step is crucial because we need a folder with correct permission)
   > If you share a directory with a container, and the directory did not exist before running the docker command,
   docker creates the directory as the user running the daemon (usually root).
2. create a .env file based on .env.example
3. update the .env file -> PROJECT_FOLDER_NAME=myproject
4. docker-compose run --rm composer create-project apiato/apiato ./
5. composer update
6. npm install
7. generate docs docs
8. remove storage/logs/laravel.log if it causes any access permission problems. or sudo chown melkor:melkor laravel.log
9. set up the database
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
#### Add this to your ~/.bash_aliases, ~/.bashrc or ~/.zshrc
```bash
alias setdir='source $HOME/backend/set_work_dir.sh && source $HOME/backend/.bash_aliases'
```
#### Add this at the end of your ~/.profile
This will make sure that the .bash_aliases file is loaded when you open a terminal.
```bash
setdir
```
Then close and open the terminal. Now list the aliases with the command:
```bash
alias
```
If you see the `composer` alias, then you are good to go.

#### Note to myself:
Update the tag and PHP_VER (php81, php82) to create an image with a different PHP version.
Build the base_php image:  
cd into backend folder and run this command:  
You don't need to change the `--target` value -> base_name
```bash
docker build -f dockerfiles/php.dockerfile --tag=masmikh/php81:latest --target=php_base . --build-arg 'PHP_VER=php81'
````

If you get this error:  
```bash
ERROR: failed to solve: DeadlineExceeded: DeadlineExceeded: DeadlineExceeded: php:8.1.0-fpm-alpine: failed to authorize: DeadlineExceeded: failed to fetch oauth token: Post "https://auth.docker.io/token": dial tcp 34.226.69.105:443: i/o timeout
```
It means you have to pull in all required/used images first:  
```bash
docker pull php:8.1.0-fpm-alpine
docker pull composer:latest
docker pull mlocati/php-extension-installer:latest
```
etc...

#### If you have problems with permissions:
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

#### Production
You have to copy the source code files into the container.
You can uncomment the copy codes in the nginx and php dockerfiles.
