# MultiSpline - Stata Version 0.2.0

**Spline-Based Nonlinear Modeling for Multilevel and Longitudinal Data**

> Author: Subir Hait - Michigan State University - haitsubi@msu.edu
> ORCID: 0009-0004-9871-9677

---

## Overview

MultiSpline for Stata provides a complete nonlinear multilevel modeling
workflow built on Stata's native `mixed` and `mkspline` commands. All
functionality is contained in a single `.ado` file with no external
dependencies.

| Step | Command |
|------|---------|
| Fit + auto knot selection | `multispline y x, df(auto)` |
| Inline plot (no file save) | add `plot(trajectory\|slope\|combo)` |
| R-squared decomposition | add `r2` |
| ICC | add `icc` |
| Model comparison | add `compare` |
| Derivatives + turning points | add `derivatives turning_points` |

---

## Installation

Copy `multispline.ado`, `multispline_plot.ado`, and `multispline.sthlp`
to your personal ado directory.

Find your personal ado path in Stata:
```stata
sysdir
```

Typical path on Windows: `c:\ado\personal\`

Then verify:
```stata
discard
which multispline
help multispline
```

---

## Quick start

```stata
* Single-level OLS
sysuse auto, clear
multispline price mpg, df(auto) derivatives turning_points plot(combo)

* With controls and model comparison
multispline price mpg weight, df(auto) compare r2 plot(trajectory)

* Nested multilevel (higher-level cluster first)
multispline score age female ses,        ///
    cluster(school_id student_id) nested ///
    df(auto) r2 icc compare              ///
    derivatives turning_points plot(combo)

* Cross-classified multilevel
multispline score age female,               ///
    cluster(school_id neighbourhood_id)     ///
    df(4) r2 icc plot(trajectory)
```

---

## Key options

### Clustering
- `cluster(varlist)` - up to 2 variables; **higher level first** for nested
- `nested` - generates `mixed y x || higher: || lower:` instead of cross-classified

### Spline specification
- `df(# | auto)` - degrees of freedom; `auto` selects by AIC or BIC
- `df_range(string)` - candidate df values, e.g. `"2 3 4 5 6"` (default)
- `criterion(aic|bic)` - information criterion (default `aic`)
- `method(ns|bs)` - natural cubic spline (default) or B-spline

### Inline plots (no file saving required)
- `plot(trajectory)` - estimated curve with 95% CI ribbon
- `plot(slope)` - first derivative (marginal effect) with CI
- `plot(curvature)` - second derivative
- `plot(combo)` - trajectory and slope side by side

### Diagnostics
- `r2` - Nakagawa-Schielzeth marginal R2m and conditional R2c
- `icc` - intraclass correlation coefficients
- `compare` - AIC/BIC/LRT: linear vs polynomial vs spline

### Post-estimation
- `derivatives` - first and second derivatives with CI bands
- `turning_points` - local maxima, minima, inflection regions
- `saving(filename)` - save prediction data for `multispline_plot`

---

## Separate plot command (when file saves are allowed)

```stata
multispline score age, df(auto) derivatives saving(pred)

multispline_plot, using(pred) type(trajectory) xvar(age)
multispline_plot, using(pred) type(slope)      xvar(age)
multispline_plot, using(pred) type(curvature)  xvar(age)
multispline_plot, using(pred) type(combo)      xvar(age)
```

---

## Nested cluster order

Always supply the **higher-level** grouping first:

```stata
* Correct: schools contain students
cluster(school_id student_id) nested
* Generates: mixed y x || school_id: || student_id:

* Wrong order:
* cluster(student_id school_id) nested
```

---

## Requirements

- Stata 14.0 or later
- `mixed` and `mkspline` (included in all Stata editions)

---

## Files

| File | Purpose |
|------|---------|
| `multispline.ado` | Main command (26 KB, fully self-contained) |
| `multispline_plot.ado` | Plots from saved prediction datasets |
| `multispline.sthlp` | Stata help file (`help multispline`) |
| `multispline_example.do` | Complete worked example |
| `multispline.pkg` | SSC package descriptor |
| `stata.toc` | SSC table of contents |

---

## Citation

Hait, S. (2026). *MultiSpline: Spline-Based Nonlinear Modeling for
Multilevel and Longitudinal Data* (Stata version 0.2.0).
https://github.com/causalfragility-lab/MultiSpline-Stata

---

## Companion R package

The R version of MultiSpline is available on CRAN:
```r
install.packages("MultiSpline")
```

---

## References

- Nakagawa, S. and Schielzeth, H. (2013). Methods in Ecology and Evolution, 4(2), 133-142.
- Nakagawa, S., Johnson, P.C.D. and Schielzeth, H. (2017). Journal of the Royal Society Interface, 14(134).
- Rights, J.D. and Sterba, S.K. (2019). Psychological Methods, 24(3), 309-338.
