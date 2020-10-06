#!/bin/sh -eu
IFS='
'

stowdir="$(dirname "$(realpath "$0")")"
target="$HOME"

log=0 # -1: quiet 0: normal 1: no-run 2: debug

modules=""

# parse arguments
while [ "$@" ]; do
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
	modules="$(find "$stowdir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n')"

[ $log -ge 2 ] &&
	echo verb $log &&
	set -x
[ $log -ge 1 ] &&
	echo modules $modules

# iterate over directories
for cmd in $modules; do
	# continue if command exists
	if type -p $cmd > /dev/null; then

		# iterate over files
		for file in $(find "$stowdir/$cmd" -type f -printf '%P\n'); do

			# get relative symlink path
			destdir="$(dirname "$target/$file")"
			relpath="$(realpath --relative-to="$destdir" "$stowdir/$cmd/$file")"
			[ $log -ge 2 ] && {
				echo src "$stowdir/$cmd/$file"
				echo dst "$target/$file"
				echo lnk "$relpath"
			}

			# ensure parent dir
			if [ ! -d "$destdir" ]; then
				[ $log -ge 1 ] && echo mkdir -pv "$destdir"
				[ $log -eq 0 ] &&      mkdir -pv "$destdir"
				[ $log -lt 0 ] &&      mkdir -p  "$destdir"
			else
				[ $log -ge 2 ] && echo dir "$destdir" already exists
			fi

			# add link
			destbase="$(basename "$target/$file")"
			# skip placeholder files
			if [ "$destbase" = '_' ]; then
				[ $log -ge 2 ] && echo skipping placeholder "'$file'"
			else

				# don't overwrite if files differ
				if [ -e "$target/$file" ] && ! diff -q "$target/$file" "$stowdir/$cmd/$file" > /dev/null; then
					echo target "$target/$file" and source "$stowdir/$cmd/$file" differ, not replacing
					diff "$target/$file" "$stowdir/$cmd/$file"
					continue
				fi
				reallink=$(stat --printf %N "$target/$file" |grep -o " -> '.*'$" |grep -o "'.*'" |grep -o "[^']*" || true)

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
	fi
done
