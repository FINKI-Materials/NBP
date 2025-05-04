xquery version "3.0";

let $doc := doc("System.xml")
let $albums := $doc//Album
let $rents := $doc//Rent
let $cds := $doc//CD

let $mostRentedAlbum :=
  for $album in $albums
  let $albumID := $album/@id
  let $rentCount := count($rents[ALBUM_ID = $albumID])
  order by $rentCount descending
  return
    <Album>
      <ID>{$albumID}</ID>
      <GroupID>{$album/GROUP_ID/text()}</GroupID>
      <RentCount>{$rentCount}</RentCount>
    </Album>

let $topAlbum := $mostRentedAlbum[1]
let $topAlbumID := $topAlbum/ID

let $availableCD := $cds[ALBUM_ID = $topAlbumID and @occupied = "0"]

return
  if (exists($availableCD)) then
    let $groupID := $topAlbum/GroupID
    let $group := $doc//Group[@id = $groupID]
    return
      <MostRentedAlbumWithAvailableCD>
        <AlbumID>{$topAlbumID}</AlbumID>
        <Group>{$group}</Group>
        <AvailableCD>{$availableCD[1]}</AvailableCD>
      </MostRentedAlbumWithAvailableCD>
  else
    <Result>No such album found</Result>