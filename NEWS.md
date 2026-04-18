# MultiSpline Stata - Changelog

## v0.2.0 (2026-04-18)

### New features
- **GLMM support**: binary outcomes via `family(logit)` and `family(probit)`,
  using `melogit`/`meprobit` for multilevel binary models
- **Nakagawa-Schielzeth R-squared**: `r2` option now correctly implements
  R2m (marginal) and R2c (conditional) for LMM and GLMM, including
  distribution-specific variance (pi^2/3 for logit) in the denominator
- **Multilevel derivatives**: `derivatives` and `turning_points` options
  work under all clustering structures (LMM, nested, cross-classified)
- **Cluster heterogeneity diagnostics**: `het` option plots BLUP-based
  cluster trajectories and runs LRT comparing random slopes vs intercepts
- **Random spline slopes**: `randslope` allows the nonlinear trajectory
  to vary across clusters
- **Model summary block**: clean interpretive summary after every fit
  showing model type, df, N, clusters, AIC, BIC
- **Near-zero variance detection**: automatic note when random intercept
  variance is negligible (suggests single-level model)
- **Publication-ready output**: auto-scaled prediction tables, clean LRT
  formatting, ICC interpretation, GLMM model type labels

### Bug fixes
- `predict, xb fixedonly` failure on random-slope models     fallback
  to manual coefficient computation
- GLMM prediction on cleared dataset (`variable not found`)     use
  stored `_b[]` coefficients directly
- LRT chi2 displaying as `-0.000` at boundary     clamped to 0 with
  explanatory note
- `<0.001` in `di` statement causing `invalid name`     properly quoted
- Simulated data missing values for school-level random effects    
  corrected data generation approach in example scripts

### What is not yet in the Stata version (planned v0.3.0)
- GAM smooths (`mgcv`)
- Bootstrap CI for GLMM
- Variance partition table by level (r2_mlm style) for nested models

## v0.1.0 (2026-03-05)
- Initial release: `multispline`, `multispline_plot`
- OLS and LMM (single-level clustering)
- Natural cubic splines, automatic df selection
- Prediction, derivatives, turning points, inline plots
