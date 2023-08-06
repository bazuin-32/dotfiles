# TODO: also add a time calculated by an average rather than only instantaneous power draw
instant=$(acpi -b | sed -E 's/.*([0-9]{2}:[0-9]{2}):[0-9]{2}(.*)/\1\2/')

echo "${instant}"
