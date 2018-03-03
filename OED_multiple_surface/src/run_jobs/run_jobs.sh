source project_pathes.sh
methods=(Random EN MI)
adds=(1 2)
iter_nums=(50 50 50)
#pool_sizes=(500 550 560)

rm -rf $outdata_p/*
for set_id in {1..4}
do
  for ((level=0; level < 4; level+=3))
  do
     for seed in {1..2}
     do
        set_path=$outdata_p/data_${set_id}_noise_${level}_seed_${seed}
        mkdir ${set_path}
        rm -rf ${set_path}/*
        for method in "${methods[@]}"
        do
           mkdir $set_path/$method
           for add in "${adds[@]}"
           do
             for iter in "${iter_nums[@]}"
             do
                 echo $iter
                 echo $method
                 Rscript ../Three_in_One/refactor.R ${set_id} ${level} ${seed} ${method} ${add} ${iter}
             done # iter_num
           done  # add
        done  # method
     break
     done  # seed
   done  # level
done  # set_id
     
