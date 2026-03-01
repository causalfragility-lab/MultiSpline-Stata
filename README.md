# MultiSpline for Stata

Nonlinear multilevel spline modeling for Stata.

[![Version](https://img.shields.io/badge/version-1.0.4-blue.svg)](https://github.com/causalfragility-lab/MultiSpline-Stata)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Overview

While Stata provides `mixed` for multilevel models and `mkspline` 
for spline construction, no existing Stata command provides a unified 
workflow for fitting, predicting, visualizing, and computing ICCs 
from nonlinear multilevel models. `multispline` fills this gap.

## Installation

### From GitHub:
```stata
net install multispline, ///
    from("https://raw.githubusercontent.com/causalfragility-lab/MultiSpline-Stata/main/ado/")
```

### Manual:
Download `multispline.ado` and place in your personal ado folder:
```stata
adopath
```

## Syntax
```stata
multispline depvar indepvar [if] [in], cluster(varname) [options]
```

## Options

| Option | Description |
|--------|-------------|
| `cluster(varname)` | Grouping variable (required) |
| `nknots(#)` | Number of spline knots (default: 4) |
| `autoknots` | Auto select knots |
| `at(numlist)` | Predict over specified range |
| `plot` | Visualize nonlinear fit |

## Examples
```stata
* Education example
multispline math_score ses, cluster(schid) nknots(4) plot

* Health science example
multispline bloodpressure dosage, cluster(hospital) nknots(4) plot

* Auto knot selection
multispline math_score ses, cluster(schid) autoknots plot

* Grid predictions
multispline math_score ses, cluster(schid) nknots(4) at(-3 -2 -1 0 1 2 3) plot

* Real Stata data
sysuse nlsw88, clear
multispline wage age, cluster(industry) nknots(4) plot
```

## Related R Package

The R version of MultiSpline is available on CRAN:
```r
install.packages("MultiSpline")
```
GitHub: https://github.com/causalfragility-lab/MultiSpline

## Author

Subir Hait, Michigan State University  
haitsubi@msu.edu

## License

MIT © Subir Hait

## Citation
```
Hait, S. (2026). MultiSpline for Stata: Nonlinear multilevel 
spline modeling. https://github.com/causalfragility-lab/MultiSpline-Stata
```
