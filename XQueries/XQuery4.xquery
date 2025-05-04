xquery version "3.0";

let $rents := doc("System.xml")//Rent
let $albums := doc("System.xml")//Album
let $clients := doc("System.xml")//Client

(: 1. Најди го ALBUM_ID со најмногу изнајмувања :)
let $albumRentCounts :=
  for $album in distinct-values($rents/ALBUM_ID)
  let $count := count($rents[ALBUM_ID = $album])
  order by $count descending
  return <AlbumCount><AlbumID>{$album}</AlbumID><Count>{$count}</Count></AlbumCount>

let $mostRentedAlbumID := $albumRentCounts[1]/AlbumID/text()
let $mostRentedAlbum := $albums[@id = $mostRentedAlbumID]

(: 2. Филтрирај ги сите Rent редови за тој албум :)
let $rentsForAlbum := $rents[ALBUM_ID = $mostRentedAlbumID]

(: 3. Групирај по CLIENT_ID и изброј колку пати секој клиент го изнајмил албумот :)
let $clientCounts :=
  for $client in distinct-values($rentsForAlbum/CLIENT_ID)
  let $count := count($rentsForAlbum[CLIENT_ID = $client])
  order by $count descending
  return <ClientCount><ClientID>{$client}</ClientID><Count>{$count}</Count></ClientCount>

let $topClientID := $clientCounts[1]/ClientID/text()
let $topClient := $clients[@id = $topClientID]

return
  <TopClientForMostRentedAlbum>
    <Album>{ $mostRentedAlbum }</Album>
    <Client>{ $topClient }</Client>
  </TopClientForMostRentedAlbum>