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
*******************************************************
*******************************************************

version 14.1
clear all
set more off

* ---- set working folder (edit as needed)
cd "C:\Users\haitsubi\OneDrive - Michigan State University\Desktop"

* ---- start log (raw reproducible output)
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
 (line yhat_spline4 x, sort lwidth(medthick)) ///
 (line yhat_spline_auto x, sort lwidth(medthick)) ///
 , legend(order(2 "multispline (4 knots)" 3 "multispline (autoknots)")) ///
   title("Nonlinear relationship recovery") ///
   ytitle("Outcome y") xtitle("Predictor x")

graph export "multispline_simulation_plot.pdf", replace

log close
*******************************************************
