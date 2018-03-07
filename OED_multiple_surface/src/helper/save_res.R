save_res <- function (out_data_path,set_name,noise_level,random_seed,add,iter_num,errors,train,method,bad=TRUE,epoch) {
  error_file_name = paste("every_",add,"_iter_",iter_num,".csv",sep="")
  
  if (bad) {
  train_file_name = paste("trainbad_every_",add,"_iter_",iter_num,".csv",sep="")
  } else {
    train_file_name = paste("train_every_",add,"_iter_",iter_num,".csv",sep="") 
  }
  
  folder = paste("data_",set_name,"_noise_",noise_level,"_seed_",random_seed,sep="")
  
  nums = start_size + seq(0,epoch-1,1)*add
  
  errors = data.frame(nums,errors)
  
  cat("\nsuccess")
  write.csv(errors,file=file.path(out_data_path,folder,method,error_file_name),row.names = FALSE)
  write.csv(train,file=file.path(out_data_path,folder,method,train_file_name))
  cat("\nsaved\n")
  cat(folder,"\n")
  
}
