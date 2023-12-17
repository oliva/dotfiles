#!/bin/sh -eu
IFS='
'

dir="$(dirname "$(realpath "$0")")"
target="$HOME"

log=0 # -1: quiet 0: normal 1: no-run 2: debug

modules=""

# parse arguments
while [ -n "${1:-}" ]; do
	case $1 in
		-q|--quiet)
			log=-1
			;;
		-v|--verbose)
			log=0
			;;
		-n|--dry-run)
			log=1
			;;
		-d|--debug)
			log=2
			;;
		*)
			modules="$modules${modules:+ }$1"
			;;
	esac
	shift
done

# use all modules by default
[ -z "$modules" ] &&
	modules="$(find "$dir"/* -mindepth 0 -maxdepth 0 -type d |sed 's|.*/||')"

[ $log -ge 2 ] &&
	echo verb $log &&
	set -x
[ $log -ge 1 ] &&
	echo modules $modules

# iterate over directories
for cmd in $modules; do
	# skip if command is not available
	which $cmd > /dev/null 2> /dev/null || {
		[ $log -ge 1 ] &&
			echo skipping nonexistent cmd $cmd
		continue
	}

	# iterate over files
	for file in $(find "$dir/$cmd/" -type f \! -path '*/.git/*' |sed "s|^$dir/$cmd/||"); do

		# ensure parent dir
		destdir="$(dirname "$target/$file")"
		if [ ! -d "$destdir" ]; then
			[ $log -ge 1 ] && echo mkdir -pv "$destdir"
			[ $log -eq 0 ] &&      mkdir -pv "$destdir"
			[ $log -lt 0 ] &&      mkdir -p  "$destdir"
		else
			[ $log -ge 2 ] && echo dir "$destdir" already exists
		fi

		# get relative symlink path
		relpath="$(realpath --relative-to="$destdir" "$dir/$cmd/$file")"
		[ $log -ge 2 ] && {
			echo src "$dir/$cmd/$file"
			echo dst "$target/$file"
			echo lnk "$relpath"
		}

		# add link
		destbase="$(basename "$target/$file")"
		# skip placeholder files
		if [ "$destbase" = '_' ]; then
			[ $log -ge 2 ] && echo skipping placeholder "'$file'"
		else

			# don't overwrite if files differ
			if [ -e "$target/$file" ] && ! diff -q "$target/$file" "$dir/$cmd/$file" > /dev/null; then
				echo target "$target/$file" and source "$dir/$cmd/$file" differ, not replacing
				[ $log -ge 2 ] && diff "$target/$file" "$dir/$cmd/$file" || true
				continue
			fi
			reallink=$(stat --printf %N "$target/$file" 2>/dev/null |grep -o " -> '.*'$" |grep -o "'.*'" |grep -o "[^']*" || true)

			# skip if link already exists
			if [ "$reallink" = "$relpath" ]; then
				[ $log -ge 1 ] && echo link for "$file" is in place
				continue
			fi

			# we can safely apply our new files
			[ $log -ge 1 ] && echo ln -sfv "$relpath" "$target/$file"
			[ $log -eq 0 ] &&      ln -sfv "$relpath" "$target/$file"
			[ $log -lt 0 ] &&      ln -sf  "$relpath" "$target/$file"
		fi
	done
done
