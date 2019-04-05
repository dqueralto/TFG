<?php
    
    // change amount according to your needs
    $amount =10;
    // change From Currency according to your needs
    $from_Curr =“INR”;
    // change To Currency according to your needs
    $to_Curr =“USD”;
    $converted_currency=currencyConverter($from_Curr, $to_Curr, $amount);
    // Print outout
    echo $converted_currency;
    ?>
