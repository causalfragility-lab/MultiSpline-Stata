{smcl}
{* *! version 1.0.4  Subir Hait  01mar2026}{...}
{hline}
help for {cmd:multispline}
{hline}

{title:Title}

{phang}
{bf:multispline} {hline 2} Nonlinear multilevel spline modeling

{title:Syntax}

{p 8 17 2}
{cmd:multispline}
{depvar}
{indepvar}
{ifin},
{cmd:cluster(}{varname}{cmd:)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt cluster(varname)}}grouping variable for multilevel model{p_end}

{syntab:Optional}
{synopt:{opt nknots(#)}}number of spline knots; default is {cmd:nknots(4)}{p_end}
{synopt:{opt autoknots}}automatically select optimal number of knots{p_end}
{synopt:{opt at(numlist)}}predict over range defined by numlist{p_end}
{synopt:{opt plot}}display plot of nonlinear fit{p_end}
{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
{cmd:multispline} fits nonlinear multilevel regression models using
natural cubic spline basis expansion. It provides a unified workflow
for fitting, predicting, visualizing, and summarizing nonlinear effects
in hierarchical or longitudinal data.

{pstd}
The command is particularly suited to large-scale education and health
datasets such as ECLS-K, HSLS, and PISA where outcomes are expected
to have nonlinear relationships with predictors such as socioeconomic
status (SES) or treatment dosage.

{pstd}
While Stata provides {cmd:mixed} for multilevel models and
{cmd:mkspline} for spline construction, no existing Stata command
provides a unified workflow for fitting, predicting, visualizing,
and computing ICCs from nonlinear multilevel models.
{cmd:multispline} fills this gap.

{title:Options}

{phang}
{opt cluster(varname)} specifies the grouping variable for the
multilevel model. Required.

{phang}
{opt nknots(#)} specifies the number of knots for the cubic spline
basis. Default is 4. Must be >= 3.

{phang}
{opt autoknots} automatically selects the optimal number of knots
between 4 and 7 based on the number of unique values of the predictor
using floor(sqrt(n)).

{phang}
{opt at(numlist)} generates predictions over a 50-point grid
spanning the range defined by the numlist values.
Useful for producing smooth prediction curves.

{phang}
{opt plot} displays a plot of the predicted nonlinear relationship.

{title:Remarks}

{pstd}
The {cmd:multispline} command implements a five-step workflow:{p_end}

{phang2}
1. Interior knots are placed at quantiles of the predictor distribution.{p_end}
{phang2}
2. A natural cubic spline basis is constructed via {cmd:mkspline}.{p_end}
{phang2}
3. A linear mixed-effects model is estimated via {cmd:mixed}.{p_end}
{phang2}
4. The intraclass correlation coefficient (ICC) is computed via {cmd:estat icc}.{p_end}
{phang2}
5. Predicted values are stored in {cmd:__ms_fit} and optionally plotted.{p_end}

{pstd}
The {cmd:multispline} approach requires a continuous predictor and
sufficient between-cluster variability. When predictors are discrete
or between-cluster variance is negligible, spline basis expansion may
become unstable and simpler modeling approaches may be more appropriate.
Users are encouraged to examine the ICC and likelihood-ratio test output
to assess the appropriateness of the multilevel specification.

{title:Examples}

{pstd}
{bf:Example 1: Education — SES and math achievement}

{phang2}{cmd:. multispline math_score ses, cluster(schid) nknots(4) plot}{p_end}

{pstd}
{bf:Example 2: Automatic knot selection}

{phang2}{cmd:. multispline math_score ses, cluster(schid) autoknots plot}{p_end}

{pstd}
{bf:Example 3: Grid predictions}

{phang2}{cmd:. multispline math_score ses, cluster(schid) nknots(4) at(-3 -2 -1 0 1 2 3) plot}{p_end}

{pstd}
{bf:Example 4: Health science — dosage and response}

{phang2}{cmd:. multispline bloodpressure dosage, cluster(hospital) nknots(4) plot}{p_end}

{pstd}
{bf:Example 5: Labor economics — age and wage (NLSW88)}

{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. multispline wage age, cluster(industry) nknots(4) plot}{p_end}

{title:Stored results}

{pstd}
{cmd:multispline} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(nknots)}}number of knots used{p_end}
{synopt:{cmd:r(nsplines)}}number of spline terms{p_end}
{synopt:{cmd:r(interior)}}number of interior knots{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(y)}}outcome variable name{p_end}
{synopt:{cmd:r(x)}}predictor variable name{p_end}
{synopt:{cmd:r(cluster)}}cluster variable name{p_end}
{synopt:{cmd:r(knots)}}interior knot locations{p_end}
{synopt:{cmd:r(cmd)}}command name{p_end}
{synoptline}
{p2colreset}{...}

{title:Citation}

{pstd}
If you use {cmd:multispline} in your research, please cite:

{phang}
Hait, S. 2026. MULTISPLINE: Stata module to perform nonlinear
multilevel spline modeling. {it:Statistical Software Components},
Boston College Department of Economics.
{browse "https://EconPapers.repec.org/RePEc:boc:bocode:s459620"}

{pstd}
BibTeX entry:

{phang}
@software{hait2026multispline,{break}
{space 2}author = {lcub}Hait, Subir{rcub},{break}
{space 2}title  = {lcub}MULTISPLINE: Stata module for nonlinear{break}
{space 10}multilevel spline modeling{rcub},{break}
{space 2}year   = {lcub}2026{rcub},{break}
{space 2}url    = {lcub}https://EconPapers.repec.org/{break}
{space 10}RePEc:boc:bocode:s459620{rcub}{break}
}

{title:Author}

{pstd}
Subir Hait{break}
Michigan State University{break}
haitsubi@msu.edu{break}
{browse "https://github.com/causalfragility-lab/MultiSpline-Stata"}{break}
{browse "https://authors.repec.org/pro/pha1643"}

{title:References}

{phang}
Bates, D., M. Maechler, B. Bolker, and S. Walker. 2015.
Fitting linear mixed-effects models using lme4.
{it:Journal of Statistical Software} 67(1): 1-48.

{phang}
Hastie, T., and R. Tibshirani. 1990.
{it:Generalized Additive Models}.
London: Chapman and Hall.

{phang}
Rabe-Hesketh, S., and A. Skrondal. 2012.
{it:Multilevel and Longitudinal Modeling Using Stata}.
3rd ed. College Station, TX: Stata Press.

{phang}
Raudenbush, S. W., and A. S. Bryk. 2002.
{it:Hierarchical Linear Models: Applications and Data Analysis Methods}.
2nd ed. Thousand Oaks, CA: Sage.

{title:Also see}

{psee}
{helpb mixed}, {helpb mkspline}, {helpb estat icc}
{p_end}
