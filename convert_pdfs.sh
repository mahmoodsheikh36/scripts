mkdir -p "$BRAIN_DIR/resources/epubs" 2>/dev/null
for file in "$BRAIN_DIR/resources/"*.pdf; do
  newfile="$(basename "$file")"
  newfile="${newfile%.pdf}.epub"
  newfile_fullpath="$BRAIN_DIR/resources/epubs/$newfile" 
  [ ! -f "$newfile_fullpath" ] &&\
      ebook-convert "$file" "$newfile_fullpath" --enable-heuristics && echo "$newfile"
done