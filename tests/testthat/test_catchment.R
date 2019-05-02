context("calculation of system of reservoirs defined by catchments")

data_catch = data.frame(DTM = seq(as.Date("1982-11-01"), length.out = 7, by = "day"), PET = rep(0.5, 7), R = rep(24 * 3.6, 7))
res_data_c1 = data.frame(
    storage = c(1e7, 1e7, 1e7), area = c(1e2, 1e2, 1e2), part = c(0.25, 0.25, 0.5), is_main = c(TRUE, FALSE, FALSE), id = c("M1", "L1", "L2"),
    stringsAsFactors = FALSE)

test_that("simple system of catchment reservoirs is calculated", {
    res_data_c2 = res_data_c1
    res_data_c2$storage = res_data_c2$storage * 2

    catch1 = as.catchment(id = "C1", down_id = "C2", data = data_catch, area = 100, res_data = res_data_c1)
    catch2 = as.catchment(id = "C2", down_id = NA, data = data_catch, area = 200, res_data = res_data_c2)
    catch_system = as.catchment_system(catch1, catch2)

    yields = c(C1_M1 = 25, C1_L1 = 25, C1_L2 = 25, C2_M1 = 25, C2_L1 = 25, C2_L2 = 200)
    resul = calc_catchment_system(catch_system, yields)
    resul = resul$system_plain

    expect_equal(as.data.frame(resul$C1_M1), data.frame(inflow = rep(25, 7), storage = rep(1e7, 7), yield = rep(25, 7), precipitation = rep(0, 7), evaporation = rep(0.05, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C1_L1), as.data.frame(resul$C1_M1))
    expect_equal(as.data.frame(resul$C1_L2), data.frame(inflow = rep(50, 7), storage = rep(1e7, 7), yield = rep(50, 7), precipitation = rep(0, 7), evaporation = rep(0.05, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C1_outlet), data.frame(inflow = rep(100, 7), storage = rep(0, 7), yield = rep(100, 7), precipitation = rep(0, 7), evaporation = rep(0, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C2_M1), data.frame(inflow = rep(150, 7), storage = rep(2e7, 7), yield = rep(150, 7), precipitation = rep(0, 7), evaporation = rep(0.05, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C2_L1), data.frame(inflow = rep(50, 7), storage = rep(2e7, 7), yield = rep(50, 7), precipitation = rep(0, 7), evaporation = rep(0.05, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C2_L2), data.frame(inflow = rep(100, 7), storage = c(11.36e6, 2.72e6, rep(0, 5)), yield = c(rep(200, 2), 131.4815, rep(100, 4)), precipitation = rep(0, 7), evaporation = rep(0.05, 7), wateruse = rep(0, 7), deficit = c(rep(0, 2), 5.92e6, rep(8.64e6, 4))), tolerance = 1e-5)
    expect_equal(as.data.frame(resul$C2_outlet), data.frame(inflow = c(rep(400, 2), 331.4815, rep(300, 4)), storage = rep(0, 7), yield = c(rep(400, 2), 331.4815, rep(300, 4)), precipitation = rep(0, 7), evaporation = rep(0, 7), wateruse = rep(0, 7), deficit = rep(0, 7)), tolerance = 1e-5)
})

test_that("system with no main or lateral reservoir is calculated", {
    res_data_c1$is_main = TRUE
    res_data_c2 = res_data_c1
    res_data_c2$storage = res_data_c2$storage * 2
    res_data_c2$is_main = FALSE

    catch1 = as.catchment(id = "C1", down_id = "C2", data = data_catch, area = 100, res_data = res_data_c1)
    catch2 = as.catchment(id = "C2", down_id = NA, data = data_catch, area = 200, res_data = res_data_c2)
    catch_system = as.catchment_system(catch1, catch2)

    yields = c(C1_M1 = 25, C1_L1 = 25, C1_L2 = 25, C2_M1 = 25, C2_L1 = 25, C2_L2 = 200)
    resul = calc_catchment_system(catch_system, yields)
})