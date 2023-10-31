%dw 2.0
import * from dwl::scripts::MaskUtil
import * from dwl::scripts::ErrorUtil
 
/* Log function for INFO loggers
 * params: 
 * 		logObj
 *			type: Object
 *          description: object containing the details to be logged
 * returns a json object with the log data
 */
fun logInfo(logObj) = logCommon(logObj)
 
/* Log function for DEBUG loggers. In addition to the common fields, 
 *             this function also returns the payload with several fields masked.
 * params: 
 * 		logObj
 *			type: Object
 *          description: object containing the details to be logged
 * returns a json object with the log data
 */
fun logDebug(logObj) = logCommon(logObj) ++ {"payload": logObj.payload}
 
/* Log function for ERROR loggers. In addition to the common fields, 
 *             this function also returns the error object containing error info.
 * params: 
 * 		logObj
 *			type: Object
 *          description: object containing the details to be logged
 * returns a json object with the log data
 */
fun logError(logObj) = logCommon(logObj) ++ {"error": getError(logObj.error)}
 
/* Log function for DEBUG loggers after the error log. In addition to the common fields, 
 *             this function also returns the payload and the error object.
 * params: 
 * 		logObj
 *			type: Object
 *          description: object containing the details to be logged
 * returns a json object with the log data
 */
fun logDebugError(logObj) = logCommon(logObj) ++ {"payload": logObj.payload, "detailedError": logObj.error.description}
 
/* Common log function which returns the populated fields for the common data present in all log types
 * params: 
 * 		logObj
 *			type: Object
 *          description: object containing the details to be logged
 * returns a json object with the log data
 */
fun logCommon(logObj) = { 
   "timestamp": now() as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSS"},
   "correlationId":logObj.correlationId,
   "applicationName":logObj.applicationName,
   "applicationVersion": logObj.applicationVersion,
   "environment": logObj.environment,
   "flowName": logObj.flowName,
   ("category": logObj.category) if (!isEmpty(logObj.category)), 
   "tracePoint": logObj.tracePoint,
   "message": logObj.message,
   ("statusCode": logObj.statusCode) if ('END' ~= logObj.tracePoint and !isEmpty(logObj.statusCode)),
   ("statusMessage": logObj.statusMessage) if ('END' ~= logObj.tracePoint and !isEmpty(logObj.statusMessage))
} 
