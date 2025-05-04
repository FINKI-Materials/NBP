xquery version "3.0";

declare function local:generate_monthly_report($month as xs:int, $year as xs:int) {
  let $doc := doc("System.xml")
  let $rents := $doc//Rent
  let $albums := $doc//Album
  let $artists := $doc//Artist
  
  let $filteredRents := $rents[substring-before(FROM_DATE, "/") = $year and substring-before(substring-after(FROM_DATE, "/"), "/") = $month]
  
  let $salesData := 
    for $album in $albums
    let $albumID := $album/@id
    let $salesForAlbum := $filteredRents[ALBUM_ID = $albumID]
    let $totalSales := count($salesForAlbum)
    let $totalProfit := sum($salesForAlbum/PRICE)
    let $artistID := $album/ARTIST_ID
    let $artist := $artists[@id = $artistID]
    return
      <ArtistMonthlyReport>
        <Artist>{$artist/NAME}</Artist>
        <Album>{$album/NAME}</Album>
        <TotalSales>{$totalSales}</TotalSales>
        <TotalProfit>{$totalProfit}</TotalProfit>
      </ArtistMonthlyReport>
  
  return 
    <MonthlyReport>
      <Month>{$month}</Month>
      <Year>{$year}</Year>
      {$salesData}
    </MonthlyReport>
};

let $month := 1
let $year := 2020

return local:generate_monthly_report($month, $year)