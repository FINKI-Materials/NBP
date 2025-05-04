xquery version "3.0";

let $doc := doc("System.xml")
let $rents := $doc//Rent
let $clients := $doc//Client

let $shortRentClientIDs :=
  for $rent in $rents
  let $start := xs:date($rent/START_DATE)
  let $end := xs:date($rent/END_DATE)
  let $duration := days-from-duration($end - $start)
  where $duration lt 10
  return $rent/CLIENT_ID

let $uniqueClientIDs := distinct-values($shortRentClientIDs)

for $clientID in $uniqueClientIDs
let $client := $clients[@id = $clientID]
return
  <Client>{$client/node()}</Client>