%dw 2.0

/* Constructs the error based on the error identifier
 * params: 
 * 		error: (Object) error object
 * returns the json object containing the error data to be logged
 */
fun getError(error) = 
	if (error != null)
		if (!isEmpty(error.errorType) and !isEmpty(Mule::p('errors.' ++ lower(error.errorType.identifier) ++ '.code')))
            buildErrMsg(Mule::p('errors.' ++ lower(error.errorType.identifier) ++ '.severity'), Mule::p('errors.' ++ lower(error.errorType.identifier) ++ '.code'), Mule::p('errors.' ++ lower(error.errorType.identifier) ++ '.description'), error)
       	else
            buildErrMsg(Mule::p('errors.default.severity'), Mule::p('errors.default.code'), Mule::p('errors.default.description'), error)
    else
        buildErrMsg(Mule::p('errors.default.severity'), Mule::p('errors.default.code'), Mule::p('errors.default.description'), error)
 
/* Creates the error message in json format
 * params: 
 *      severity: (String) error severity
 *      code: (String) error code
 *      description: (String) error description
 *      error: (Object) the Mule error object
 * returns a json object with the error data
 */
fun buildErrMsg(severity, code, description, error) = {
		"severity": severity,
        "code": code, 
        "message": description,
        "detailedDescription": if (!isEmpty(error) and !isEmpty(error.description)) error.description else description,
        "errorType":  "$(error.errorType.namespace default ''):$(error.errorType.identifier default '')"
}
