xquery version "1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

let $albums := doc("Albums.xml")//Album
let $artists := doc("Artists.xml")//Artist
let $cds := doc("CatalogCD.xml")//CD
let $clients := doc("Clients.xml")//Client
let $djs := doc("DJ.xml")//DJ
let $groups := doc("Groups.xml")//Group
let $rents := doc("Rent.xml")//Rent
let $singers := doc("Singers.xml")//Singer

return
<System>
  
  <!-- Секција за сите клиенти -->
  <Clients>
    {
      for $client in $clients
      let $clientRents := $rents[ClientID = $client/@ClientID]
      return
        <Client id="{$client/@ClientID}">
          {$client/*}
          <Rents>
            {
              for $rent in $clientRents
              let $singer := $singers[@SingerID = $rent/SingerID]
              return
                <Rent>
                  {$rent/*}
                  {
                    if (exists($singer)) then
                      <Singer id="{$singer/@SingerID}">{$singer/*}</Singer>
                    else ()
                  }
                </Rent>
            }
          </Rents>
        </Client>
    }
  </Clients>
  
  <!-- Секција за сите артисти -->
  <Artists>
    {
      for $artist in $artists
      let $artistAlbums := $albums[PerformerID = $artist/@ArtistID]
      let $artistCDs := $cds[PerformerID = $artist/@ArtistID]
      return
        <Artist id="{$artist/@ArtistID}">
          {$artist/*}
          <Albums>
            {
              for $album in $artistAlbums
              return <Album>{$album/*}</Album>
            }
          </Albums>
          <CDs>
            {
              for $cd in $artistCDs
              return <CD>{$cd/*}</CD>
            }
          </CDs>
        </Artist>
    }
  </Artists>

  <!-- Секција за сите пејачи -->
  <Singers>
    {
      for $singer in $singers
      let $singerAlbums := $albums[PerformerID = $singer/@SingerID]
      let $singerCDs := $cds[PerformerID = $singer/@SingerID]
      let $singerGroups := $groups[MemberID = $singer/@SingerID]
      let $singerRents := $rents[SingerID = $singer/@SingerID]
      return
        <Singer id="{$singer/@SingerID}">
          {$singer/*}
          <Albums>
            {
              for $album in $singerAlbums
              return <Album>{$album/*}</Album>
            }
          </Albums>
          <CDs>
            {
              for $cd in $singerCDs
              return <CD>{$cd/*}</CD>
            }
          </CDs>
          <Groups>
            {
              for $group in $singerGroups
              return <Group>{$group/*}</Group>
            }
          </Groups>
          <Rents>
            {
              for $rent in $singerRents
              let $client := $clients[ClientID = $rent/ClientID]
              return
                <Rent>
                  {$rent/*}
                  <Client>{$client/*}</Client>
                </Rent>
            }
          </Rents>
        </Singer>
    }
  </Singers>

  <!-- Секција за DJ-и -->
  <DJs>
    {
      for $dj in $djs
      return <DJ id="{$dj/@DJID}">{$dj/*}</DJ>
    }
  </DJs>

</System>