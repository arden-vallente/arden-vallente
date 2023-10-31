%dw 2.0
import * from dwl::scripts::LogUtil
output application/json

var logStatusCode = {
	"error": if(!isEmpty(payload) and typeOf(payload) == Object and !isEmpty(payload.error)) payload.error else error
}

---
{
    "errors": {
        "errorCode": logError(logStatusCode).error.code,
        "errorMessage": if(!isEmpty(payload) and typeOf(payload) == Object and !isEmpty(payload.error)) payload.error.description else error.description default error.description
    }
}