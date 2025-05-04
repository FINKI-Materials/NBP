xquery version "3.0";

let $doc := doc("System.xml")
let $albums := $doc//Album
let $rents := $doc//Rent

for $album in $albums
let $albumID := $album/@id
let $albumName := $album/NAME
let $albumPrice := xs:decimal($album/PRICE)
let $albumRentCount := count($rents[ALBUM_ID = $albumID])
let $totalProfit := $albumRentCount * $albumPrice
return
  <AlbumProfit>
    <AlbumID>{$albumID}</AlbumID>
    <AlbumName>{$albumName}</AlbumName>
    <RentCount>{$albumRentCount}</RentCount>
    <PricePerRent>{$albumPrice}</PricePerRent>
    <TotalProfit>{$totalProfit}</TotalProfit>
  </AlbumProfit>