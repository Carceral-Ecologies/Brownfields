#==========================================================================================================
#Server
#==========================================================================================================
server <- function(input, output, session) {
  
  #load update inputs file
  #load_update_inputs_path = file.path('app-scripts','server-scripts','update_inputs.R')
  #source(load_update_inputs_path)
  
  #-----------------------------------------------------------------------------------------
  #Update Inputs
  #-----------------------------------------------------------------------------------------
  
  #Create new filters if switchInput is turned on. 
  sfs_inputs <- reactive({
    if (input$sfs_include == TRUE) {div(hr(),
                                        splitLayout(p("with at least"),
                                                    numericInput(inputId = "sfs_num", 
                                                                 label = NULL, 
                                                                 min = 1,
                                                                 value = 1, 
                                                                 step = 1),
                                                    p("superfund sites"),
                                                    cellWidths = c("35%", "30%", "35%"), 
                                                    cellArgs = list(style = "vertical-align: top")),
                                        splitLayout(p("within"),
                                                    sliderInput(inputId = "sfs_proximity_val", 
                                                                label = NULL, 
                                                                min = 0, 
                                                                max = 5000, 
                                                                value = 1000, 
                                                                step = 100),
                                                    p("meters"),
                                                    cellWidths = c("20%", "60%", "20%")
                                        ))}
  })
  mil_inputs <- reactive({
    if (input$mil_include == TRUE) {div(hr(),
                                        splitLayout(p("with at least"),
                                                    numericInput(inputId = "mil_num", 
                                                                 label = NULL, 
                                                                 min = 1,
                                                                 value = 1, 
                                                                 step = 1),
                                                    p("military bases"),
                                                    cellWidths = c("35%", "30%", "35%"), 
                                                    cellArgs = list(style = "vertical-align: top")),
                                        splitLayout(p("within"),
                                                    sliderInput(inputId = "mil_proximity_val", 
                                                                label = NULL, 
                                                                min = 0, 
                                                                max = 5000, 
                                                                value = 1000, 
                                                                step = 100),
                                                    p("meters"),
                                                    cellWidths = c("20%", "60%", "20%")
                                        ))} 
  })
  ap_inputs <- reactive({
    if (input$ap_include == TRUE) {div(hr(),
                                       splitLayout(p("with at least"),
                                                   numericInput(inputId = "ap_num", 
                                                                label = NULL, 
                                                                min = 1,
                                                                value = 1, 
                                                                step = 1),
                                                   p("airports"),
                                                   cellWidths = c("35%", "30%", "35%"), 
                                                   cellArgs = list(style = "vertical-align: top")),
                                       splitLayout(p("within"),
                                                   sliderInput(inputId = "ap_proximity_val", 
                                                               label = NULL, 
                                                               min = 0, 
                                                               max = 5000, 
                                                               value = 1000, 
                                                               step = 100),
                                                   p("meters"),
                                                   cellWidths = c("20%", "60%", "20%")
                                       ))}
  })
  tri_inputs <- reactive({
    if (input$tri_include == TRUE) {div(hr(),
                                        splitLayout(p("with at least"),
                                                    numericInput(inputId = "tri_num", 
                                                                 label = NULL, 
                                                                 min = 1,
                                                                 value = 1, 
                                                                 step = 1),
                                                    p("TRI Facilities"),
                                                    cellWidths = c("35%", "30%", "35%"), 
                                                    cellArgs = list(style = "vertical-align: top")),
                                        splitLayout(p("within"),
                                                    sliderInput(inputId = "tri_proximity_val", 
                                                                label = NULL, 
                                                                min = 0, 
                                                                max = 5000, 
                                                                value = 1000, 
                                                                step = 100),
                                                    p("meters"),
                                                    cellWidths = c("20%", "60%", "20%")
                                        ))} 
    
  })
  
  
  #Add new inputs to sidebar
  output$sfs_new_inputs <- renderUI({
    sfs_inputs()
  }) 
  
  output$mil_new_inputs <- renderUI({
    mil_inputs()
  }) 
  
  output$ap_new_inputs <- renderUI({
    ap_inputs()
  }) 
  
  output$tri_new_inputs <- renderUI({
    tri_inputs()
  }) 
  
  #-----------------------------------------------------------------------------------------
  #Icons
  #-----------------------------------------------------------------------------------------
  
  #carceral facility icon
  icon_pb <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g4642.png?raw=true", 
                   iconWidth = 20, 
                   iconHeight = 20)
  
  #selected carceral facility icon (red)
  icon_pb_selected <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g4642-red.png?raw=true", 
                            iconWidth = 20, 
                            iconHeight = 20)
  
  #brownfields icon
  icon_bf <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g5269.png?raw=true", 
                   iconWidth = 20, 
                   iconHeight = 20)
  
  #superfund sites icon
  icon_sfs <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g945.png?raw=true", 
                    iconWidth = 20, 
                    iconHeight = 20)
  
  #airports icon
  icon_ap <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/path863.png?raw=true", 
                   iconWidth = 20, 
                   iconHeight = 20)
  
  #military base icon
  icon_mil <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/path865.png?raw=true", 
                    iconWidth = 20, 
                    iconHeight = 20)
  
  #tri sites icon
  icon_tri <- icons(iconUrl = "https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g335.png?raw=true", 
                    iconWidth = 20, 
                    iconHeight = 20)
  
  #-----------------------------------------------------------------------------------------
  #Populate filters when state selected
  #----------------------------------------------------------------------------------------- 
  
  #The app will observe when a user selects a new state and list the names of the carceral facilities associated with that state in the carceral facility search dropdown
  observeEvent(input$state, {
    
    pb_sf_filtered <- 
      pb_sf %>% 
      filter(STATE == input$state) #filter carceral facilities df to selected state
    
    carceral_facility_list <- setNames(pb_sf_filtered$FID, pb_sf_filtered$NAME) #create a named vector with carceral facility names specifying their ids
    updatePickerInput(session, 
                      inputId = "name", 
                      choices = carceral_facility_list, 
                      selected = NULL) #update the update picker input with the carceral facility names for that state
    updatePickerInput(session, 
                      inputId = "status", 
                      choices = sort(unique(pb_sf_filtered$STATUS)), 
                      selected = sort(unique(pb_sf_filtered$STATUS))) #update the update picker input with the carceral facility status for that state
    updatePickerInput(session, 
                      inputId = "type", 
                      choices = sort(unique(pb_sf_filtered$TYPE)), 
                      selected = sort(unique(pb_sf_filtered$TYPE))) #update the update picker input with the carceral facility types for that state
    updateNumericInput(session, 
                       inputId = "capacity", 
                       min = min(pb_sf_filtered$CAPACITY), 
                       max = max(pb_sf_filtered$CAPACITY), 
                       value = min(pb_sf_filtered$CAPACITY)) #update the update picker input with the capcities for that state
  })
  
  #-----------------------------------------------------------------------------------------
  #Create map
  #----------------------------------------------------------------------------------------- 
  
  output$dist_plot <- renderLeaflet({
    #Filter all site dfs to the selected state
    bf_filtered <- 
      bf_sf %>%
      filter(STATE_CODE == input$state)
    sfs_filtered <- 
      sfs_sf %>%
      filter(STATE_CODE == input$state)
    pb_sf_filtered <- 
      pb_sf %>%
      filter(STATE == input$state)
    ap_sf_filtered <- 
      ap_sf %>%
      filter(state_post_office_code == input$state)
    mil_sf_filtered <- 
      mil_sf %>%
      filter(STATE_CODE == input$state)
    tri_sf_filtered <- 
      tri_sf %>%
      filter(X8..ST == input$state)
    
    #Create a legend displaying icons and labels
    html_legend <- 
      "<img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g4642.png?raw=true' style='width:20px;height:20px; margin:5px;'>Carceral Facilities<br/>
                                        <img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g5269.png?raw=true' style='width:20px;height:20px; margin:5px;'>Brownfields<br/>
                                        <img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g945.png?raw=true' style='width:20px;height:20px; margin:5px;'>Superfund Sites<br/>
                                        <img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/path863.png?raw=true' style='width:20px;height:20px; margin:5px;'>Airports<br/>
                                        <img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/path865.png?raw=true' style='width:20px;height:20px; margin:5px;'>Military Bases<br/>
                                        <img src='https://github.com/Carceral-Ecologies/Carceral-Proximity-Analysis/blob/master/icons/g335.png?raw=true' style='width:20px;height:20px; margin:5px;'>TRI Facilities (reporting in 2018)"
    
    if (nrow(bf_filtered) < 1 |
        nrow(sfs_filtered) < 1 |
        nrow(pb_sf_filtered) < 1 |
        nrow(ap_sf_filtered) < 1 |
        nrow(mil_sf_filtered) < 1 |
        nrow(tri_sf_filtered) < 1 ) { showModal(modalDialog(title = "Heads up!",
                                                            "Please select a different state.."
        ))}
    #Create map and add markers for each site
    else { leaflet() %>%
        #setView(lat = 40.7, lng = -100.0, zoom = 3) %>%
        addProviderTiles("OpenStreetMap", group = "OpenStreetMap") %>%
        addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron") %>% 
        addProviderTiles("Esri.WorldImagery", group = "Esri.WorldImagery") %>% 
        addMarkers(clusterId = "tri",
                   clusterOptions = markerClusterOptions(),
                   data = tri_sf_filtered, 
                   icon = icon_tri,
                   label = ~X4..FACILITY.NAME, 
                   group = "TRI Facilities") %>%
        addMarkers(clusterId = "airports",
                   clusterOptions = markerClusterOptions(),
                   data = ap_sf_filtered, 
                   icon = icon_ap,
                   label = ~fac_name, 
                   group = "Airports") %>%
        addMarkers(clusterId = "military",
                   clusterOptions = markerClusterOptions(),
                   data = mil_sf_filtered, 
                   icon = icon_mil,
                   label = ~SITE_NAME, 
                   group = "Military Bases") %>%
        addMarkers(clusterId = "brownfields",
                   clusterOptions = markerClusterOptions(),
                   data = bf_filtered, 
                   icon = icon_bf,
                   label = ~PRIMARY_NAME,
                   group = "Brownfields") %>%
        addMarkers(clusterId = "superfund",
                   clusterOptions = markerClusterOptions(),
                   data = sfs_filtered, 
                   icon = icon_sfs,
                   label = ~PRIMARY_NAME,
                   group = "Superfund Sites") %>%
        addMarkers(data = pb_sf_filtered, 
                   icon = icon_pb,
                   label = ~NAME, 
                   group = "Carceral Facilities", 
                   layerId = ~FID) %>%
        #Add controls to turn layers on and off
        addLayersControl(baseGroups = c("CartoDB.Positron", 
                                        "Esri.WorldImagery", 
                                        "OpenStreetMap"),
                         overlayGroups=c("Carceral Facilities", 
                                         "Brownfields", 
                                         "Superfund Sites", 
                                         "Airports", 
                                         "Military Bases", 
                                         "TRI Facilities"),
                         options=layersControlOptions(collapsed=TRUE)
        ) %>%
        addControl(html = html_legend, position = "bottomright") %>% 
        hideGroup("Airports") %>% 
        hideGroup("Brownfields") %>% 
        hideGroup("Superfund Sites") %>% 
        hideGroup("Military Bases") %>%
        hideGroup("TRI Facilities")
    }
  })
  
  #-----------------------------------------------------------------------------------------
  #Set Pop-up
  #-----------------------------------------------------------------------------------------
  
  #When a user clicks on a carceral facility, this popup will display at the lat lng of the click with information about the carceral facility clicked on.
  show_carceral_facility_popup <- function(carceral_facility, lat, lng){
    
    selected_carceral_facility <- 
      pb_sf %>%
      filter(pb_sf$FID == carceral_facility) #Filter the carceral facility df to the clicked on carceral facility
    
    #Generate text about the carceral facility for the popup, including distance calculations
    content <- as.character(tagList(
      tags$h4(selected_carceral_facility$NAME),
      tags$strong(sprintf("%s", selected_carceral_facility$ADDRESS),
                  tags$br(),
                  sprintf("%s, %s %s",
                          selected_carceral_facility$CITY, 
                          selected_carceral_facility$STATE, 
                          selected_carceral_facility$ZIP)),
      tags$br(),
      sprintf("Type: %s", selected_carceral_facility$TYPE),
      tags$br(),
      sprintf("Status: %s", selected_carceral_facility$STATUS),
      tags$br(),
      sprintf("Capacity: %s", selected_carceral_facility$CAPACITY),
      tags$br(),
      sprintf("Population: %s", selected_carceral_facility$POPULATION),
      tags$br(),
      sprintf("Number within %s meters:", 5000),
      tags$br(),
      sprintf("Superfund sites: %s", 
              pb_with_facility_distances %>% 
                filter(FID == carceral_facility & FACILITY_TYPE == "Superfund Site" & DISTANCES <= 5000) %>%
                nrow()),
      tags$br(),
      sprintf("Airports: %s", 
              pb_with_facility_distances %>% 
                filter(FID == carceral_facility & FACILITY_TYPE == "Airport" & DISTANCES <= 5000) %>%
                nrow()),
      tags$br(),
      sprintf("Military bases: %s", 
              pb_with_facility_distances %>% 
                filter(FID == carceral_facility & FACILITY_TYPE == "Military Base" & DISTANCES <= 5000) %>%
                nrow()),
      tags$br(),
      sprintf("TRI facilities: %s", 
              pb_with_facility_distances %>% 
                filter(FID == carceral_facility & FACILITY_TYPE == "TRI Facility" & DISTANCES <= 5000) %>%
                nrow())
    ))
    
    #Add popup to the map
    leafletProxy("dist_plot") %>% 
      addPopups(lng, lat, content, layerId = carceral_facility)
  }
  
  #When a user clicks on the map, the current popups will be cleared and the new popup will be generated. 
  observe({ 
    leafletProxy("dist_plot") %>% 
      clearPopups()
    
    #the format for click inputs in leaflet is: mapid_objecttype_eventtype 
    #when eventtype is set to click and the objecttype is set to marker, clicking on any marker stores three things in the variable event:
    #the lat, long, and the ID of the clicked marker; 
    #since we set the layerID to FID when adding markers above, the marker ID will be the FID in pb_sf
    event <- 
      input$dist_plot_marker_click 
    
    #This checks 1) whether the user clicked on an object, and 2) whether the user clicked on a carceral facility
    if (is.null(event) | is.null(event$id)) return() 
    
    
    isolate({
      show_carceral_facility_popup(event$id, 
                                   event$lat, 
                                   event$lng)})
  })
  
  #-----------------------------------------------------------------------------------------
  #Highlight Carceral Facility on Search
  #-----------------------------------------------------------------------------------------
  
  # This variable will store the row in the carceral facility df associated with the *previous* carceral facility selected in the carceral facility name search/dropdown (and marked in red on the map). We keep track of this row because when a new carceral facility is selected from the search/dropdown, we will need to replace the red marker on the map with a blue marker. 
  prev_carceral_facility <- reactiveVal()
  
  #This function will observe when a user selects a new name from the carceral facility name search/dropdown, and recolor that carceral facility's marker red on the map.  
  #Note that at times, with user input, the map reloads, replacing a currently red marker with a blue one, without the list of names changing. 
  #For instance, if a user selects a carceral facility type, but the currently selected name is still within the selected types, the map will reload without the names changing, turning all markers back to blue. 
  #We need to also watch for changes to other user inputs so that this event always gets triggered post-map reload.
  observeEvent(input$search, {
    
    #Filter the carceral facility df to the row with the selected name. Note that because we populated the carceral facility name dropdown as a named vector above (with carceral facility names naming FIDs), we are actuallly filtering to the row with the FID that equals the user input. 
    row_selected <- pb_sf %>%
      filter(pb_sf$FID == input$name)
    
    #Create a map object for controlling a map that's already been rendered.
    proxy <- leafletProxy('dist_plot')
    
    #Add red marker for selected row (carceral facility) to the map
    proxy %>%
      addMarkers(data = row_selected,
                 icon = icon_pb_selected,
                 label = ~row_selected$NAME,
                 group = "Carceral Facilities",
                 layerId = ~row_selected$FID)
    
    #Reset previously selected marker to blue
    #First check to make sure there was a previous carceral facility as there will not be a previous marker to reset on initial run of map
    if(!is.null(prev_carceral_facility())){ 
      if (row_selected != prev_carceral_facility()) {proxy %>%
          addMarkers(data = prev_carceral_facility(),
                     layerId = ~prev_carceral_facility()$FID,
                     icon = icon_pb)
        
      }
    }
    
    #Set the selected row (carceral facility) to be the next previous carceral facility. 
    prev_carceral_facility(row_selected)
  })
  
  #-----------------------------------------------------------------------------------------
  #Apply Filters
  #-----------------------------------------------------------------------------------------
  
  observeEvent(input$apply_filters, 
               {pb_filtered <- pb_with_facility_distances %>% #Apply basic filters
                 filter(STATUS %in% input$status & 
                          STATE == input$state & 
                          TYPE %in% input$type & 
                          CAPACITY >= input$capacity)
               
               apply_filters_fids <- c() #This will be a vector for storing the IDs of carceral facility meeting the criteria in the filter inputs
               
               at_least_one_proximity_filter <- 0 #This will track whether at least one proximity filter was turned on prior to the to Apply button
               first_filter <- 1 #This will track which filter was applied first
               
               if(input$sfs_include == TRUE){at_least_one_proximity_filter <- 1 #At least one proximity filter applied
               
               sfs_filters_fids <- pb_filtered %>%
                 filter(FACILITY_TYPE == "Superfund Site") %>%
                 filter(DISTANCES <= input$sfs_proximity_val) %>%
                 filter(PROXIMITY_INDEX >= input$sfs_num) %>%
                 distinct(FID) %>%
                 pull()
               
               if(input$any_all == "Any"){
                 apply_filters_fids <- union(apply_filters_fids, sfs_filters_fids)
                 #print(paste("union", length(sfs_filters_fids), "sfs"))
               }
               
               else if(input$any_all == "All"){
                 if(first_filter == 1){apply_filters_fids <- sfs_filters_fids} #If this is the first filter applied, set this vector to apply_filters_fids
                 else{apply_filters_fids <- intersect(apply_filters_fids, sfs_filters_fids)} #Otherwise find the intersection of the two
               }
               
               first_filter <- 0 #No longer first filter
               }
               
               if(input$mil_include == TRUE){at_least_one_proximity_filter <- 1 #At least one proximity filter applied
               
               mil_filters_fids <- pb_filtered %>%
                 filter(FACILITY_TYPE == "Military Base") %>%
                 filter(DISTANCES <= input$mil_proximity_val) %>%
                 filter(PROXIMITY_INDEX >= input$mil_num) %>%
                 distinct(FID) %>%
                 pull()
               
               if(input$any_all == "Any"){
                 apply_filters_fids <- union(apply_filters_fids, mil_filters_fids)
                 # print(paste("union", length(mil_filters_fids), "mil"))
               }
               
               else if(input$any_all == "All"){
                 if(first_filter == 1){apply_filters_fids <- mil_filters_fids} #If this is the first filter applied, set this vector to apply_filters_fids
                 else{apply_filters_fids <- intersect(apply_filters_fids, mil_filters_fids)} #Otherwise find the intersection of the two
               }
               
               first_filter <- 0 #No longer first filter
               }
               
               if(input$ap_include == TRUE){at_least_one_proximity_filter <- 1 #At least one proximity filter applied
               
               ap_filters_fids <- pb_filtered %>%
                 filter(FACILITY_TYPE == "Airport") %>%
                 filter(DISTANCES <= input$ap_proximity_val) %>%
                 filter(PROXIMITY_INDEX >= input$ap_num) %>%
                 distinct(FID) %>%
                 pull()
               
               if(input$any_all == "Any"){
                 apply_filters_fids <- union(apply_filters_fids, ap_filters_fids)
                 #print(paste("union", length(ap_filters_fids), "ap"))
               }
               
               else if(input$any_all == "All"){
                 if(first_filter == 1){apply_filters_fids <- ap_filters_fids} #If this is the first filter applied, set this vector to apply_filters_fids
                 else{apply_filters_fids <- intersect(apply_filters_fids, ap_filters_fids)} #Otherwise find the intersection of the two
               }
               
               first_filter <- 0 #No longer first filter
               }
               
               if(input$tri_include == TRUE){at_least_one_proximity_filter <- 1 #At least one proximity filter applied
               
               tri_filters_fids <- pb_filtered %>%
                 filter(FACILITY_TYPE == "TRI Facility") %>%
                 filter(DISTANCES <= input$tri_proximity_val) %>%
                 filter(PROXIMITY_INDEX >= input$tri_num) %>%
                 distinct(FID) %>%
                 pull()
               
               if(input$any_all == "Any"){
                 apply_filters_fids <- union(apply_filters_fids, tri_filters_fids)
                 #print(paste("union", length(tri_filters_fids), "tri"))
               }
               
               else if(input$any_all == "All"){
                 if(first_filter == 1){apply_filters_fids <- tri_filters_fids} #If this is the first filter applied, set this vector to apply_filters_fids
                 else{apply_filters_fids <- intersect(apply_filters_fids, tri_filters_fids)} #Otherwise find the intersection of the two
               }
               
               first_filter <- 0 #No longer first filter
               }
               
               #If no proximity filters were applied, pull only the IDs of the carceral facilities already filtered based on STATUS, CAPACTIY, and TYPE
               if(at_least_one_proximity_filter == 0){ 
                 apply_filters_fids <- pb_filtered %>%
                   distinct(FID) %>%
                   pull()
                 #print("no filters - applying all")
               }
               
               #Filter carceral facilities df to the IDs already filtered
               pb_sf_filtered <- pb_sf %>% 
                 filter(FID %in% apply_filters_fids)
               
               #Signal to user that no facilities meet criteria
               if (nrow(pb_sf_filtered) < 1) { showModal(modalDialog(title = "Heads up!",
                                                                     "No facilities meet this criteria."
               ))}
               #Otherwise filter map
               else {
                 #Create a map object for controlling a map that's already been rendered.
                 proxy <- leafletProxy('dist_plot')
                 
                 #Add markers to the map
                 proxy %>%
                   clearMarkers() %>%
                   addMarkers(data = pb_sf_filtered,
                              icon = icon_pb,
                              label = ~pb_sf_filtered$NAME,
                              group = "Carceral Facilities",
                              layerId = ~pb_sf_filtered$FID)
                 
                 carceral_facility_list <- setNames(pb_sf_filtered$FID, pb_sf_filtered$NAME) #create a named vector with carceral facility names specifying their ids
                 updatePickerInput(session, 
                                   inputId = "name", 
                                   choices = carceral_facility_list, 
                                   selected = NULL) #update the update picker input with the carceral facility names for that capacity
               }
               })
  
  
  
}