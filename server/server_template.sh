#!/usr/bin/bash

function validate_directory() # available_dir: Path, enabled_dir: Path -> bool
{
	if [[ ! -d $1 || ! -d $2 ]]; then
		return 1
	fi

	return 0
}

function is_site_already_exist() # file_path: Path -> bool
{
	if [[ -f "$1" ]]; then
		return 0
	fi
	
	return 1
}

function generate_static() # file_path: Path -> None
{
  cat > "$1" <<'DOC'
server {
    listen 80;
    server_name example.com;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
DOC
}

function generate_server() # file_path: Path -> None
{
  cat > "$1" <<'DOC'
server {
    listen 80;
    server_name example.com;

    location / {
    }
}
DOC
}


function enabled_sites() # site_name: str -> None
{
	ln -sf ../sites-available/"$1" ./sites-enabled/"$1"
}

function main() # server_name: str, is_static: bool -> None
{
	[[ -z $1 ]] && echo "Missing argument: server_name." && exit 1

	available_dir=./sites-available/ 
	enabled_dir=./sites-enabled/

	available_site="$available_dir""$1"

	if is_site_already_exist "$available_site"; then
		read -r -p "File is already exist, do you want to fluse existing file? [Y/n]: " confirm
		
		if [[ -z "$confirm" || ! "$confirm" =~ ^[yY]$ ]]; then
			echo "Action canceled."
			exit 0
		fi
	fi
	
	echo "Validating directory..."
	if ! validate_directory "$available_dir" "$enabled_dir"; then
		echo "No target directory found, make sure sites-enabled and sites-available exists and accessible."
	  exit 1
	fi
	echo "Validate passed."

	echo "Generating server template..."
	if [[ "$2" == "static" ]]; then
	    generate_static "$available_site"
	else
	    generate_server "$available_site"
	fi
	echo "Generate completed, $available_site has been created."

	echo "Creting symlink for $available_site..."
	enabled_sites "$1"
	echo "Symlink has been created."

	echo ""
	echo "Job done."
}

main "$1" "$2"
