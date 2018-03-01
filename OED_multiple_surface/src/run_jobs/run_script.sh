#!/bin/bash
# The structure of the script:
# outer loop: just repeat three times (starting training sets are different)
# inner loop: different methods, CI, ENCI, Entropy, Rando
# inner most loop: different batch size
# the 1_All_in_one.R takes in 5 argumetns
# arg1: batch_size  arg2: iterations_times   arg3: pool_size   arg4: repeat_time, arg5: which data_set (syn real)
# argument for this script is real and true/false. the first is to say the real dataset is used and the second is to set anti_pool or not: ./run_script.sh real true

source project_pathes.sh
folders=(EN MI) # Random)
adds=(1 2 4)
iters=(2 2 2)
pool_size=500
set_name=real  # the $1 is real or syn
level=1
anti_pool=true # true or false string
measure=relative # the metric used to measure the error relative or absolute string

#rm -rf $outdata_p/*error*
#rm -rf $outdata_p/train_pool/*

echo -e "job id for each task\n" > job_record 
for ((level=5; level < 16; level+=10))
do 
	for repeat_time  in {1..3}
	do 
		mkdir  $outdata_p/train_pool/${repeat_time}${set_name}noise${level}
		mkdir   $outdata_p/errors${repeat_time}${set_name}noise${level}anti_pool_${anti_pool}measure_${measure}
		rm -rf  $outdata_p/errors${repeat_time}${set_name}noise${level}anti_pool_${anti_pool}measure_${measure}/*
		mkdir   $outdata_p/errors${repeat_time}${set_name}noise${level}anti_pool_${anti_pool}measure_${measure}/MI
		mkdir  $outdata_p/errors${repeat_time}${set_name}noise${level}anti_pool_${anti_pool}measure_${measure}/EN
		mkdir  $outdata_p/errors${repeat_time}${set_name}noise${level}anti_pool_${anti_pool}measure_${measure}/Random

		cd $src_p/generate_data
		Rscript 1_generate_train.R ${repeat_time} ${set_name} ${level}
		for ((i=0; i<${#folders[@]};i++))
		do
			cd  ${src_p}/${folders[$i]}
			#cd ${src_p}/run_jobs
			for ((j=0;j<${#adds[@]};j++))
			do
            cd $src_p/${folders[$i]}
						echo ${PWD}
            Rscript 1_All_in_one.R  ${adds[$j]} ${iters[$j]} ${pool_size} ${repeat_time} ${set_name} ${level} ${anti_pool} ${measure}
			done
			echo -e "\n" >> job_record
		done
		echo -e "\n\n" >> job_record
	done
done
