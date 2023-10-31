%dw 2.0
import * from dw::core::Strings

var maskFlag = (Mule::p('mask.flag') default "false") as Boolean
var maskFieldsLeft = upper(Mule::p('mask.fields.left') default '') splitBy (",")
var maskFieldsRight = upper(Mule::p('mask.fields.right') default '') splitBy (",")
var maskFieldsAll = upper(Mule::p('mask.fields.all') default '') splitBy (",")
var maskFields = maskFieldsLeft ++ maskFieldsRight ++ maskFieldsAll

var maskCountLeft = (Mule::p('mask.count.left') default "0") as Number
var maskCountRight =(Mule::p('mask.count.right') default "0") as Number
var maskingDefault = Mule::p('mask.masking.characters.default') default "*****"

/* Main masking function which conceals fields depending on the configuration set in the properties file
* params: 
* 	 data
* 		type: Any
*       description: data whose fields/info will be masked
* returns the same data with masked values
*/
fun maskData (data) =
	if (data != null and maskFlag)
		if (typeOf(data) ~= Object or typeOf(data) ~= "Object")
			(data mapObject (value, key) -> {(
            	if ((maskFields contains (upper((key) as String))) and (typeOf(value) ~= "String" or typeOf(value) ~= "Number"))
                	if (sizeOf(value) > ((Mule::p('mask.limit.upper') default "0") as Number)) ((key) : Mule::p('mask.masking.characters.upper.limit') default maskingDefault)
                    else if ((maskFieldsLeft contains (upper((key) as String))) and maskCountLeft < sizeOf(value)) ((key) : (maskLeft(value)))
                    else if ((maskFieldsRight contains (upper((key) as String))) and maskCountRight < sizeOf(value)) ((key) : (maskRight(value)))
                    else ((key) : value replace /./ with "*")
                else ((key) : maskData(value))
          	)})
		else if (typeOf(data) ~= "Array") (data map maskData($))
        else if (typeOf(data) ~= "String") maskLogDetails(data)
        else  data
	else data

/* Default masking function to mask a field with a specified count of unmasked characters at the start of the field
* params: 
*	maskString
*		type: String
*       description: data whose fields/info will be masked
* returns the masked string
*/
//fun maskRight(maskString) = ((maskString[0 to unmaskedLeftCharCount - 1] default '') 
//	++ (maskString[unmaskedLeftCharCount to (sizeOf(maskString) - 1)] replace /./ with "*" default ''))
fun maskRight(maskString) = ((maskString[0 to (((sizeOf(maskString) - maskCountRight) - 1))] default '') 
	++ (maskString[(sizeOf(maskString) - maskCountRight) to (sizeOf(maskString) - 1)] replace /./ with "*" default ''))

/* Default masking function to mask a field with a specified count of unmasked characters at the end of the field
* params: 
*	maskString
*		type: String
*       description: data whose fields/info will be masked
* returns the masked string
*/                            
//fun maskLeft(maskString) = ((maskString[0 to (sizeOf(maskString) - unmaskedRightCharCount - 1)]) replace /./ with "*" default '') 
//	++ ((maskString[(sizeOf(maskString) - unmaskedRightCharCount) to (sizeOf(maskString) - 1)]) default '')
fun maskLeft(maskString) = ((maskString[0 to maskCountLeft-1]) replace /./ with "*" default '') 
	++ ((maskString[maskCountLeft to (sizeOf(maskString) - 1)]) default '')

/* Masking function to mask URLs and IP addresses in a string using RegEx
* params: 
*	maskString
*		type: String
*       description: data whose fields/info will be masked
* returns the masked string
*/
fun maskLogDetails(maskString) = (
	if (maskFlag)
		(maskString replace (Mule::p('regex.ip.address') as Regex) with maskingDefault)
			replace (Mule::p('regex.url') as Regex) with maskingDefault
	else maskString
) 

//This function was used only to convert the string to array for specific index masking
fun arraytoMask(maskString) =
  maskString splitBy ("")

/* Masking function to mask specific values on the string
 * Params: 
 * 		maskString:
 * 			Type: String
 * 			Description: Data to be masked
 * 		maskStart:
 * 			Type: Integer/Number
 * 			Description: Starting character to be masked
 * 		maskEnd:
 * 			Type: Integer/Number
 * 			Description: End character to be masked
 * 		maskChar:
 * 			Type: String/Char
 * 			Description: Character to used for masking
 */
 
fun maskSpecific(maskString, maskStart, maskEnd , maskChar) =
  (arraytoMask(maskString) map ((value, index) -> if (index <= maskStart - 2)
      value
    else if (index >= maskEnd)
      value
    else
      maskChar)) reduce ($$ ++ $)
