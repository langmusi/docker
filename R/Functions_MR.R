
# Functions used for Monthly Report ABT

############## createDf_fordon function ###########################
# aim: To generate df dataframe after reading in SQL query for all parts of analysis
# key columns in this func: FordonsTyp, littera, DefectDateAndTime
# considered data scenarios: FordonsTyp should exist in the data, which is true, generally. littra, could be Littera sometimes.
# parameter: df
# new elements created by the func: X11-X14 as a new group for FordonsTyp which covers all start with "X"
#                                   ER1 from littera should be groupped to DOSTO
###################################################################

# Function to group X11-x14 and add trains = ER1 to Dosto
createDf_fordon <- function(df) {
  # error checking: in case we have the column names in different format (capitle, low-cased)
  col_names <- as.vector(colnames(df))
  
  df$FordonsTyp <- as.character(df$FordonsTyp)
  df$FordonsTyp[grepl('^X', df$FordonsTyp) == TRUE] <- 'X11-X14'
    
  
  # the known fordonstyp (default)
  fordontype_list <- c('CORADIA', 'DOSTO', 'ITINO', 'REGINA', 'X11-X14')
  
  if (setequal(unique(df$FordonsTyp), fordontype_list)) {
    
    if ('littera' %in% col_names ) {
      
      # add into Dosto
      df$littera <- as.character(df$littera)
      df$FordonsTyp <- if_else(df$littera == 'ER1', 'DOSTO', df$FordonsTyp)
      
    } else if(any(str_detect(col_names, "Littera"))) {
      
      df <- rename(df, 'littera' = 'Littera')  # littera - new name, Littera - old name 
      # add into Dosto
      df$littera <- as.character(df$littera)
      df$FordonsTyp <- if_else(df$littera == 'ER1', 'DOSTO', df$FordonsTyp)
    }
  }
  
  
  if ("DefectDateAndTime" %in% col_names) {
    
    # convert to date
    df$DefectDateAndTime <- as.Date(df$DefectDateAndTime)
    
  }

  return(df)
  
}




############# plot functions ####################
# # This part of the functions are used to plot the graphs in the report

# mycolors <- c("#005A84", "#A7A9AC", "#00A2DB", "#58595B", "#8ED8F8",  
#               "#00ACA1", "#E31C79", "#000000",  
#               brewer.pal(name = "Dark2", n = 8),
#               brewer.pal(name="Paired", n = 6), brewer.pal(name="Set3", n = 8),
#               brewer.pal(name = "BrBG", n = 8))


# mycolors_mkm_ma <- c("#005A84", "#A7A9AC", "#00A2DB", "#58595B", "#8ED8F8",  
#               "#00ACA1", "#E31C79", "#000000",  
#               brewer.pal(name = "Dark2", n = 8),
#               brewer.pal(name="Paired", n = 6), brewer.pal(name="Set3", n = 8),
#               brewer.pal(name = "BrBG", n = 8))



# my_theme <- theme_minimal() +
#   theme(axis.line.x = element_line(color = "grey80"),
#         panel.background = element_rect(fill = "grey98", color = "grey91"),
#         panel.grid.major.y = element_line(color = "grey78", linetype = 3),
#         panel.grid.major.x = element_line(color = "grey78", linetype = 3),
#         panel.grid.minor.x = element_line(color = "grey100", linetype = 3),
#         panel.grid.minor.y = element_line(color = "grey100", linetype = 3),
#         text = element_text(family="CMU Sans Serif", size=14),
#         plot.title = element_text(size = 11,
#                                   margin=unit(c(2,0,2,0), "mm")),
#         plot.caption = element_text(size = 7),
#         axis.title.x = element_text(size = 8),
#         axis.title.y = element_text(angle = 90, vjust = 0.5, size = 8),
#         axis.text.x = element_text(angle = 45, hjust = 1, size = 6),
#         axis.text.y = element_text(size = 6),
#         legend.position = "right", legend.title=element_text(size = 8), 
#         legend.text = element_text(size = 8)) 


# my_theme_efu <- theme_minimal() +
#   theme(axis.line.x = element_line(color = "grey80"),
#         panel.background = element_rect(fill = "grey98", color = "grey91"),
#         panel.grid.major.y = element_line(color = "grey78", linetype = 3),
#         panel.grid.major.x = element_line(color = "grey78", linetype = 3),
#         panel.grid.minor.x = element_line(color = "grey100", linetype = 3),
#         panel.grid.minor.y = element_line(color = "grey100", linetype = 3),
#         text = element_text(family="CMU Sans Serif", size=14),
#         plot.title = element_text(size = 11,
#                                   margin=unit(c(2,0,2,0), "mm")),
#         plot.caption = element_text(size = 7),
#         axis.title.x = element_text(size = 8),
#         axis.title.y = element_text(angle = 90, vjust = 0.5, size = 8),
#         axis.text.x = element_text(angle = 45, hjust = 1, size = 6),
#         axis.text.y = element_text(size = 6),
#         legend.position = "right", legend.title=element_blank()) 

# my_theme_efu_top <- theme_minimal() +
#   theme(axis.line.x = element_line(color = "grey80"),
#         panel.background = element_rect(fill = "grey98", color = "grey91"),
#         panel.grid.major.y = element_line(color = "grey78", linetype = 3),
#         panel.grid.major.x = element_line(color = "grey78", linetype = 3),
#         panel.grid.minor.x = element_line(color = "grey100", linetype = 3),
#         panel.grid.minor.y = element_line(color = "grey100", linetype = 3),
#         text = element_text(family="CMU Sans Serif", size=14),
#         plot.title = element_text(size = 11,
#                                   margin=unit(c(2,0,2,0), "mm")),
#         plot.caption = element_text(size = 7),
#         axis.title.x = element_text(size = 8),
#         axis.title.y = element_text(angle = 90, vjust = 0.5, size = 8),
#         axis.text.x = element_text(angle = 45, hjust = 1, size = 6),
#         axis.text.y = element_text(size = 6),
#         legend.position = "none") 


######################### open_group function ###############
# aim: prepare the data to the plot. Only those defects that are still open at the end of the months are chosen
# ###########################################################
open_group <- function(mydat) {
  
  mydat <- mydat %>% 
    group_by(Month, Defectnumber) %>%
    mutate(UniqueCount = n_distinct(Defectnumber)) %>% filter(dt == max(dt)) 
    
}



################### open_warranty_plot function ###############
# aim: plot normalized total unique number of defect number, and plot the line for data with warranty = 1
# parameters: data1 = the dataset from open_group function;data2 = data with warranty 1 
#             index = index of the fordon list that is created in the beginning of the Rmarkdown
###############################################################

# Add guaranteed defects per vehicle onto the bar chart

open_warranty_plot <- function(data1, data2, index) {
  
  unique_trainset_total_num <- length(unique(d_vehicle$TrainsetVehicleNumber))
  
  data1 %>% group_by(Month, Defectnumber) %>%
    mutate(plot_y = UniqueCount/unique_trainset_total_num) %>%
    ggplot(aes(x = factor(Month), 
                           y = plot_y,  # normalizing
                           fill = factor(OpenInterval))) +     
    geom_col()# +
    # geom_point(data = data2, aes(x = Month, 
    #                              y = my_freq/unique_trainset_total_num, 
    #                              group = 1), alpha = 0) + 
    # geom_line(data = t, aes(x = Month, 
    #                            y = my_freq/unique_trainset_total_num,
    #                            colour = 'my_freq',
    #                            group = 1), 
    #              # spline_shape = -0.1, 
    #              #linetype="dashed", size = 1.05, open = TRUE, rep_ends=TRUE) + 
    #               linetype="dashed", size = 1.05) + 
    # scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    # scale_colour_manual(name = "Garantiskador", values = c("my_freq" = "black"), labels = NULL) +
    # scale_fill_manual("", values = mycolors) +
    # labs(x = 'Månad', y = 'Antal skador per fordon', 
    #                   title = "Antal öppna skador per fordon färgat efter tidsintervall",
    #                   caption = fordontype_list[index]) +
    # my_theme

}



########################### Reported Defects Plot ################

############## total_prop_func ######################
# parameter: index = index of the fordon list that is created at the beginning.
# return 2 datasets: data1 = subset of the original data, data2 = summary of grouped unique number of Defectnumber
####################################################
total_prop_func <- function(mydata, index) {
  
  d <- subset(mydata, FordonsTyp == fordontype_list[index])
  
  d <- d %>%
    group_by(DefectDateAndTime, Defectnumber) %>%
    mutate(UniqueCount = n_distinct(Defectnumber)) %>% 
    filter(!is.na(Otex)) %>% slice(1) %>% ungroup()
  
  t <- d %>%
    group_by(Month) %>%
    summarise(my_sum = sum(UniqueCount))
  
  # calculation of the percentage of unique Defectnumber in one month
  for (i in 1:length(d$UniqueCount)) {
    for (j in 1:length(t$Month))
      if (d$Month[i] == t$Month[j]) {d$prop[i] = d$UniqueCount[i]/t$my_sum[j]}
  }
  
  #resList <- list("data1" = d, "data2" = t)
  return(d)
  
}  


# my_plot <- function(data, index) {
# 
#   ggplot(data, aes(x = Month, y = UniqueCount, 
#                    fill = Otex)) +
#     geom_bar(stat = 'identity') + 
#     labs(x = 'Månad', y = 'Antal skador', 
#          title = 'Antal inrapporterade skador per skadekodskategori',
#          caption = fordontype_list[index]) +
#     scale_fill_manual(values = mycolors) +
#     my_theme
# 
# }

my_plot <- function(data, index) {
  
  ggplot(data, aes(x = Month, y = UniqueCount, 
                   fill = Otex)) +
    geom_bar(stat = 'identity', width = 0.6) + 
    labs(x = 'Månad', y = 'Antal skador', 
         title = 'Antal inrapporterade skador per skadekodskategori',
         caption = fordontype_list[index]) +
    scale_fill_manual(values = mycolors) +
    my_theme
  
}


# Plot percentage of defects each month
my_prop_plot <- function(data, index) {

  ggplot(data, aes(x = Month, y = prop, 
                   fill = Otex)) + 
    geom_bar(stat = 'identity', position = "stack", width = 0.6) + 
    labs(x = 'Månad', y = 'Andel skador per månad', 
                      title = 'Andel inrapporterade skador per skadekodskategori',
                      caption = fordontype_list[index]) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_fill_manual(values = mycolors) +
    my_theme

}



################# 100 000km ##########################

# Moving average function
ma <- function(x, n = n){stats::filter(x, rep(1 / n, n), sides = 1)}


# moving average plot for the earlier compuatation for 100 000km

mkm_ma_plot <- function(data1, data2, index) {

  ggplot(data = data1, 
         aes(x=Month, y = summa/AntalFordon, 
                           fill=InformationClassCode)) +     
    geom_bar(width = 0.7, stat = "unique", position = "stack") +
    geom_point(data = data2, aes(x = Month, y = movingAve, group = 1), 
               alpha = 0) + 
    geom_line(data = data2, aes(x = Month, y = movingAve, colour = 'movingAve', group = 1), 
                 #spline_shape = -0.3,
                 #linetype="dashed", size = 1.05, open = TRUE, rep_ends=TRUE) + 
                 linetype="dashed", size = 1.05) + 
    scale_colour_manual(name = "Rullande medelvärde 90 dagar", values = c("movingAve" = "black"), 
                        labels = NULL) +
    scale_fill_manual("", values = mycolors_mkm_ma) +
    labs(x = 'Månad', y = 'Antal skador per 100 000 km', 
         title = "Antal fel per 100 000 km normerat färgat efter informationsklass",
         caption = fordontype_list[index]) +
    my_theme

}


# Function to compute total wrong per 100 000km

############ datPrepareFunc function ###############
# key variables: distance = comes from SQL query
datPrepareFunc <- function(df, fordonstyp) {
  
  df <- df %>% filter(FordonsTyp == fordonstyp) 
  
  # räkna antal skador per fordon och månad. detta dividerat på fordonets körda distans, varpå man
  # multiplicerar med 100 000
  
  df <- df %>% group_by(Month, TrainsetVehicleNumber) %>% 
    mutate(UniqueCount = (n_distinct(Defectnumber) / max(distance)) * 100000) %>% ungroup()
  
  # Räknar ut antalet unika fordon i varje månad
  
  df <- df %>% group_by(Month) %>% 
    mutate(AntalFordon = (n_distinct(TrainsetVehicleNumber, na.rm = TRUE))) %>% ungroup()
  
  # räknar ut antalet skador per månad fordon och informationsklass
  
  df <- df %>% group_by(Month,TrainsetVehicleNumber, InformationClassCode) %>% 
    mutate(SkadorInforklass= (n_distinct(Defectnumber))) %>% ungroup()
  
  # räknar ut totala antalet skador per fordon och månad
  
  df <- df %>% group_by(Month, TrainsetVehicleNumber) %>% 
    mutate(AntalSkador = (n_distinct(Defectnumber))) %>% ungroup()
  
  # kollar proportionen av anatalet skador på varke infoklass gentemot totala antalet skador (blir separat på varje
  # fordon och månad pga hur det är uppbuggt ovan)
  
  df$propInfoklass = df$SkadorInforklass/df$AntalSkador
  
  ## räknar ut hur mycket varje infoklass motsvarar av uniqueCount - se definition oav uniqueCount ovan
  
  df$summa = df$UniqueCount*df$propInfoklass
  
  # nedan loop är till för att skapa ny kolumn av test för att inte räkna med dubbelt pga flera rader för
  # (en rad för varje sakda)
  
  df$UniqueCountN = numeric(length(df$Defectnumber))
  
  df <- df[order(df$TrainsetVehicleNumber, df$Month, df$summa ),] 
  
  for (i in 1:length(df$Defectnumber)){
    
    if (i < length(df$Defectnumber)){
      
      if (df$TrainsetVehicleNumber[i] == df$TrainsetVehicleNumber[i+1] & 
          df$Month[i] == df$Month[i+1] & ((df$summa[i] == df$summa[i+1]) 
                                          | (is.na(df$summa[i]) == TRUE | is.na(df$summa[i+1]) == TRUE))
          & df$InformationClassCode[i] == df$InformationClassCode[i+1]){
        
        df$UniqueCountN[i] = df$summa[i+1]
        
      }
      
      
    }
    
    
  }
  
  # Färdigställer kolumnen som det sedan ska summeras över
  
  df$summa<- df$summa - df$UniqueCountN
  
  #test = df %>% filter(TrainsetVehicleNumber == 'ER1001')
  
  return(df) 
}


############################ EFU ######################
## Function: EFU
## Eftersläpande förebyggande underhåll färgat efter lätt/tungt underhåll

# timeF <- function(data, timestamp, nrOfDays){
#   
#   data$tid = timestamp
#   data <- data %>% filter(tid > (today() - nrOfDays))
#   data <- data %>% select(-tid)
#   return(data)
#   
# }


# Function to select fordonstyp

vType <- function(data, vTypeCol, vType1){
  
  data$typ = vTypeCol
  data <- data %>% filter(typ == vType1)
  data <- data %>% select(-typ)
  return(data)
  
}


efu_t_l <- function(d, tung_kod) {
  
  d <- d %>% mutate(Maintenance_1 = if_else(ActionSelectionGroup %in% tung_kod,
                                                      'Tungt','Lätt', missing = "Lätt"))
  
  d <- d %>% mutate(Maintenance_2 = if_else(ActionSelectionGroup %in% tung_kod,
                                                      'Tungt','Lätt'))
  
  test_1 <- d %>% filter(Maintenance_1 == "Lätt", !is.na(ActionSelectionGroup)) %>% 
    arrange(TrainsetVehicleNumber, desc(DataTimeStamp)) %>% 
    group_by(TrainsetVehicleNumber) %>% slice(1) 
   

  d <- d %>% mutate(Maintenance = if_else(is.na(ActionSelectionGroup) & Maintenance_1 == "Lätt" &
                                            EFUIDD %in% c(unique(test_1$EFUIDD)), 
                                                    "Lätt", 
                                          if_else(!is.na(ActionSelectionGroup), Maintenance_1, Maintenance_2)))

  
  d$Maintenance <- factor(d$Maintenance, levels = c("Lätt", "Tungt"))
  
  return(d)
}



# 
# mydata$Maintenance <- vector(length = nrow(mydata))
# 
# for (i in 1:nrow(mydata)) {
#   if (is.na(mydata$ActionSelectionGroup[i]) && mydata$Maintenance_1[i] == "Lätt" 
#       && mydata$EFUIDD[i] %in% c(unique(test_1$EFUIDD))) {
#     
#     mydata$Maintenance[i] <- "Lätt"
#     
#   } else {mydata$Maintenance[i] <- NA}
# }

# test
# t <- data.frame(ActionSelectionGroup = c(NA, "b", NA), 
#                 Maintenance_1 = c("lätt", "tungt", "lätt"),
#                 efuid = c("aa", "ab", "aa"))
# t
# efuid <- c("aa", "aa")
# t$Maintenance <- vector(length = nrow(t))
# for (i in 1:nrow(t)) {
#   if ((is.na(t$ActionSelectionGroup[i]) && t$Maintenance_1[i] == "lätt") && t$efuid[i] %in% c(unique(efuid)) ) {
#     
#     t$Maintenance[i] <- "Lätt"
#     
#   }
# }
# 
# t


# Function to group by two categories and count distinct values of one column 

groupBy <- function(data=df, category1 = df$Month, category2 = df$Maintenance, countds = df$EFUIDD) {
  
  
  data$category1 = category1
  data$category2 = category2
  data$countds = countds
  data <- data %>% 
    group_by(category1, category2) %>%
    mutate(UniqueCount = n_distinct(countds)) %>% ungroup()
  data <- data %>% select(-c(category1, category2, countds))
  return(data)
  
}


# Function to select maintenance for top lists

maintF <- function(data, maintCol, maintType) {
  
  data$typ = maintCol
  data = data %>% filter(typ == maintType)
  data = data %>% select(-typ)
  return(data)
  
}


## Function for preparing top lists ##

topList <- function(df) {
  
  df <- groupBy(df, category1 = df$SplitCode_Name, category2 = df$Maintenance, countds= df$EFUIDD)
  df = df %>% select(-EFUIDD)
  df = distinct(df)
  df = head(df[order(df$UniqueCount, decreasing=TRUE), ], 10)
  return(df)
  
}


## EFU plot function
mycolors_efu <- c("#005A84", "#A7A9AC") 

efu_month_plot <- function(my_dat, index) {

  ggplot(data=my_dat, 
         aes(x=Month, y = UniqueCount/length(unique(d$TrainsetVehicleNumber)), fill=Maintenance)) + 
    geom_bar(width = 0.6, stat = "unique", position = "stack") +
    labs(x = 'Månad', y = 'Antal åtgärder per fordon', 
         title = 'Eftersläpande förebyggande underhåll per fordon färgat efter lätt/tungt underhåll',
         caption = fordontype_list[index]) +
    scale_fill_manual(values = mycolors_efu) +
   my_theme_efu

}


### EFU light maintenance actions plot

efu_toplist_light_plot <- function(my_dat, index) {

  ggplot(data = my_dat, aes(x=reorder(SplitCode_Name, UniqueCount), 
                            y = UniqueCount, 
                            fill=Maintenance)) + 
    geom_bar(width = 0.6, stat = "unique", position = "stack", show.legend = NA) +
    labs(x = '', y = 'Antal åtgärder', 
         title = 'Eftersläpande Lätt underhåll - topplista',
         caption = fordontype_list[index]) +
    coord_flip() + scale_x_discrete(position = "top") +
    scale_fill_manual(values = mycolors_efu) +
    my_theme_efu_top

}


### EFU heavy maintenance actions plot

efu_toplist_heavy_plot <- function(my_dat, index) {
  
  ggplot(data = my_dat, aes(x=reorder(SplitCode_Name, UniqueCount), 
                            y = UniqueCount, 
                            fill=Maintenance)) + 
    geom_bar(width = 0.6, stat = "unique", position = "stack", show.legend = NA)  + 
    labs(x = '', y = 'Antal åtgärder', 
         title = 'Eftersläpande Tungt underhåll - topplista',
         caption = fordontype_list[index]) +
    coord_flip() + scale_x_discrete(position = "top") +
    scale_fill_manual(values = mycolors_efu[2]) +
    my_theme_efu_top

}

