@echo off
dotnet publish -c RELEASE -o publish
tar -a -c -f publish.zip publish

set RESOURCE_GROUP=learn-ad85f8af-9a4b-437a-934c-75c7bcbd1e66
set LOCATION=westus
set APP_SERVICE_PLAN=nguyenduyhungPlan
set SERVICE_PLAN_PRICING_TIER=F1
set APP_SERVICE=nguyenduyhungAppservice
set WEBAPP_NAME=nguyenduyhungWebapp
set RUNTIME=DOTNETCORE:8.0
set SQL_SERVER_NAME=nguyenduyhungSqlserver
set SQL_DB_NAME=Products
set SQL_ADMIN_USER=nguyenduyhung
set SQL_ADMIN_PASSWORD=Str0ngPassword@T2311E!32561245
set DEPLOY_SC_PATH=publish.zip

rem Create appservice plan
echo Creating app service plan...
call az appservice plan create --name %APP_SERVICE_PLAN% --resource-group %RESOURCE_GROUP% --location %LOCATION% --sku %SERVICE_PLAN_PRICING_TIER% --is-linux 

rem Create webapp
echo Creating web app...
call az webapp create --resource-group %RESOURCE_GROUP% --plan %APP_SERVICE_PLAN% --name %WEBAPP_NAME% --runtime %RUNTIME%


rem Creating DB
echo Creating SQL Server...
call az sql server create --name %SQL_SERVER_NAME% --resource-group %RESOURCE_GROUP% --location %LOCATION% --admin-user %SQL_ADMIN_USER% --admin-password %SQL_ADMIN_PASSWORD% 

echo Creating SQL DB...
call az sql db create --resource-group %RESOURCE_GROUP% --server %SQL_SERVER_NAME% --name %SQL_DB_NAME% --service-objective S0

echo Creating firewall rule...
call az sql server firewall-rule create --name all-ip-firewall --resource-group %RESOURCE_GROUP% --server %SQL_SERVER_NAME% --start-ip-address 0.0.0.0 --end-ip-address  255.255.255.255  

echo Setting connection string...
set CONNECTION_STRING=Server=tcp:%SQL_SERVER_NAME%.database.windows.net,1433;Initial Catalog=%SQL_DB_NAME%;Persist Security Info=False;User ID=%SQL_ADMIN_USER%;Password=%SQL_ADMIN_PASSWORD%;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

call az webapp config connection-string set --name %WEBAPP_NAME% --resource-group %RESOURCE_GROUP% --settings DefaultConnection="%CONNECTION_STRING%" --connection-string-type SQLAzure
  
echo Deploying app...
call az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %WEBAPP_NAME% --src  %DEPLOY_SC_PATH%





