# Data Engineering on Azure

The repository contains additive code to the [Qimia blog post on Azure](https://www.qimia.io/en/blog/data-engineering-microsoft-azure-set-up).
It contains the following components:
* src 
    * DWH.sql: DDL statements to setup the Data Warehouse Schema (specific for Synapse)
    * NorthwindDataset.sql: DDL and DML statements to setup the Northwind Database (MS SQL Dialect)
    * setup.sh: Azure CLI script to automatically build the starting components. The Resource Group has to be setup 
    beforehand and the name has to be inserted in the script. Also, the prefix needs to be changed to make sure the 
    resource names stay unique.
* datafactory: Contains all the resources of the Data Factory from articles two and four. Data Factory implementations 
can be loaded from connected github- or azure devops repositories.
