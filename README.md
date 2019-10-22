# TelemetR - V2

The first attempt at telemetR (v0) was built as an exploratory data analysis and visualization tool. V1 was built using NodeJS and PostgreSQL as a web application. 

This current iteration will be different. After talking with many orgainizations that deal with huge amounts of telemetry data, the most common need was an easy way to manage the data. This version will attempt to accomplish that in a few different ways. 

## Road map

1. Bootstrap telemety database
1. Write & Read data from SQLite database
1. Create a package
1. Write as [Shiny app](http://shiny.rstudio.com/) or [RStudio Addin](https://rstudio.github.io/rstudio-extensions/rstudio_addins.html)
    * documentation site
1. Methods to extend the functionality (a plugin system)
1. Build and deploy as a SaaS (maybe?)