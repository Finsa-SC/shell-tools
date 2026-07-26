#!/bin/bash

NAMEFILE=$1
OPEN_SCRIPT=true

logger() {
    echo "$(datetime) [$1] $2"
}

flush_file() {
    logger "INFO" "Flushing $1..."
    if cat /dev/null > "$1"; then
        logger "INFO" "Flushing $1 success"
        return 0
    else
        logger "ERROR" "Failed to flush $1"
        return 1
    fi
}

initialize_script() {
    echo "#!/bin/bash" > "$1"
    if chmod +x "$1"; then
        logger "INFO" "Creating script completed!"
    else
        logger "WARN" "Creating script success but there's a problem when updating script permission"
    fi
}

open_script() {
    if $1; then
        logger "INFO" "Opening file..."
        vim "$2"
    fi
}

check_exist_file() { 
    if [[ -f "$1" ]]; then
        read -p "File already exists, do you want to override with new file? [Y/n]: " CONTINUE_EXIST
    
        CONTINUE_LOWER="${CONTINUE_EXIST,,}"
        if [[ "$CONTINUE_LOWER" == "y" || "$CONTINUE_LOWER" == "yes" ]]; then
            if !flush_file "$1"; then
                logger "ERROR" "Failed to flush $1."
                return 1
            else
                logger "INFO" "$1 has been flushed"
                return 0
            fi
        else
            logger "WARN" "Making script canceled."
            return 1
        fi
    fi
}

if [[ -z "$NAMEFILE" ]]; then
    logger "ERROR" "Please input file name first"
    exit 1
else
    # Check suffix
    if [[ "$NAMEFILE" != *.sh ]]; then
        FINALNAME="$NAMEFILE.sh"
    else
        FINALNAME="$NAMEFILE"
    fi

    if check_exist_file "$FINALNAME"; then
        exit 1
    fi

    initialize_script "$FINALNAME"
    open_script "$OPEN_SCRIPT" "$FINALNAME"

    logger "INFO" "Saved as $FINALNAME"
fi
