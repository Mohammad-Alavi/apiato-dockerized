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
alias php_debug='dcrm php_debug'
alias artisan='php php artisan'
alias composer='php composer'
alias node='dcrm node'
alias npm='dcrm npm'
alias pnpm='dcrm pnpm'
alias vite='dcrm -p 5173:5173 npm run dev'
alias serve='dcud server'
alias reserve='dcud --build server'
alias fresh_seed='artisan migrate:fresh --seed'
alias pap='artisan passport:client --password'
alias fresh='fresh_seed && artisan passport:install && pap'
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