source project_pathes.sh
folders=(Random EN MI)
adds=(1 2 4)
iter_nums=(2,2,2)
pool_sizes=(500 550 560)

for set_id in {1..3}
do
	for ((level=0; level < 4; level+=2))
	do
		 for seed in {1..3}
		 do
				set_path=$outdata_p/data_${set_id}_noise_${level}_seed_${seed}
        mkdir ${set_path}
        mkdir $set_path/Random
        mkdir $set_path/EN
        mkdir $set_path/MI
     done
   done
done
     
