%dw 2.0
output application/json
---
{
    "errors": {
        "errorCode": Mule::p('errors.retry_exhausted.code'),
        "errorMessage": if(!isEmpty(payload) and typeOf(payload) == Object and !isEmpty(payload.error)) payload.error.description else error.description
    }
}