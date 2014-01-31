.pragma library

function printDuration(advance)
{
    var hours = Math.floor(advance / 3600);
    var minutes = Math.floor((advance % 3600) / 60);
    var secondes = Math.floor((advance % 3600) % 60);
    var retString = "";

    console.log("h " + hours + " m " + minutes + " s " + secondes);

    if (hours > 0)
    {
        if (hours < 10)
            retString += "0";
        retString += hours + ":"
    }
    if (minutes < 10)
        retString += "0";
    retString += minutes + ":";
    if (secondes < 10)
        retString += "0";
    retString += secondes;
    return retString;
}
