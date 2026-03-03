# MultiSpline for Stata

Nonlinear multilevel spline modeling for Stata.

[![SSC](https://img.shields.io/badge/SSC-multispline-blue)](http://fmwww.bc.edu/repec/bocode/m/multispline.ado)
[![Version](https://img.shields.io/badge/version-1.0.4-blue.svg)](https://github.com/causalfragility-lab/MultiSpline-Stata)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![RePEC](https://img.shields.io/badge/RePEC-pha1643-green)](https://authors.repec.org/pro/pha1643)

## Overview

While Stata provides `mixed` for multilevel models and `mkspline`
for spline construction, no existing Stata command provides a unified
workflow for fitting, predicting, visualizing, and computing ICCs
from nonlinear multilevel models. `multispline` fills this gap.

## Installation

### From SSC (Recommended):
```stata
ssc install multispline, replace
```

### From GitHub:
```stata
net install multispline, ///
    from("https://raw.githubusercontent.com/causalfragility-lab/MultiSpline-Stata/main/")
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
| `autoknots` | Auto select knots (4-7) using floor(sqrt(n)) |
| `at(numlist)` | Predict over 50-point grid spanning range |
| `plot` | Visualize nonlinear fit |

## Examples
```stata
* Education — SES and math achievement
multispline math_score ses, cluster(schid) nknots(4) plot

* Health science — dosage and response
multispline bloodpressure dosage, cluster(hospital) nknots(4) plot

* Automatic knot selection
multispline math_score ses, cluster(schid) autoknots plot

* Grid predictions
multispline math_score ses, cluster(schid) nknots(4) ///
    at(-3 -2 -1 0 1 2 3) plot

* Labor economics — age and wage (NLSW88)
sysuse nlsw88, clear
multispline wage age, cluster(industry) nknots(4) plot
```

## Workflow

`multispline` automates five steps in a single command:

1. Knot placement at quantiles of predictor distribution
2. Natural cubic spline basis construction via `mkspline`
3. Multilevel model estimation via `mixed`
4. ICC computation via `estat icc`
5. Prediction and visualization via `predict` and `twoway`

## Requirements

- Stata version 14.1 or later
- Continuous predictor variable
- Sufficient between-cluster variability

## Related R Package

The R version of MultiSpline is available on CRAN:
```r
install.packages("MultiSpline")
```

GitHub: https://github.com/causalfragility-lab/MultiSpline

## Author

Subir Hait  
Michigan State University  
haitsubi@msu.edu  
RePEC: https://authors.repec.org/pro/pha1643  
GitHub: https://github.com/causalfragility-lab  

## License

MIT © Subir Hait

## Citation

If you use `multispline` in your research, please cite:
```
Hait, S. (2026). MULTISPLINE: Stata module to perform nonlinear 
multilevel spline modeling. Statistical Software Components, 
Boston College Department of Economics.
https://EconPapers.repec.org/RePEc:boc:bocode:s459620
```

### BibTeX:
```bibtex
@software{hait2026multispline,
  author = {Hait, Subir},
  title  = {MULTISPLINE: Stata module for nonlinear
            multilevel spline modeling},
  year   = {2026},
  url    = {https://EconPapers.repec.org/RePEc:boc:bocode:s459620}
}
```
