library(data.table)
library(ggplot2)
library(magrittr)
library(purrr)
setwd('~/Projects/diabetes_prediction/')
df <- fread('data/diabetes_tidy.csv')

idx = c('encounter_id', 'patient_nbr')
df[,readmitted_bin := ifelse(readmitted == 'NO', 0, 1)]
categories <- names(df)[map_lgl(df,~uniqueN(.)%in%2:10)]



# categorical -------------------------------------------------------------


df[,setdiff(categories,'readmitted'),with=F] %>% 
  melt('readmitted_bin') %>% 
  .[,.(freq=.N),by=.(readmitted_bin, variable, value)] %>% 
  unique() -> dfplot

dfplot <- dfplot[value!='?']
dfplot[, readmitted_bin := factor(readmitted_bin, levels = c(1,0))]
dfplot[,freq_variable:= sum(freq), by = .(variable)]
dfplot[,freq_variable_value := sum(freq), by = .(variable, value)]
dfplot[,pct_variable_value := freq_variable_value / freq_variable]
dfplot <- dfplot[pct_variable_value>=0.01]
dfplot[, pct_value_bin := freq/freq_variable_value]
dfplot %>% 
  ggplot(aes(value,pct_value_bin,fill=factor(readmitted_bin))) + 
  geom_col(position='fill')+ geom_hline(yintercept = 0.5) + 
  facet_wrap('variable',scales = 'free')+ theme_minimal(base_size =15) + 
  theme(axis.text = element_blank()) + 
  labs(x=element_blank(),y=element_blank(),  fill = 'readmitted')


# density -----------------------------------------------------------------



numeric_variables <- c('time_in_hospital', 'num_lab_procedures', 
                       'num_medications', 'number_diagnoses')
df[,c(numeric_variables, 'readmitted_bin'),with=F] %>% 
  melt('readmitted_bin') %>% 
  ggplot(.,aes(value,fill=factor(readmitted_bin)))+
  geom_density(alpha=0.3)+
  facet_wrap('variable', scales='free')+
  theme_minimal(base_size = 15)+
  theme(legend.position = 'top')+
  labs(x=element_blank(),y=element_blank(),fill='readmitted')


# high carinality ---------------------------------------------------------


names(df)[map_lgl(df,~uniqueN(.)>1)] %>% 
  setdiff(.,c(numeric_variables,categories,idx)) %>% 
  c(.,'readmitted_bin') %>% unique() %>% 
  df[,.,with=F] %>% 
  melt('readmitted_bin') %>% 
  .[value!='?'] %>% 
  .[,.(freq=.N),by=.(variable, value, readmitted_bin)] %>% 
  .[,freq_value := .N, by = .(variable, value)] %>% 
  .[,freq_variable := .N, by=.(variable)] %>% 
  .[, pct_value := freq_value / freq_variable] %>% 
  .[pct_value>=0.01] %>% 
  .[,std_value := sd(freq,na.rm = T), by = .(variable, value)] %>% 
  .[,c('variable', 'value','std_value'),with=F] %>% unique() %>% 
  .[!is.na(std_value)] %>% 
  .[variable != 'payer_code'] %>% 
  ggplot(.,aes(reorder(value,std_value),std_value))+
    geom_col()+facet_wrap('variable',scales='free')+
    coord_flip()+
    theme_minimal(base_size = 15)+
    theme(axis.text = element_blank(), panel.grid = element_blank()) +
    labs(y='Standard Deviation of Frequency in Readmitted or Not', 
         x ='Categories')
    
  

 
