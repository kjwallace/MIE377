
# Credit
Following code was created in a group project for MIE377 at the university of toronto. 
The code consists both Projects 1 and Projects 2. 

Editing the config.json doc will configure how the model operates. All parameters, what they are and how they perform can be found in the write up doc.
Code is under-commented as it was mainly used to develop and validate models against training data.



# To-Do

  

- Integrate Monte Carlo Sims with CVaR Optimization

- Make everything robust

- Migrate the good stuff from Project 1

  

# When Running the Code

  

- The `config.json` file contains most of the configurable parameters and optimization/factor techniques. This is to make sure we don't run in to errors with compatibility between our computers. When you are creating a new algorithm, please put all parameters in that file and read it like I have in `Project2_Function.m`
- You may get errors when you run this, because I put files in folders. Run these lines before compiling:
	- `addpath('MonteCarlo')`
	- `addpath('OptimizationTechniques')`
	- `addpath('Data')`
	- `addpath('Util')`
    - `addpath('FactorModels')`

