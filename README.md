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
# or
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
```