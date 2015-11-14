#install.packages("rjson")
library("RCurl")
library("rjson")

# Accept SSL certificates issued by public Certificate Authorities
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

h = basicTextGatherer()
hdr = basicHeaderGatherer()


req = list(
  
  Inputs = list(
    
    
    "input1" = list(
      "ColumnNames" = list("State", "Account_Length", "Int_l_Plan", "VMail_Plan", "VMail_Message", "Day_Mins", "Day_Calls", "Eve_Mins", "Eve_Calls", "Night_Mins", "Night_Calls", "Intl_Mins", "Intl_Calls", "CustServ_Calls", "Churn_"),
      "Values" = list( list( "NJ", "127", "no", "no", "0", "245", "91", "217", "92", "243", "128", "14", "6", "0", "null" ))
    )                )
)


body = enc2utf8(toJSON(req))

# REPLACE api_key below WITH THE API KEY FROM YOUR WEB SERVICE

api_key = "W6dZmkLWFudaEVbdoTEly+4cNuavDkx04EdCL7GRX12ea+gq0XyDT9BQENoVvEBbm98KzZ/mch3xqOMaLWyQ0A==" # Replace this with the API key for the web service
authz_hdr = paste('Bearer', api_key, sep=' ')

h$reset()

# REPLACE url BELOW WITH THE url FROM YOUR WEB SERVICE

curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/ca8e90eba96446ec9d275dde2fe84e6b/services/10fcfeffa664416aaa22c24cadcc43ae/execute?api-version=2.0&details=true",
            httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
            postfields=body,
            writefunction = h$update,
            headerfunction = hdr$update,
            verbose = TRUE
)

headers = hdr$value()
httpStatus = headers["status"]
if (httpStatus >= 400)
{
  print(paste("The request failed with status code:", httpStatus, sep=" "))
  
  # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
  print(headers)
}

print("Result:")
result = h$value()
print(fromJSON(result))
