// test
const { BigQuery } = require("@google-cloud/bigquery")
const { airportsByCountry } = require("./queries")

const queryTable = async (query) => {
    try {
        /* const bqOptions = {
            keyFilename: "path/to/service_account.json",
            projectId: "my_project",
        }
        const bigquery = new BigQuery(bqOptions) */
        const bigquery = new BigQuery()

        const options = {
            query: query,
            location: "US",
        }

        const [job] = await bigquery.createQueryJob(options)
        console.log(`Job ${job.id} started.`)
        const [rows] = await job.getQueryResults()

        console.log(`Job ${job.id} finished.`)
        return rows
    } catch (err) {
        console.log(err)
    }
}

const parseAirports = (rows) => {
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
        return `${operationalStatus}|${airportUse}|${airportMilCode}|${airport.faa_identifier}-${airport.name}`
    })
    return parsedAirports
}

const main = async (req, res) => {
    try {
        const { body } = req
        console.log(`Requested information for country: ${body.country}`)
        const airportQuery = airportsByCountry(body.country, 10)
        const airports = await queryTable(airportQuery)

        // Parse response
        const parsedAirports = parseAirports(airports)

        // Send an HTTP response
        res.status(200).send(parsedAirports)
    } catch (err) {
        if (res.status !== 500) {
            res.status(400).send(`Bad Request: ${err.message}`)
        }
        res.status(500).send(`Server Error: ${err.message}`)
    }
}

module.exports = { main }
