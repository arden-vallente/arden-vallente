%dw 2.0

output application/json
---
"Hi,<br><br>Below is the summary report for Site to Dimension Sync.<br><br>Transaction ID: $(correlationId)<br>Sync Date Start: $(vars.currentSyncDate) <br>Sync Date End: $(now() as String {format : "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"}) <br>Total Record Created: $(vars.resultSummary.successCreate) <br>Total Record Updated: $(vars.resultSummary.successUpdate) <br>Total Record Renamed: $(vars.resultSummary.successRename) <br>Failed Count: $(vars.resultSummary.failed) <br><br><br><i><small>sent via mule $(p('app.name'))</small></i>"