xquery version "3.0";

let $rents := doc("System.xml")//Rent
let $albums := doc("System.xml")//Album

(: Филтрирај ги сите Rent кои се во периодот од 2020-01-01 до 2020-03-31 :)
let $rentsInPeriod :=
  for $r in $rents
  let $start := xs:date($r/START_DATE)
  where $start ge xs:date("2020-01-01") and $start le xs:date("2020-03-31")
  return $r

(: Изброј ги изнајмувањата по ALBUM_ID :)
let $albumCounts :=
  for $album in distinct-values($rentsInPeriod/ALBUM_ID)
  let $count := count($rentsInPeriod[ALBUM_ID = $album])
  where $count ge 3
  return
    <AlbumRentCount>
      <Album>{ $albums[@id = $album] }</Album>
      <RentCount>{ $count }</RentCount>
    </AlbumRentCount>

return <PopularAlbumsJanToMar2020>{ $albumCounts }</PopularAlbumsJanToMar2020>