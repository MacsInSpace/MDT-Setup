# Set Make and model variables via PS.
# Based on the DepoymentReseach/Bunny UserModelAliasExit.vbs
 
    $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    $make = $tsenv.Value('make')
    $model = $tsenv.Value('model')
    #$deployRoot = $tsenv.Value('deployRoot')
    #$SMSTSLOCALDATADRIVE = $tsenv.Value('SMSTSLOCALDATADRIVE')
    $makealias = ''
    $modelalias = ''

    switch -wildcard ($make) {
        Dell*           { $makealias=Dell }
        LENOVO          { $makealias=Lenovo }
        IBM             { $makealias=Lenovo }
        Hewlett-Packard { $makealias=HP }
        SAMSUNG*        { $makealias=Samsung }
        Microsoft*      { $makealias=Microsoft }
        VMware*         { $makealias=VMware }
    default         { $makealias=$make } # Just in case
    }


# Set Model aliases under each make

if ($makealias = Lenovo) {
    switch -wildcard ($model) {
        20L*            { $modelalias=20L }
        20S*            { $modelalias=20S }
        21F*            { $modelalias=21F }
        82v*            { $modelalias=82v }
    default          { $modelalias=$model } # Just in case
    
    }

} elseif ($makealias=Dell) {
   
    default          { $modelalias=$model } # Just in case

} elseif ($makealias=Acer) {

    default          { $modelalias=$model } # Just in case

} elseif ($makealias=HP) {
   
    default          { $modelalias=$model } # Just in case

} elseif ($makealias=Microsoft) {

    default          { $modelalias=$model } # Just in case

}

if ( $null = $makealias ) {
    $makealias=$make
}
if ( $null = $modelalias ) {
    $modelalias=$model
}



$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$tsenv.Value('makealias') = $makealias
$tsenv.Value('modelalias') = $modelalias
