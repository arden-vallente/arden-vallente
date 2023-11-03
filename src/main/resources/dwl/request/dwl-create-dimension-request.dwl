%dw 2.0
output application/json
var site = vars.site.data
---
{
	"dimensionCode": Mule::p('bc.dimension.code.default'),
	"code": site[vars.counter].siteCode,
	"name": site[vars.counter].siteName,
	"blocked": (if (lower(site[vars.counter].siteStatus) contains ('decommissioned')) true else false)
}