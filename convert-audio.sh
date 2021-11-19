#!/usr/bin/env bash

################################################################
# Batch convert audio files using ffmpeg
# Searches the current working directory and subdirectories
# Optionally moves the old files to a converted directory
################################################################

if [ ! -x "$(command -v ffmpeg)" ]; then
    echo "convert-audio.sh: ffmpeg not found on this system" 1>&2
    exit 1
fi

shopt -s globstar

# Get info from the user
while [ -z "$in_ext" ]; do
    read -p "Enter input file extension (ie. mp3, m4a, wav, flac): " in_ext
done

if [ "$in_ext" = "m4a" ]; then
    # m4a can have aac or alac codecs. Do we want to only target one of these?
    echo ""
    echo "m4a files use either the aac (lossy) or alac (lossless) codec"
    while read -p "Which codec do you want to convert from? (aac/alac/both): " codec; do
        case "$codec" in
            "aac")
                break
                ;;
            "alac")
                break
                ;;
            "both")
                break
                ;;
            *)
                echo "You must type 'aac', 'alac', or 'both'"
                ;;
        esac
    done  
fi

echo ""
while [ -z "$out_ext" ]; do
    read -p "Enter output file extension: " out_ext
done

echo ""
while read -p "Move old files when done? [y/n]: " yn; do
    case "$yn" in
        [Yy]*)
            move_old="true"
            break
            ;;
        [Nn]*)
            move_old="false"
            break
            ;;
        *)
            echo "Please type 'y' or 'n'"
            ;;
    esac
done
echo ""

# Search the current directory and subdirectories
for file in **/*."$in_ext"; do
    # Are we excluding a codec?
    if [ ! -z "$codec" ] && [ "$codec" != "both" ]; then
        # Get the codec of this file
        file_codec="$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=nokey=1:noprint_wrappers=1 "$file")"

        # Does the file codec match the user input?
        if [ "$file_codec" != "$codec" ]; then
            # Skip this file
            continue
        fi
    fi

    outfile="${file%.*}"
    # Don't overwrite files that already exist
    if [ -f "$outfile.$out_ext" ]; then
        echo "WARNING! DESTINATION FILE EXISTS! SKIPPING:"
        echo "'$outfile.$out_ext'"
        continue
    fi
    
    # Do the conversion
    echo "Converting to $out_ext:"
    echo "'$file'"
    ffmpeg -hide_banner -loglevel error -i "$file" "$outfile.$out_ext"

    # Move the old file out to a converted directory
    if [ "$move_old" = "true" ]; then
        echo "Moving old file..."
        mkdir -p "$(dirname "./converted/$file")" && mv "$file" "./converted/$file"
    fi
done
