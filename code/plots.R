library(data.table)
library(ggplot2)
library(magrittr)
library(purrr)
setwd('~/Projects/diabetes_prediction/')
df <- fread('data/diabetes_tidy.csv')

idx = c('encounter_id', 'patient_nbr')
df[,readmitted_bin := ifelse(readmitted == 'NO', 0, 1)]
categories <- names(df)[map_lgl(df,~uniqueN(.)%in%2:10)]

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

