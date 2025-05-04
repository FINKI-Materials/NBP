xquery version "3.0";

let $artists := doc("System.xml")//Artist

return
<Artists>
  {
    for $artist in $artists
    return
      <Artist id="{$artist/@id}">
        {$artist/*[not(self::Albums)]}
        <Albums>
          {
            for $album in $artist/Albums/Album
            return
              <Album>
                <NAME>{data($album/NAME)}</NAME>
                <RELEASE_YEAR>{data($album/RELEASE_YEAR)}</RELEASE_YEAR>
              </Album>
          }
        </Albums>
      </Artist>
  }
</Artists>