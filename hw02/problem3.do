// Import the csv file.
import delimited "K:\data\cars.csv"
// Open the browser.
browse *

// Rename the columns.
rename dimensionsheight H
rename dimensionslength L
rename dimensionswidth W
rename engineinformationdriveline driveline
rename engineinformationenginetype engine_type
rename engineinformationhybrid hybrid
rename engineinformationnumberofforward gears
rename engineinformationtransmission transmission
rename fuelinformationcitympg city_mpg
rename fuelinformationfueltype fuel_type
rename fuelinformationhighwaympg highway_mpg
rename identificationclassification classification
rename identificationid id
rename identificationmake make
rename identificationmodelyear model_year
rename identificationyear year
rename engineinformationenginestatistic horsepower
rename v18 torque

// Restrict the data to cars whose Fuel Type is "Gasoline".
keep if fuel_type == "Gasoline"

// Fit a linear regression model predicting MPG on the highway with horsepower as predictor. 
regress highway_mpg c.horsepower c.torque c.H c.L c.W i.year 
// Refit the model with torque added.
regress highway_mpg c.horsepower##c.torque c.H c.L c.W i.year
								  
// Print the interaction plot
codebook horsepower
codebook torque
margins, at(horsepower = (159/372) torque = (177 257 332) year = (2011))
marginsplot

// Put matrices into mata.
putmata highway_mpg horsepower torque H L W year, replace

mata:
horsepower_torque = horsepower :* torque
year_2010 = year :== 2010
year_2011 = year :== 2011
year_2012 = year :== 2012

design_matrix = (J(4591, 1, 1), horsepower, torque, horsepower_torque, H, L, W, year_2010, year_2011, year_2012)

XT_X = design_matrix' * design_matrix
XT_X_i = luinv(XT_X)
beta = XT_X_i * design_matrix' * highway_mpg

beta

end