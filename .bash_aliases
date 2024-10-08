# Set the work directory and load the aliases to the current shell session
# These aliases should be sourced in the ~/bash_aliases, .bashrc or .zshrc file
# alias setdir='source $HOME/backend/set_work_dir.sh && source $HOME/backend/.bash_aliases'
alias dc='docker compose --env-file=`pwd`/.env.docker'
alias dcr='dc run'
alias dcu='dc up'
alias dcb='dc build --no-cache'
alias dcud='dc up -d'
alias dcd='dc down -v'
alias dcrm='dcr --rm'
alias dcx='dc exec'
alias adminer='dcr -p 8080:8080 adminer'
alias php="$PHP_SERVICE"
alias php81='dcrm php81'
alias php82='dcrm php82'
alias php83='dcrm php83'
alias php81_debug='dcrm php81_debug'
alias php82_debug='dcrm php82_debug'
alias php83_debug='dcrm php83_debug'
alias php_debug="$PHP_DEBUG_SERVICE"
alias artisan='php php artisan'
alias composer='php composer'
alias node='dcrm node'
alias npm='dcrm npm'
alias pnpm='dcrm pnpm'
alias vite='dcrm -p 5173:5173 npm run dev'
alias vitepressd='dcrm -p 5173:5173 npm run docs:dev'
alias serve='dcud server'
alias reserve='dcud --build server'
alias fresh_seed='artisan migrate:fresh --seed'
alias pap='artisan passport:client --password'
alias fresh='fresh_seed && artisan passport:install && pap'
alias pest='php ./vendor/bin/pest'
alias pestd='php_debug ./vendor/bin/pest'
alias pestf='php ./vendor/bin/pest --filter'
alias pestdf='php_debug ./vendor/bin/pest --filter'
alias pestp='php ./vendor/bin/pest --parallel'
alias pestwchtml='php_debug -e XDEBUG_MODE=coverage ./vendor/bin/pest'
alias pu='php ./vendor/bin/phpunit'
alias pud='php_debug ./vendor/bin/phpunit'
alias puf='php ./vendor/bin/phpunit --filter'
alias pufd='php_debug ./vendor/bin/phpunit --filter'
alias pug='php ./vendor/bin/phpunit --group'
alias puc='php ./vendor/bin/phpunit --list-tests | wc -l'
alias puwchtml='php_debug -e XDEBUG_MODE=coverage ./vendor/bin/phpunit'
alias phpfixer='php ./vendor/bin/php-cs-fixer fix'
alias psalm='php ./vendor/bin/psalm --config=psalm.xml'

alias own='sudo chown -R $USER:$USER'
alias mod='sudo chmod -R 777'
alias remove='sudo rm -rf'
alias list='ls -la'
# Create a .gitkeep file in all empty directories
alias keep='find . -type d -empty -exec touch {}/.gitkeep \;'
# Ignore changes to the executable bit. https://github.com/desktop/desktop/issues/4728
alias bitignore='git config core.filemode false'