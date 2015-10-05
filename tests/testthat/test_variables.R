context("setting variables")

riv = as.wateres("rivendell.txt", 14.4, 0.754)
monthly_evap = c(7, 14, 40, 62, 82, 96, 109, 102, 75, 48, 34, 13)

test_that("evaporation values are calculated for altitude", {
    riv = set_evaporation(riv, altitude = 529)
    expect_equivalent(
        riv$E, rep_len(c(6.81087601935, 13.62175203870, 40.86525611609, 61.29788417414,
        81.73051223219, 95.35226427089, 108.97401630959, 102.16314029024,
        74.91963621284, 47.67613213544, 34.05438009675, 13.6217520387), nrow(riv)))
})

test_that("evaporation values are set", {
    riv = set_evaporation(riv, rep_len(monthly_evap, nrow(riv)))
    expect_equivalent(riv$E, rep_len(monthly_evap, nrow(riv)))
})

test_that("evaporation monthly values are set", {
    riv = set_evaporation(riv, monthly_evap)
    expect_equivalent(riv$E, rep_len(monthly_evap, nrow(riv)))
})

test_that("evaporation values of incorrect length are rejected", {
    expect_error(set_evaporation(riv, monthly_evap[1:5]))
})