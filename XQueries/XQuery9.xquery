xquery version "3.0";

let $doc := doc("System.xml")
let $rents := $doc//Rent
let $clients := $doc//Client
let $albums := $doc//Album
let $artists := $doc//Artist

for $client in $clients
let $clientID := $client/@id
let $clientRents := $rents[CLIENT_ID = $clientID]
let $albumIDs := distinct-values($clientRents/ALBUM_ID)

let $artistRentCount :=
  for $albumID in $albumIDs
  let $album := $albums[@id = $albumID]
  let $artistID := $album/ARTIST_ID
  let $count := count($clientRents[ALBUM_ID = $albumID])
  return
    <ArtistCount>
      <ArtistID>{$artistID}</ArtistID>
      <Count>{$count}</Count>
    </ArtistCount>

let $maxArtist := $artistRentCount[not($Count < $Count/following-sibling::ArtistCount/Count)]
let $artistID := $maxArtist/ArtistID
let $artist := $artists[@id = $artistID]

return
  <FavoriteArtist>
    <ClientID>{$clientID}</ClientID>
    <Artist>{$artist/node()}</Artist>
  </FavoriteArtist>