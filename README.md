# MultiSpline for Stata

Nonlinear multilevel spline modeling for Stata.

[![SSC](https://img.shields.io/badge/SSC-available-blue)](http://fmwww.bc.edu/repec/bocode/m/multispline.ado)
[![Version](https://img.shields.io/badge/version-1.0.4-blue.svg)](https://github.com/causalfragility-lab/MultiSpline-Stata)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![RePEC](https://img.shields.io/badge/RePEC-indexed-green)](https://ideas.repec.org/c/boc/bocode/s459620.html)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18853821.svg)](https://doi.org/10.5281/zenodo.18853821)


**Version:** 1.0.4 (SSC release)  
**License:** MIT  
**Indexed in:** RePEC

---

## Motivation

Nonlinear relationships are common in applied research, especially
in education, health, and economics. While Stata provides `mixed`
for multilevel models and `mkspline` for spline construction,
combining these tools requires multiple steps and manual
postestimation. `multispline` addresses this gap by providing
a unified workflow that integrates spline construction, multilevel
estimation, ICC computation, prediction, and visualization into a
single command, improving workflow efficiency and reproducibility.

---

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

---

## Syntax
```stata
multispline depvar indepvar [if] [in], cluster(varname) [options]
```

---

## Options

| Option | Description |
|--------|-------------|
| `cluster(varname)` | Grouping variable (required) |
| `nknots(#)` | Number of spline knots (default: 4) |
| `autoknots` | Auto select knots (4–7) using floor(sqrt(n)) |
| `at(numlist)` | Predict over 50-point grid spanning range |
| `plot` | Visualize nonlinear fit |

---

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

---

## Workflow

`multispline` automates five steps in a single command:

1. Knot placement at quantiles of predictor distribution
2. Natural cubic spline basis construction via `mkspline`
3. Multilevel model estimation via `mixed`
4. ICC computation via `estat icc`
5. Prediction and visualization via `predict` and `twoway`

---

## Requirements

- Stata version 14.1 or later
- Continuous predictor variable
- Sufficient between-cluster variability

---

## Limitations

- Predictor variable must be continuous
- Performance depends on sufficient between-cluster variability
- Not appropriate for discrete predictors or negligible
  random-effects variance

---

## Simulation Study

Replication code for the simulation comparison between
linear, quadratic, and MultiSpline models is available in:

simulation/multispline_simulation.do

The script generates clustered nonlinear data, estimates
linear, quadratic, and spline-based multilevel models,
and produces the comparison table and visualization used
in the manuscript.

---
## Related R Package

The R version of MultiSpline is available on CRAN:
```r
install.packages("MultiSpline")
```

GitHub: https://github.com/causalfragility-lab/MultiSpline

---

## Author

Subir Hait  
Michigan State University  
haitsubi@msu.edu  
RePEC: https://authors.repec.org/pro/pha1643  
GitHub: https://github.com/causalfragility-lab

---

## License

MIT © Subir Hait

---

## Citation

If you use `multispline` in your research, please cite:
```
Hait, Subir. 2026. "MULTISPLINE: Stata module to perform
nonlinear multilevel spline modeling." Statistical Software
Components S459620, Boston College Department of Economics.
https://ideas.repec.org/c/boc/bocode/s459620.html
```

### BibTeX (from RePEC):
```bibtex
@Misc{repec:boc:bocode:s459620,
  howpublished = {Statistical Software Components,
                  Boston College Department of Economics},
  author       = {Hait, Subir},
  title        = {MULTISPLINE: Stata module to perform nonlinear
                  multilevel spline modeling},
  year         = {2026},
  month        = {Mar},
  number       = {S459620},
  keywords     = {splines; panel data; Stata},
  url          = {https://ideas.repec.org/c/boc/bocode/s459620.html}
}
```
