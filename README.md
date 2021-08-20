1. create a folder named anything, e.g. apiato (this step is crucial because we need a folder with correct permission)
   > If you share a directory with a container, and the directory did not exist before running the docker command,
   docker creates the directory as the user running the daemon (usually root).
2. update the .env file -> PROJECT_FOLDER_NAME=myproject
3. docker-compose run --rm composer create-project apiato/apiato ./
4. composer update
5. npm install
6. generate docs docs
7. remove storage/logs/laravel.log if it causes any access permission problems. or sudo chown melkor:melkor laravel.log