%dw 2.0
import * from dw::core::Strings

/* Function that converts field values to string but keep null as is
* params: 
* 	 value
* 		type: string
*       description: field value that should be converted into string
* returns the converted value to string / null
*/
fun convertToString(value) =
  if (value == null)
    value
  else
    value as String
    
/* Function that converts the integer into string decimal based on needs
* params: 
* 	 amount
* 		type: integer / string
*       description: amount value to be converted
*	 decimal: 
* 		type: integer
* 		description: Decimal count of the amount
* returns the converted value with the decimal
*/ 
fun toDecimal(amount,decimal) = 
if ( !isEmpty(amount) ) amount as Number as String {
	format:"0." ++ repeat("0", decimal)
}
else amount