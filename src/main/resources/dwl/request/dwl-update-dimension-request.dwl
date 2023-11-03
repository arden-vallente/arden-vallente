%dw 2.0
output application/json
var site = payload
---
{
	"dimensionCode": Mule::p('bc.dimension.code.default'),
	"name": site.siteName,
	"blocked": (if (lower(site.siteStatus) contains ('decommissioned')) true else false)
}