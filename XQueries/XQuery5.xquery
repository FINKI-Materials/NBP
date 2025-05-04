xquery version "3.0";

let $rents := doc("System.xml")//Rent
let $albums := doc("System.xml")//Album

for $album in $albums
let $albumID := $album/@id
let $rentCount := count($rents[ALBUM_ID = $albumID])
return
  <AlbumRentAverage>
    <AlbumID>{$albumID}</AlbumID>
    <AlbumName>{$album/NAME/text()}</AlbumName>
    <RentCount>{$rentCount}</RentCount>
  </AlbumRentAverage>