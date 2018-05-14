library(doParallel)

registerDoParallel(cores=22)

linear.lsa=function(in.lsa,in.pheno) {
				     #n.nonlsa=ncol(in.pheno)
				     #pheno.lsa=merge(in.pheno,in.lsa,by.x=0,by.y=0)
				     tempresult=lm(in.pheno$delta1~in.lsa+in.pheno$age.months+in.pheno$Male+in.pheno$bmi)
				     coef=summary(tempresult)$coef[2,]
				     return(coef)
}

inNamePheno='PR.delta.brd.pheno.txt'
pheno=read.table(inNamePheno,header=T,check.names=F,stringsAsFactors=F)
pheno$Male[pheno$Male == "Male"]<-0
pheno$Male[pheno$Male == "Female"]<-1

for (i in 1:nrow(pheno[,c(3,4)])){
	pheno$delta1[i]<-max(pheno[i,c(3,4)],na.rm=T)
}

#foreach (i=1:22) %do%{
foreach (i=1:22) %dopar%{

	inNameLSA=paste('GALA2_mergedLAT-LATP_noParents_030816_PR.',i,'.ROH.R.out',sep="")
	outName=paste('GALA2_mergedLAT-LATP_noParents_030816_PR.',i,'.ROH.R.out.results',sep="")

	lsa=read.table(inNameLSA,header=T,check.names=F,stringsAsFactors=F)

	new.lsa<-lsa[rowSums(lsa[,3:dim(lsa)[2]]) > 0,3:dim(lsa)[2]]
	new.lsa<-new.lsa[,pheno$SubjectID]
	name.order<-order(colnames(new.lsa))
	new.lsa<-new.lsa[,name.order]

	pos<-lsa[rowSums(lsa[,3:dim(lsa)[2]]) > 0,2]
	result=t(apply(new.lsa,1,linear.lsa,in.pheno=pheno))

	result.final=cbind(pos,result)
	colnames(result.final)=c('Probe','beta','se','t','p')

	write.table(result.final,outName,quote=F,sep='\t',row.names=F)
}

chr<-1
file<-paste("GALA2_mergedLAT-LATP_noParents_030816_PR.",chr,".ROH.R.out.results",sep="")
data<-read.table(file,header = T)
gwas<-data.frame(chr=rep(chr,dim(data)[1]),data)

for(chr in 2:22){
	file<-paste("GALA2_mergedLAT-LATP_noParents_030816_PR.",chr,".ROH.R.out.results",sep="")
	data<-read.table(file,header = T)
	df<-data.frame(chr=rep(chr,dim(data)[1]),data)
	gwas<-rbind(gwas,df)
	rm(df)
	rm(data)
}

library(qqman)
library(coda)
png(file="MX.roh.bdr.manhattan.png")
manhattan(gwas,chr="chr",p="p",bp="Probe",main="PR")




library(doParallel)

registerDoParallel(cores=22)

linear.lsa=function(in.lsa,in.pheno) {
				     #n.nonlsa=ncol(in.pheno)
				     #pheno.lsa=merge(in.pheno,in.lsa,by.x=0,by.y=0)
				     tempresult=lm(in.pheno$delta1~in.lsa+in.pheno$age.months+in.pheno$Male+in.pheno$bmi)
				     coef=summary(tempresult)$coef[2,]
				     return(coef)
}

inNamePheno='MX.delta.brd.pheno.txt'
pheno=read.table(inNamePheno,header=T,check.names=F,stringsAsFactors=F)
pheno$Male[pheno$Male == "Male"]<-0
pheno$Male[pheno$Male == "Female"]<-1

for (i in 1:nrow(pheno[,c(3,4)])){
	pheno$delta1[i]<-max(pheno[i,c(3,4)],na.rm=T)
}

#foreach (i=1:22) %do%{
foreach (i=1:22) %dopar%{

	inNameLSA=paste('GALA2_mergedLAT-LATP_noParents_030816_MX.',i,'.ROH.R.out',sep="")
	outName=paste('GALA2_mergedLAT-LATP_noParents_030816_MX.',i,'.ROH.R.out.results',sep="")

	lsa=read.table(inNameLSA,header=T,check.names=F,stringsAsFactors=F)

	new.lsa<-lsa[rowSums(lsa[,3:dim(lsa)[2]]) > 0,3:dim(lsa)[2]]
	new.lsa<-new.lsa[,pheno$SubjectID]
	name.order<-order(colnames(new.lsa))
	new.lsa<-new.lsa[,name.order]

	pos<-lsa[rowSums(lsa[,3:dim(lsa)[2]]) > 0,2]
	result=t(apply(new.lsa,1,linear.lsa,in.pheno=pheno))

	result.final=cbind(pos,result)
	colnames(result.final)=c('Probe','beta','se','t','p')

	write.table(result.final,outName,quote=F,sep='\t',row.names=F)
}

chr<-1
file<-paste("GALA2_mergedLAT-LATP_noParents_030816_MX.",chr,".ROH.R.out.results",sep="")
data<-read.table(file,header = T)
gwas<-data.frame(chr=rep(chr,dim(data)[1]),data)

for(chr in 2:22){
	file<-paste("GALA2_mergedLAT-LATP_noParents_030816_MX.",chr,".ROH.R.out.results",sep="")
	data<-read.table(file,header = T)
	df<-data.frame(chr=rep(chr,dim(data)[1]),data)
	gwas<-rbind(gwas,df)
	rm(df)
	rm(data)
}
library(qqman)
library(coda)

png(file="MX.roh.bdr.manhattan.png")
	manhattan(gwas,chr="chr",p="p",bp="Probe",main="MX")
dev.off()