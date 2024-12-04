echo "Please enter the URL you want to send the request to:"
read url

echo "⌛️ Waiting on response from " $url

# Make the curl request and save both response and HTTP code
# Create a temporary file for the response body
response_file=$(mktemp)

# Get both the HTTP status code and response body
http_code=$(curl -X POST $url \
     -H "Authorization: bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjM2MjgyNTg2MDExMTNlNjU3NmE0NTMzNzM2NWZlOGI4OTczZDE2NzEiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiIzMjU1NTk0MDU1OS5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF6cCI6InRlcnJhZm9ybS13b3Jrc2hvcC1zYUBtbS1zcGxhLXRzZS1pbnRlcm5hbC1odWIuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJlbWFpbCI6InRlcnJhZm9ybS13b3Jrc2hvcC1zYUBtbS1zcGxhLXRzZS1pbnRlcm5hbC1odWIuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiZXhwIjoxNzMzMjM1MDQ5LCJpYXQiOjE3MzMyMzE0NDksImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsInN1YiI6IjEwODg2MDgyODU3Mzg5MTMyMTA5MyJ9.BEO2OHv_aMp9grO9JhSwEFlk24Q3EWbWvZK5PbTfMlkVk7W-jtpZwtuFO5YSgeJfG8E3yY5r_Qnd_DAuzcvMhnt5wvhmxrcFXDXRRIMeCvVZ5WGeG_w1C1CWKGhc8cAh23HpQ4maJuyXnzRzshPYo3V93KPfZmHw5i0FYIDCwIV7-fEz3-_Maxnq1bQLzMhy_AaDEDugKjeAa_grE5ACTbbpoHR5JK8dHb0S7GIwFnptUHuhF4hdxO-tjfXf616nMZWVjEYQeshDNIPSHLZbAQi1czfw9htyBDteZDqnvrzbw16ITt7y6OvF9YEmmNjslVRy3WK-UWptPGSm8AzaMg" \
     -H "Content-Type: application/json" \
     -d '{"country": "United States"}' \
     -w "%{http_code}" \
     -s \
     -o "$response_file" \
    )

# Read the response body
response=$(<"$response_file")

# Clean up the temporary file
rm "$response_file"

# Check the HTTP status code and handle accordingly ✨
case $http_code in
    200)
        echo "✅ Success! (HTTP 200)"
        echo "Response data: $response"
        ;;
    400)
        echo "❌ Bad Request (HTTP 400)"
        echo "Error details: $response"
        ;;
    500)
        echo "⚠️ Server Error (HTTP 500)"
        echo "Error details: $response"
        ;;
    *)
        echo "❓ Unexpected Status Code: $http_code"
        echo "Response: $response"
        ;;
esac


echo