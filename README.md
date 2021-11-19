# convert-audio
Batch convert audio files using ffmpeg

## To use this script:
1. Place it in the base directory of your music library
2. Open a terminal and change the working directory to the base folder of your music library
3. Run the script: `./convert-audio.sh | tee convert.log`

## Notes
- Piping the script's output to tee allows you to both watch and log the output to a file.

## Example: Convert alac-encoded m4a files to flac
- When the script asks, type "m4a" for the input file extension, "alac" for the codec, "flac" for the output file extension, and "y" to move the old files.
- It will convert only the ALAC encoded m4a's to FLAC, preserving all metadata and folder structure, then move the old m4a out into a folder named "converted" with all directory structure intact just in case.
