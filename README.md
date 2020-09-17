# Diabetes prediction

#### Repo Structure!
  - `raw_data`: The raw data given to solve the challenge
  - `code`: The code developed to solve the problem, is developed in a jupyter notebook called `diabetes.ipynb`
  - `data`: The  datasets created while cleaning, exploring or transforming data. 
  - `img`: Picture that will be rendered in the notebook. They have been created using R (because  it's easier, faster (for visualize), and I am more efficient ploting data using R
  
#### Execution!
In the Makefile are the main commands to 
* install the virtual environment 
```sh
$ make _install_pipfile
```
* run the notebook in that virtual environment 
```sh
$ make notebook
```

#### Dependencies
The main dependencies are 
* Python 3.8.5 
* [Pipenv](https://pipenv-fork.readthedocs.io/en/latest/)
    *  This is a tool that aims to bring the best of all packaging worlds. 
    *  It automatically creates and manages a virtualenv for your projects, as well as adds/removes packages from your Pipfile as you install/uninstall packages. 
    *  It also generates the ever-important Pipfile.lock, which is used to produce deterministic builds.
