const airportsByCountry = (country, limit) => {
    return `SELECT  
    airports.faa_identifier, airports.name, airports.oper_status, 
    airports.service_city, airports.airport_use, airports.country, 
    airports.mil_code
    FROM \`bigquery-public-data.faa.us_airports\` as airports
    ${country ? `WHERE airports.country = '${country}'` : ""}
    LIMIT ${limit}`
}

module.exports = { airportsByCountry }
