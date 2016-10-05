#!/bin/bash

SUBDIRS=${1:-10}
DEPTH=${2:-2}

rm -rf src

function gendir {
	local curdir=$1
	local curdepth=$2
	mkdir $curdir
	cp foo.c $curdir/
	if [ $curdepth -ne 1 ]; then
		echo "#include \"../foo.h\"" > $curdir/foo.h
	else
		touch $curdir/foo.h
	fi
	echo "obj-y = foo.o" > $curdir/Kbuild.mk
	if [ $curdepth -ne $DEPTH ]; then
		for i in `seq 1 ${SUBDIRS}`; do
			local tmp=$i
			gendir $curdir/$tmp $((curdepth + 1))
			echo "obj-y += $tmp/" >> $curdir/Kbuild.mk
		done
	fi
}

gendir src 1
