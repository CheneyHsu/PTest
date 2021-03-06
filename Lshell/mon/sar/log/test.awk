#!/usr/bin/awk -f
BEGIN{
    Index[ARGC]; #记录各个文件行下标
    for(t=1;t<=ARGC;t++)  {
        Index[t]=0;
    }
}
{
    #文件数ARGC-1,第一个参数是应用程序名awk.
    for(t=1;t<=ARGC;t++) {
        if(FILENAME==ARGV[t])  {
            #line[t,Index[t]]=$0; #$0=整行,前提是各个文件行列之间已经被\t分割
	line[t,Index[t]]=sprintf("%s",$1);  #如果为固定几列,可以使用这个,方便日后使用,暂作记录.
            Index[t]++;
        }
    }
}
END{
        maxcount=0;
        for(i=1;i<=ARGC;i++) {
            if(Index[i]>macxount)maxcount=Index[i];
        }
#        printf("maxcount:%d",maxcount);
        for(j=0;j<=maxcount;j++) {
            for(i=1;i<=ARGC;i++){
		#多个文件的当前行接成一行
                if(i==1){ 
		#第一个文件
                    if(length(line[i,j]==0))
                        str="";  
		#一般操作的文件都是2列以上.这里注意可以更改
                    	else
                        str=line[i,j]; #第一次去掉\t
                }
                else {  #中间文件
                    if(length(line[i,j])==0)   #中间为空行,将空行替换为\t
                        str=sprintf("%s",str);
                   else
                        str=sprintf("%s\t%s",str,line[i,j]);
                }
            }
            printf("%s\n",str);
        }
        }
