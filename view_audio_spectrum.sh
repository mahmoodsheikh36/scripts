# view_audio_spectrum.sh
# show audio spectrum using sox

random_str=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)
sox "$1" -n spectrogram -o /tmp/$random_str.png && sxiv /tmp/$random_str.png
rm /tmp/$random_str.png
