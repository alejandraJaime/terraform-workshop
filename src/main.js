const functions = require("@google-cloud/functions-framework")
const { BigQuery } = require("@google-cloud/bigquery")
const { airportsByCountry } = require("./queries")

functions.http("myHttpFunction", async (req, res) => {
    async function queryTable(query) {
        const options = {
            query: query,
            location: "US",
        }

        const [job] = await bigquery.createQueryJob(options)
        console.log(`Job ${job.id} started.`)
        const [rows] = await job.getQueryResults()

        console.log(`Job ${job.id} finished.`)
        return rows
    }

    function parseAirports(rows) {
        const operationalStatusMap = new Map([
            ["Operational", "OP"],
            ["Closed", "CL"],
            ["Indefinite", "IN"],
        ])
        const airportUseMap = new Map([
            ["Public", "PB"],
            ["Private", "PR"],
        ])
        const airportMilCodeMap = new Map([
            ["CIVIL", "CIV"],
            ["OTHER", "OT"],
        ])
        const parsedAirports = rows.map((airport) => {
            let operationalStatus = operationalStatusMap.get(airport.oper_status)
            operationalStatus = operationalStatus ? operationalStatus : airport.oper_status
            let airportUse = airportUseMap.get(airport.airport_use)
            airportUse = airportUse ? airportUse : airport.airport_use
            let airportMilCode = airportMilCodeMap.get(airport.mil_code)
            airportMilCode = airportMilCode ? airportMilCode : airport.mil_code
            return `${operationalStatusMap}|${airportUse}|${airportMilCode}|${airport.faa_identifier}-${airport.name}-${airport.service_city}`
        })
        return parsedAirports
    }

    try {
        const { body } = req
        const options = {
            keyFilename: "path/to/service_account.json",
            projectId: "my_project",
        }
        const bigquery = new BigQuery(options)

        const airportQuery = airportsByCountry(body.country)
        const airports = await queryTable(airportQuery)

        // Parse response
        const parsedAirports = parseAirports(airports)

        // Send an HTTP response
        res.status(200).send(parsedAirports)
    } catch (err) {
        res.status(500).send("Bad Request")
    }
})
