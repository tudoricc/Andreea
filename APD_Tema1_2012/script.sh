#!/bin/bash
	ANI=$1
	FISIN=$2
	FISOUT1=$3
	FISOUT2=$4
	FISOUT3=$5
	SCHEDULE=$6
	THREADS=$7

	export OMP_SCHEDULE=$SCHEDULE
	export OMP_NUM_THREADS=$THREADS
	time ./serial $ANI $FISIN $FISOUT1
	time ./paralel $ANI $FISIN $FISOUT2
	time ./optims $ANI $FISIN $FISOUT3
