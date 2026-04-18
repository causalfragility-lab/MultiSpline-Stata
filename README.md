# multispline

**Nonlinear Multilevel Spline Modeling in Stata**

**Author:** Subir Hait, Michigan State University
**Version:** 0.2.0 · **Released:** April 2026 · **Stata:** 14 or later

---

## Overview

`multispline` fits nonlinear relationships using spline functions in single-level and multilevel (mixed-effects) models. It provides a unified workflow for estimation, interpretation, visualization, and diagnostics — all within a single command.

**Key features:**

- Automatic selection of spline degrees of freedom
- Mixed-effects models for Gaussian and binary outcomes
- Marginal and conditional R-squared for multilevel models
- Intraclass correlation coefficients (ICC)
- Derivative-based interpretation (first and second derivatives)
- Identification of local maxima and minima (turning points)
- Model comparison across linear, polynomial, and spline specifications
- Publication-ready plots of fitted curves and marginal effects

The companion command `multispline_plot` produces trajectory, slope, curvature, and combination plots from saved prediction datasets.

---

## Installation

### From SSC (recommended)

```stata
ssc install multispline
```

This installs all files into your `PLUS` directory and enables `ado update`.

### Manual installation

Copy `multispline.ado`, `multispline_plot.ado`, and `multispline.sthlp` into your `PLUS` directory. To locate it:

```stata
sysdir
```

Confirm the directory is on your adopath:

```stata
adopath
```

Then verify installation:

```stata
discard
which multispline
help multispline
```

> **Note:** Always install into `PLUS`. Do not use `PERSONAL` (may interfere with `ado update`) or `BASE` (reserved for Stata system files).

---

## Syntax

```stata
multispline depvar splinevar [indepvars] [, options]
```

For multilevel models, `cluster()` is required.

---

## Options

| Option | Description |
|---|---|
| `df(# \| auto)` | Degrees of freedom for the spline. Specify an integer or `auto` for automatic selection. |
| `cluster(varlist)` | Clustering variable(s). One variable for a two-level model; two variables (higher level first) for a three-level nested model. |
| `nested` | Declare a nested clustering structure when two `cluster()` variables are supplied. |
| `family(logit \| probit)` | Fit a generalized mixed-effects model for binary outcomes. Requires `cluster()`. |
| `r2` | Report marginal and conditional R-squared. |
| `icc` | Report intraclass correlation coefficients. |
| `compare` | Compare linear, polynomial, and spline model fits. |
| `derivatives` | Compute and display first and second derivatives of the fitted curve. |
| `turning_points` | Identify local maxima and minima of the fitted curve. |
| `plot(trajectory \| slope \| combo)` | Display fitted curves and/or marginal effects inline. |
| `saving(filename)` | Save prediction dataset for subsequent use with `multispline_plot`. |

---

## Examples

### Single-level models

Fit a spline with automatic df selection:

```stata
sysuse auto, clear
multispline price mpg, df(auto)
```

Add derivative and turning-point output:

```stata
multispline price mpg, df(auto) derivatives turning_points
```

Include control variables and compare model fits:

```stata
multispline price mpg weight, df(auto) compare r2
```

### Multilevel models

Random-intercept model (two-level):

```stata
multispline score age, cluster(student_id)
```

Three-level nested model:

```stata
multispline score age, cluster(school_id student_id) nested df(auto)
```

Binary outcome with logit link:

```stata
multispline pass age, cluster(student_id) family(logit)
```

### Saving results and plotting

Save predictions for subsequent plotting:

```stata
multispline score age, df(auto) derivatives saving(pred)
```

Produce plots from saved results:

```stata
multispline_plot, using(pred) type(trajectory) xvar(age)
multispline_plot, using(pred) type(slope)      xvar(age)
multispline_plot, using(pred) type(curvature)  xvar(age)
multispline_plot, using(pred) type(combo)      xvar(age)
```

---

## Requirements

- Stata 14 or later
- Built-in Stata commands: `mixed`, `melogit`, `mkspline`

No user-written dependencies are required.

---

## Package files

| File | Description |
|---|---|
| `multispline.ado` | Main estimation command |
| `multispline_plot.ado` | Plotting utility for saved results |
| `multispline.sthlp` | Stata help file |
| `multispline.pkg` | SSC package descriptor |
| `stata.toc` | SSC table of contents entry |
| `readme.txt` | Plain-text readme (SSC submission) |

---

## Citation

If you use `multispline` in published work, please cite:

> Hait, S. (2026). *multispline*: Nonlinear multilevel spline modeling in Stata. Statistical Software Components, Boston College Department of Economics.

---

## Related software

An R implementation is available on CRAN:
[https://cran.r-project.org/package=MultiSpline](https://cran.r-project.org/package=MultiSpline)

---

## Changelog

**v0.2.0** (April 2026) — Initial SSC release
