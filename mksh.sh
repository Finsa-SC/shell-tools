#!/bin/bash

NAMEFILE=$1
OPEN_SCRIPT=true

flush_file() {
    echo "Flushing $1..."
    if cat /dev/null > "$1"; then
        echo "Flushing $1 success"
        return 0
    else
        echo "Failed to flush $1"
        return 1
    fi
}

initialize_script() {
    echo "#!/bin/bash" > "$1"
    if chmod +x "$1"; then
        echo "Creating script completed!"
    else
        echo "Creating script success but there's a problem when updating script permission"
    fi
}

open_script() {
    if $1; then
        echo "Opening file..."
        vim "$2"
    fi
}

check_exist_file() { 
    if [[ -f "$1" ]]; then
        read -p "File already exists, do you want to override with new file? [Y/n]: " CONTINUE_EXIST
    
        CONTINUE_LOWER="${CONTINUE_EXIST,,}"
        if [[ "$CONTINUE_LOWER" == "y" || "$CONTINUE_LOWER" == "yes" ]]; then
            if !flush_file "$1"; then
                echo "Failed to flush $1."
                exit 1
            fi
        else
            echo "Making script canceled."
            exit 0
        fi
    fi
}

if [[ -z "$NAMEFILE" ]]; then
    echo "Please input file name first"
    exit 1
else
    # Check suffix
    if [[ "$NAMEFILE" != *.sh ]]; then
      FINALNAME="$NAMEFILE.sh"
    else
      FINALNAME="$NAMEFILE"
    fi

    check_exist_file $FINALNAME

    initialize_script "$FINALNAME"
    open_script "$CONTINUE_LOWER" "$FINALNAME"

    echo "Saved as $FINALNAME"
fi
