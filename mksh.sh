#!/bin/bash

NAMEFILE=$1
OPEN_SCRIPT=true

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

  # Initialize script
  echo "#!/bin/bash" > "$FINALNAME"
  if chmod +x "$FINALNAME"; then
    echo "Creating script completed!"
  else
    echo "Creating script success but there's a problem while update script permission"
  fi

  # Auto open script
  if [[ $OPEN_SCRIPT ]]; then
    echo "Opening file..."
    vim "$FINALNAME"
  fi
  echo "Saved as $FINALNAME"

fi
