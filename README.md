# MultiSpline 0.2.0

**Spline-Based Nonlinear Modeling for Multilevel and Longitudinal Data**

> Author: Subir Hait - Michigan State University - haitsubi@msu.edu

---

## Overview

MultiSpline provides a unified interface for fitting, interpreting, and
visualizing nonlinear relationships in single-level and multilevel regression
models using natural cubic splines, B-splines, or GAM smooths.

Version 0.2.0 incorporates key methodological suggestions and extends the
package into a unified estimation, interpretation, and diagnostic framework:

| Layer | Functions |
|-------|-----------|
| **Estimation** | `nl_fit()` , `nl_knots()` |
| **Prediction** | `nl_predict()` |
| **Interpretation** | `nl_derivatives()` , `nl_turning_points()` , `nl_plot()` |
| **Model selection** | `nl_compare()` |
| **Variance explained** | `nl_r2()` , `nl_icc()` |
| **Cluster heterogeneity** | `nl_het()` |

---

## What's New in 0.2.0

### 1. Cross-classified and Nested Multilevel Structures

Supply two cluster names and use `nested = TRUE` for nested random effects
or `nested = FALSE` (default) for cross-classified random effects.
**Important:** for nested models the first element of `cluster` is the
higher-level grouping and the second is the lower-level grouping.

```r
# Cross-classified: students appearing in multiple schools and districts
fit <- nl_fit(data = df, y = "score", x = "SES",
              cluster = c("school_id", "student_id"),
              nested  = FALSE)
# generates: (1 | school_id) + (1 | student_id)

# Nested: students within schools  (higher level first)
fit <- nl_fit(data = df, y = "score", x = "SES",
              cluster = c("school_id", "student_id"),
              nested  = TRUE)
# generates: (1 | school_id/student_id)
```

---

### 2. Confidence Intervals for Spline Curves

All model types now return proper CI bands:

| Model | CI method |
|-------|-----------|
| `lm` | Analytical (`predict.lm`) |
| `gam` | Analytical (`mgcv`) |
| `lmerMod` | Delta method via fixed-effects variance-covariance matrix |
| `glmerMod` | Delta method on link scale + back-transformation (default) or parametric bootstrap (`glmer_ci = "boot"`) |

```r
pred <- nl_predict(fit, se = TRUE, level = 0.95)
nl_plot(pred_df = pred, x = "age", show_ci = TRUE)
```

---

### 3. Automatic Knot / df Selection

```r
# Explore df explicitly
ks <- nl_knots(data = df, y = "score", x = "age",
               df_range = 2:10, criterion = "AIC")
ks$best_df

# Or let nl_fit select automatically
fit <- nl_fit(data = df, y = "score", x = "age",
              df = "auto", df_criterion = "AIC")
```

---

### 4. Multilevel R-squared Decomposition

```r
nl_r2(fit)
```

**Output (LMM example):**
```
=== MultiSpline R-squared Decomposition ===
Model type: LMM

  Marginal  R2m = 0.1823   (fixed effects only)
  Conditional R2c = 0.4761  (fixed + all random effects)

Variance Partition (r2_mlm-style):
     Component  Variance  Proportion
 Fixed effects    1.4221      0.1823
    school_id    0.8762      0.1124
   student_id    1.8340      0.2350
      Residual   3.6590      0.4690
```

Follows the Nakagawa-Schielzeth (2013) and Nakagawa-Johnson-Schielzeth
(2017) formulas for marginal and conditional R-squared. The level-specific
variance partition mirrors the `r2_mlm` / Rights-Sterba (2019) approach.

---

### 5. Derivative-Based Interpretation Framework

```r
pred  <- nl_predict(fit, x_seq = seq(8, 18, length.out = 200))
deriv <- nl_derivatives(pred, x = "age")

# Slope (first derivative) with CI band
nl_plot(deriv_df = deriv, x = "age", type = "slope")

# Curvature (second derivative)
# Note: second-derivative CI bands may be wide due to numerical
# differentiation and should be interpreted cautiously.
nl_plot(deriv_df = deriv, x = "age", type = "curvature")

# Trajectory + slope side by side
nl_plot(pred_df = pred, deriv_df = deriv, x = "age", type = "combo")
```

**Turning points and inflection regions:**

```r
tp <- nl_turning_points(deriv, x = "age")
tp$turning_points      # local maxima and minima
tp$inflection_regions  # where concavity changes
tp$slope_regions       # contiguous increasing / decreasing stretches

nl_plot(pred_df = pred, x = "age",
        show_turning_points = TRUE,
        turning_points      = tp$turning_points)
```

---

### 6. Model Comparison Workflow

```r
nl_compare(fit)                           # linear + poly(2) + poly(3) + spline
nl_compare(fit, polynomial_degrees = 2:5) # custom comparators
```

**Output:**
```
=== MultiSpline Model Comparison ===

    Model    AIC    BIC  LogLik  npar  Deviance  LRT_vs_linear  LRT_p
   Linear 1842.1 1863.4  -916.1     5    1020.4             NA     NA
  Poly(2) 1830.5 1855.6  -908.2     6     992.3          15.74  <0.001
  Poly(3) 1825.3 1854.3  -903.6     7     978.1          25.00  <0.001
   Spline 1818.7 1851.5  -898.3     9     961.2          35.68  <0.001

  Best model by AIC: Spline
```

---

### 7. Cluster Heterogeneity in Nonlinear Effects

```r
nl_het(fit, n_clusters_plot = 50)
```

Plots cluster-specific predicted trajectories (BLUPs) against the
population-mean curve, and performs an LRT comparing random-slope vs
random-intercept models.

---

### 8. B-spline Basis

```r
fit_bs <- nl_fit(data = df, y = "score", x = "age",
                 method = "bs", df = 6, bs_degree = 3)
```

---

### 9. Random Spline Slopes

```r
fit_rs <- nl_fit(data = df, y = "score", x = "age",
                 cluster = "id", random_slope = TRUE)
```

---

## Installation

```r
# From CRAN
install.packages("MultiSpline")

# From source
install.packages("MultiSpline_0.2.0.tar.gz", repos = NULL, type = "source")
```

---

## Quick-Start Example

```r
library(MultiSpline)

# 1. Select df automatically
ks <- nl_knots(data = nlme::Orthodont, y = "distance",
               x = "age", df_range = 2:8)

# 2. Fit multilevel model (students within schools, higher level first)
fit <- nl_fit(
  data    = nlme::Orthodont,
  y       = "distance",
  x       = "age",
  cluster = "Subject",
  df      = "auto"
)
fit

# 3. Coefficient table
nl_summary(fit)

# 4. Multilevel R-squared
nl_r2(fit)

# 5. Model comparison
nl_compare(fit)

# 6. Predictions with CI
pred <- nl_predict(fit, se = TRUE)
nl_plot(pred_df = pred, x = "age", show_ci = TRUE, type = "trajectory")

# 7. Derivatives and turning points
deriv <- nl_derivatives(pred, x = "age")
tp    <- nl_turning_points(deriv, x = "age")
tp$turning_points

nl_plot(deriv_df = deriv, x = "age", type = "slope")
nl_plot(deriv_df = deriv, x = "age", type = "curvature")

# 8. Cluster heterogeneity
nl_het(fit)
```

---

## Changelog

### 0.2.0 (2026)
- **NEW** Cross-classified and nested multilevel structures (`nested` argument)
- **NEW** CI for `glmerMod` via delta method and parametric bootstrap
- **NEW** Automatic df / knot selection (`df = "auto"`, `nl_knots()`)
- **NEW** Multilevel R-squared decomposition -- marginal, conditional,
  level-specific (`nl_r2()`)
- **NEW** First and second derivatives with CI (`nl_derivatives()`)
- **NEW** Turning points, inflection regions, slope regions
  (`nl_turning_points()`)
- **NEW** Built-in model comparison workflow (`nl_compare()`)
- **NEW** Cluster heterogeneity analysis with LRT (`nl_het()`)
- **NEW** B-spline basis (`method = "bs"`, `bs_degree`)
- **NEW** Random spline slopes (`random_slope = TRUE`)
- **ENHANCED** `nl_plot()` gains `type = "slope"`, `"curvature"`, `"combo"`

### 0.1.0 (2026-02-27)
- Initial release: `nl_fit`, `nl_predict`, `nl_plot`, `nl_summary`, `nl_icc`

---

## Citation

Hait, S. (2026). *MultiSpline: Spline-Based Nonlinear Modeling for Multilevel
and Longitudinal Data* (R package version 0.2.0).
https://github.com/causalfragility-lab/MultiSpline

---

## References

- Nakagawa, S., & Schielzeth, H. (2013). A general and simple method for
  obtaining R-squared from generalized linear mixed-effects models.
  *Methods in Ecology and Evolution*, 4(2), 133--142.
- Nakagawa, S., Johnson, P. C. D., & Schielzeth, H. (2017). The coefficient
  of determination R-squared from generalized linear mixed-effects models
  revisited and expanded. *Journal of the Royal Society Interface*, 14(134).
- Rights, J. D., & Sterba, S. K. (2019). Quantifying explained variance in
  multilevel models. *Psychological Methods*, 24(3), 309--338.
- Wood, S. N. (2017). *Generalized Additive Models: An Introduction with R*
  (2nd ed.). Chapman & Hall/CRC.
- Bates, D., Machler, M., Bolker, B., & Walker, S. (2015). Fitting linear
  mixed-effects models using lme4. *Journal of Statistical Software*, 67(1). 
