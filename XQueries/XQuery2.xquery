xquery version "3.0";

let $clients := doc("System.xml")//Client
let $rents := doc("System.xml")//Rent

let $clientsWithRentCount :=
  for $client in $clients
  let $count := count($rents[CLIENT_ID = $client/@id])
  return
    <ClientRentCount>
      <Client>{$client/*}</Client>
      <RentCount>{$count}</RentCount>
    </ClientRentCount>

let $top3 :=
  for $entry in $clientsWithRentCount
  order by xs:integer($entry/RentCount) descending
  return $entry

return <Top3Clients>{subsequence($top3, 1, 3)}</Top3Clients>