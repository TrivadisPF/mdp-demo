# mdp-demo
Demo of a Modern Data Platform


## Setup

Download Starburst license file `starburstdata.licencse` and place it in `mdp-demo/platys/lincense/starburstdata`. Change the permissions

```bash
chmod 644 mdp-demo/platys/lincense/starburstdata/starburstdata.license
```

Now you can start the platform

```bash
docker compose up -d
```

## Using Starburst

Download Starburst ODBC Driver from here: <https://docs.starburst.io/clients/odbc.html>


## Data

Hospital Admission Data
  
  * <https://www.kaggle.com/datasets/ashishsahani/hospital-admissions-data?resource=download>


  
  
## Current Infrastructure

  * **Analytics Backend**
    * **Machine:** AWS Lightsail Ubuntu 22.04 VM (16 GB RAM, 4 vCPUs, 320 GB SSD)
    * **Public IP:** `3.122.237.29`	  	
    * **User:** `ubuntu` 
    * **Platys Homepage:** <http://3.122.237.29>
    * **Platys Folder** `/home/ubuntu/mdp-demo/platys`
 
  * Reporting Server  
    * **Machine:** AWS Lightsail Windows Server 2022 (16 GB RAM, 4 vCPUs, 320 GB SSD)
    * **Public IP:** `18.184.227.254`  	
    * **User:** `Administrator` 