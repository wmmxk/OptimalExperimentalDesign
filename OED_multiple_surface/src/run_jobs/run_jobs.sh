source project_pathes.sh
methods=(Random EN MI)
adds=(1 2 3)
iter_nums=(3 3 3)
#pool_sizes=(500 550 560)

rm -rf $outdata_p/*
for set_id in {1..4}
do
  for ((level=0; level < 7; level+=3))
  do
     for seed in {1..2}
     do
        set_path=$outdata_p/data_${set_id}_noise_${level}_seed_${seed}
        mkdir ${set_path}
        rm -rf ${set_path}/*
        for method in "${methods[@]}"
        do
           mkdir $set_path/$method
           for ((i=0;i<3;i++))
           do
              echo $method
              echo ${iter_nums[$i]}  
              Rscript ../Three_in_One/refactor.R ${set_id} ${level} ${seed} ${method} ${adds[$i]} ${iter_nums[$i]}
           done  # add
        done  # method
     done  # seed
   done  # level
done  # set_id
     
