xquery version "3.0";

let $doc := doc("System.xml")
let $rents := $doc//Rent
let $albums := $doc//Album
let $artists := $doc//Artist
let $clients := $doc//Client

let $artistClientCount :=
  for $album in $albums
  let $artistID := $album/ARTIST_ID
  let $clientsForArtist := distinct-values($rents[ALBUM_ID = $album/@id]/CLIENT_ID)
  return
    <ArtistClientCount>
      <ArtistID>{$artistID}</ArtistID>
      <ClientCount>{count($clientsForArtist)}</ClientCount>
    </ArtistClientCount>

let $maxClientCount := max($artistClientCount/ClientCount)
let $mostPopularArtist := $artistClientCount[ClientCount = $maxClientCount]

let $artistID := $mostPopularArtist/ArtistID
let $artist := $artists[@id = $artistID]

return
  <MostPopularArtist>
    <Artist>{$artist/node()}</Artist>
    <ClientCount>{$maxClientCount}</ClientCount>
  </MostPopularArtist>