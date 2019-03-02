#!/usr/bin/awk -f

BEGIN {
    FS=",";
}
{
   a += $1;
   b[++i] = $1;
}
END {
    m = a/NR; # mean
    for (i in b)
    {
        d += (b[i]-m)^2;
        e += (b[i]-m)^3;
        f += (b[i]-m)^4;
    }
    va = d/NR; # variance
    sd = sqrt(va); # standard deviation
    sk = (e/NR)/sd^3; # skewness
    ku = (f/NR)/sd^4-3; # standardized kurtosis
    print "N, sum, mean, variance, std, SEM, skewness, kurtosis"
    print NR ", " a ", " m ", " va ", " sd ", " sd/sqrt(NR) ", " sk ", " ku
}
