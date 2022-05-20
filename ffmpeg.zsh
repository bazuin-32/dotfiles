# useful functions for using ffmpeg to transcode media to/from
# formats that can be used with Davinci Resolve


# converts mp4/h.264 videos to mov/dnxhd
# usage:
# 	mp42mov input.mp4
# 	mp42mov -r ~/Videos/some_folder
function mp42mov {
	local input_files=()

	if [[ "$1" == "-r" ]]; then
		# recursive, next argument should be a directory
		if [ ! -d "$2" ]; then
			echo "$0: error: '$2' is not a directory" 1>&2
			return 1
		fi

		for file in "$2/**.{mp,MP}4"; do # some files use capitals (MP4), others use lowercase (mp4), so both are handled
			input_files+=("$file")
		done
	elif [ -f "$1" ]; then
		# we were given just a file, so we try to check all arguments
		# in case more files were given, and make sure they are mp4
		for arg in "$@"; do
			extension="${$(basename -- $arg)##*.}"
			
			# TODO: fix this first if statement, its body runs even
			# on valid mp4 files
#			if [[ $extension != "mp4" || $extension != "MP4" ]]; then
#				echo $extension
#				echo "$0: warning: '$arg' is not an mp4 file, discarding and continuing..." 1>&2
			if [ ! -f "$arg" ]; then
				echo here
				echo "$0: warning: '$arg' is not an mp4 file, discarding and continuing..." 1>&2
			else
				echo "adding $arg"
				input_files+=("$arg")
			fi
		done

	elif [[ "$1" != "" ]]; then
		# we have some random input
		echo "$0: error: '$1' is not a file" 1>&2
		return 1
	else
		# no argument was given
		echo "$0: error: no input files" 1>&2
		return 1
	fi

	local num_files=${#input_files[@]}
	if [ $num_files -lt 1 ]; then
		echo "$0: error: no input files" 1>&2
		return 1
	fi

	for file in "${input_files[@]}"; do
		file_no_ext="${file%.*}"

		ffmpeg -hwaccel cuda -i "$file" -vcodec dnxhd -acodec pcm_s24le -s 1920x1080 -r 60 -b:v 36M -pix_fmt yuv422p -f mov "$file_no_ext.mov"
	done
}
