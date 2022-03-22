function xkcd () {
    comicNum=$1
    newestJson=$(curl -s https://xkcd.com/info.0.json)
    newestNum=$(jq -r .num <<< $newestJson)

    if [[ "$1" != "newest" ]] ; then
        re='^[0-9]+$'
        # Check if argument is not "new", not a number or otherwise not valid and select random comic
        if ! [[ $1 =~ $re ]] || [[ comicNum -lt 1 ]] || [[ "$comicNum" -gt "$newestNum" ]] ; then
            # Generate a random comic number if none is specified
            comicNum=$((1 + $RANDOM % $newestNum))
        fi

        # Get xkcd by number
        json=$(curl -s https://xkcd.com/$comicNum/info.0.json)
    else
        # Use newest
        comicNum=$newestNum
        json=$newestJson
    fi
    

    # Parse response using jq
    url=$(jq -r .img <<< $json)
    title=$(jq -r .title <<< $json)
    alt=$(jq -r .alt <<< $json)
    transcript=$(jq -r .transcript <<< $json)
    date="$(jq -r .year <<< $json)-$(jq -r .month <<< $json)-$(jq -r .day <<< $json)"
    
    echo $url
    echo "\n\"$title\"\n"
    echo "#$comicNum -- $date\n"
    
    # Display the image using convert. Requires alacritty-sixel-git instead of alacritty
    convert $url sixel:-
}
