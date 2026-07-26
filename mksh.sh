#!/bin/bash

NAMEFILE=$1
OPEN_SCRIPT=true

override_exist_file() {
    echo "Overriding $1"
    if cat /dev/null > "$1"; then
        echo "Overriding $1 success"
        return 0
    else
        echo "Failed to override $1"
        return 1
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

    # Check existing file
    if [[ -f "$FINALNAME" ]]; then
        read -p "File already exists, do you want to override with new file? [Y/n]: " CONTINUE_EXIST
    
        if [[ "${CONTINUE_EXIST}" == "y" ]]; then
            if !override_exist_file; then
                exit 1
            fi
        else
            exit 0
        fi
    fi

    # Initialize script
    echo "#!/bin/bash" > "$FINALNAME"
    if chmod +x "$FINALNAME"; then
        echo "Creating script completed!"
    else
        echo "Creating script success but there's a problem when updating script permission"
    fi

    # Auto open script
    if [[ $OPEN_SCRIPT ]]; then
        echo "Opening file..."
        vim "$FINALNAME"
    fi
    echo "Saved as $FINALNAME"

fi
