#!/bin/bash
while read set_id level seed method add iter
do
Rscript ../Three_in_One/refactor.R $set_id $level $seed $method $add $iter
done < setting.txt

