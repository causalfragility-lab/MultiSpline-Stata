*******************************************************
*******************************************************
* multispline_simulation.do
* Replication file for multispline manuscript
* Author: Subir Hait
* Michigan State University
* Date: 20260302
*
* This script reproduces the simulation study
* comparing linear, quadratic, and multispline models.
*
* Instructions: Set your working directory below
* before running this script.
*******************************************************
*******************************************************
version 14.1
clear all
set more off
set scheme s1mono

* ---- set working folder (edit path as needed)
* cd "your/working/directory/here"

* ---- start log
log using "multispline_simulation.log", replace text

* ---- ensure packages installed
cap which multispline
if _rc ssc install multispline, replace
cap which esttab
if _rc ssc install estout, replace

* ============================================
* 1) Generate clustered nonlinear data
* ============================================
set seed 42
set obs 1000
gen schid = ceil(_n/50)
gen x     = rnormal(0,1)

* true quadratic mean + individual noise (sd=3)
gen y = 50 + 0.9*x - 0.25*x^2 + rnormal(0,3)

* cluster random intercept u_j (sd=3)
bysort schid: gen uj = rnormal(0,3)
bysort schid: replace uj = uj[1]
replace y = y + uj

* true quadratic curve for figure
gen y_true = 50 + 0.9*x - 0.25*x^2

* ============================================
* 2) Linear mixed model
* ============================================
mixed y x || schid:
estimates store linear

* ============================================
* 3) Quadratic mixed model (true model)
* ============================================
gen x2 = x^2
mixed y x x2 || schid:
estimates store quadratic

* ============================================
* 4) multispline fixed knots
* ============================================
multispline y x, cluster(schid) nknots(4)
estimates restore _ms_model
estimates store spline4
predict double yhat_spline4, xb

* ============================================
* 5) multispline autoknots
* ============================================
multispline y x, cluster(schid) autoknots
estimates restore _ms_model
estimates store spline_auto
predict double yhat_spline_auto, xb

* ============================================
* 6) Model comparison table (LL, AIC, BIC, N)
* ============================================
esttab linear quadratic spline4 spline_auto ///
    , stats(ll aic bic N) ///
      title("Model Comparison") ///
      nomtitles nonotes

* ============================================
* 7) Visualization
* ============================================
sort x
twoway ///
  (scatter y x, msize(vsmall) mcolor(gs12)) ///
  (line y_true x, sort lcolor(black) lpattern(dash) lwidth(thin)) ///
  (line yhat_spline4 x, sort lcolor(black) lpattern(solid) lwidth(medthick)) ///
  (line yhat_spline_auto x, sort lcolor(black) lpattern(shortdash) lwidth(medthick)) ///
  , legend(order(2 "True quadratic" 3 "multispline, nknots(4)" 4 "multispline, autoknots")) ///
    title("Nonlinear relationship recovery") ///
    ytitle("Outcome y") xtitle("Predictor x")

graph export "multispline_simulation_plot.eps", replace

log close
*******************************************************
