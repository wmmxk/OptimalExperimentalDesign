source("../setpath.R")
random_seeds = c(1,2,3,4)
noises = c(5,13)
methods = c("EN","MI")


res = matrix(nrow=20,ncol=15)
res = data.frame(res)

file_name = "every_4_20_iter.csv"
count = 1


for (random_seed in random_seeds) {
   for (noise in noises) {
     for (method in methods) {
        folder_name= paste("noise_robust/","errors_",random_seed,"realnoise_",noise,"anti_pool_falsemeasure_relative/",method,sep="")
        
        file_path = file.path(out_data_path,folder_name,file_name)
        list.files(file.path(out_data_path,folder_name))
        if (file.exists(file_path)) {
          data = read.csv(file_path, header=TRUE)

        res[,count] = data[,2]
        colnames(res)[count] = paste(random_seed,noise,method,sep="_")
        count = count +1
        }
    }
   }
}

mean_plot = data.frame(matrix(nrow=20,ncol = 4))
std_plot = data.frame(matrix(nrow=20,ncol = 4))

count = 1
for (noise in noises){
  for (method in methods) {
    tag = paste("_",noise,"_",method, sep="")
    index = grep(tag, colnames(res))
    mean_plot[,count] = apply(res[,index],1,mean)
    colnames(mean_plot)[count] = paste(noise,method,sep="_")
    count = count +1
  }
}

