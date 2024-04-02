# Load the necessary libraries
{
if (!require(readxl)) {
  install.packages('readxl')
}
library(readxl)


  # Define the URL of the .RData file
  
  
cat('Download the file HFpEFcalc.RData from the following URL "https://github.com/kevchh89/HFpEF-JH_Score_Calculator/raw/main/HFpEFcalc.RData" \n')
  
cat('Load the file HFpEFcalc.RData\n')
  
load(file.choose())
  

# Load the data frame

Analysis_Name<-"Default_Name"
cat('Assign a name to the analysis\n')
Analysis_Name <- readline(prompt = "Please enter a name: ")
if(Analysis_Name==""){
  Analysis_Name<-"Default_Name"
}

cat('\nYour data set must contain\n
    1. Patient ID\n
    2. Left Atria Volume\n
    3. Left Ventricle Volume\n
    4. Body Mass Index (BMI)\n
    5. Estimate Glomerular Filtration Rate (eGFR)\n
    6. Left Ventricular Mass Index (LVMi)\n\n\n')

{user_input <- NULL
  cat('\nWhat is the format of your data set? \n 1. Excel (.xlsx) \n 2. Text Tab Delimited (.txt) \n 3. Comma Separated Text (.csv) \n 4. Other\n')
  user_input <- as.numeric(readline(prompt = "Please enter a value: "))
  
  if (user_input == 1) {
    df <- read_xlsx(file.choose())
  } else if (user_input == 2) {
    df <- read.delim(file.choose())
  } else if (user_input == 3) {
    df <- read.csv(file.choose())
  } else {
    cat('\nPlease use Excel, text tab delimited, or comma separated text')
  }
  
}

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the patients' ID?\n")

user_input <- as.numeric(readline(prompt = "Please enter a value: "))
Patient.ID<-df[,user_input]

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the Left Atria Volume?\n")

user_input <- as.numeric(readline(prompt = "Please enter a value: "))
LAvol<-df[,user_input]

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the Left Ventricular Volume?\n")

user_input <- as.numeric(readline(prompt = "Please enter a value: "))
LVvol<-df[,user_input]

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the BMI?\n")
user_input <- as.numeric(readline(prompt = "Please enter a value: "))
BMI<-df[,user_input]

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the eGFR?\n")
user_input <- as.numeric(readline(prompt = "Please enter a value: "))
GFR<-df[,user_input]

user_input <- NULL
print(data.frame(Columns=colnames(df)))
cat("\nWhich column contains the LVMi?\n")
user_input <- as.numeric(readline(prompt = "Please enter a value: "))
LVMi<-df[,user_input]


df2<-data.frame(Patient.ID=Patient.ID,ratio=as.numeric(LAvol)/as.numeric(LVvol), LV.Mass.Index=as.numeric(LVMi), GFR=as.numeric(GFR), BMI=as.numeric(BMI))

df3<-na.omit(df2)

if(length(which(df2$Patient.ID%in%df3$Patient.ID)>=1)){
  cat('\n\nThe following patients had missing values and the score was not able to be calculated:\n\n')
  print(df2$Patient.ID[!df2$Patient.ID%in%df3$Patient.ID])
}else{}

df3$Score<-predict(HFpEFcalc,newdata = df3,type='response')
df3$Predicted_Diagnosis<-'No HFpEF'
df3$Predicted_Diagnosis[df3$Score>=0.83]<-'HFpEF'

write.csv(df3,paste0(Analysis_Name,'_Results.csv'),row.names = F)
cat(paste0('\nThe results were saved in ', getwd(), ' as ',paste0(Analysis_Name,'_Results.csv')))

}

